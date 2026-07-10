const std = @import("std");
// TODO: this crap needs to stream at some point, file in, ir streamed out

const ir = @import("ir.zig");
const utils = @import("utils.zig");

const boxedFields = std.StaticStringMap(void).initComptime(.{
    .{ "Identifier.assigner", {} },
});

// TODO: Handle [x] fields...???
// TODO: This dumpster does not handle bad json structure... at all
pub fn buildIntermediateRepresentationFromBundles(arena: std.mem.Allocator, bundle: std.json.Parsed(std.json.Value)) !std.ArrayList(ir.FhirType) {
    std.debug.print("Building IR from bundle...\n", .{});

    const obj = switch (bundle.value) {
        .object => |o| o,
        else => return ir.FhirIntermediateRepresentationError.InvalidFormat,
    };

    const entryArrayValue = obj.get("entry") orelse
        return ir.FhirIntermediateRepresentationError.MissingEntryJsonValue;

    const entryArray = switch (entryArrayValue) {
        .array => |a| a,
        else => return ir.FhirIntermediateRepresentationError.BundleEntryNotAnArray,
    };

    var fhirTypesArr = try std.ArrayList(ir.FhirType).initCapacity(arena, 1000);

    for (entryArray.items) |entry| {
        const fhirType = parseEntryFromBundle(arena, entry) catch {
            std.debug.print("Error parsing entry from bundle", .{});
            continue;
        };

        if (fhirType) |t| {
            try fhirTypesArr.append(arena, t);
        }
    }

    var proccessedCount: usize = 0;

    while (proccessedCount < fhirTypesArr.items.len) {
        std.debug.print("while loop... {d}\n", .{proccessedCount});
        const end = fhirTypesArr.items.len;
        for (fhirTypesArr.items[proccessedCount..end], proccessedCount..) |_, index| {
            std.debug.print("inside for loop - {d}\n", .{index});
            try parseBackbonelementsFromFhirTypes(arena, &fhirTypesArr, index);
        }
        proccessedCount = end;
    }

    return fhirTypesArr;
}

fn parseEntryFromBundle(arena: std.mem.Allocator, entry: std.json.Value) !?ir.FhirType {
    const entryObj = switch (entry) {
        .object => |o| o,
        else => return ir.FhirIntermediateRepresentationError.InvalidFormat,
    };
    const resourceValue = entryObj.get("resource") orelse return ir.FhirIntermediateRepresentationError.NoResourceObjOnEntry;

    const resource = switch (resourceValue) {
        .object => |o| o,
        else => return ir.FhirIntermediateRepresentationError.EntryResourceNotAnObject,
    };

    var fhirType: ?ir.FhirType = null;

    const id = resource.get("id").?.string;

    const resourceType = resource.get("resourceType").?.string;

    const resourceKindValue = resource.get("kind") orelse return error.NoKindOnResource;
    const kind = switch (resourceKindValue) {
        .string => |o| o,
        else => {
            std.debug.print("Failed to parse kind for {s}\n", .{id});
            return error.KindValueNotAString;
        },
    };

    const isResource = std.mem.eql(u8, kind, "resource");
    const description = if (resource.get("description")) |d| d.string else "";

    if (std.mem.eql(u8, resourceType, "StructureDefinition")) {
        const elementsArr = resource.get("snapshot").?.object.get("element").?.array;
        var fields = try std.ArrayList(ir.FhirField).initCapacity(arena, elementsArr.items.len);
        for (elementsArr.items) |element| {
            const path = element.object.get("path").?.string;
            if (std.mem.eql(u8, path, id)) continue;

            const field = try parseFhirFieldFromSnapshotElement(arena, id, element);
            try fields.append(arena, field);
        }

        fhirType = .{ .structure = .{ .name = id, .fields = fields, .is_resource = isResource, .description = description } };
    }

    return fhirType;
}

fn parseFhirFieldFromSnapshotElement(arena: std.mem.Allocator, topLevelId: []const u8, element: std.json.Value) !ir.FhirField {
    const path = element.object.get("path").?.string;
    const id = stripTopLevelPrefix(path, topLevelId);
    const minSigned = element.object.get("min").?.integer;
    const maxStr = element.object.get("max").?.string;
    const definition = element.object.get("definition").?.string;

    var isSlice = false;
    var max: ?u32 = null;

    if (std.mem.eql(u8, maxStr, "*")) {
        isSlice = true;
    } else {
        max = try std.fmt.parseUnsigned(u32, maxStr, 10);
    }

    const min: u32 = @intCast(minSigned);

    const isOptional = if (min == 0) true else false;

    var fieldType: ir.FieldType = .{ .primitive = "unknown" };

    if (element.object.get("contentReference")) |_| {
        // TODO: figure out content reference
        std.debug.print("has content reference value, figure it out - {s}\n ", .{id});
    }

    if (element.object.get("type")) |elementTypeValue| {
        switch (elementTypeValue) {
            .array => |typeArray| {
                if (typeArray.items.len == 1) {
                    const firstTypeValue = typeArray.items[0];
                    switch (firstTypeValue) {
                        .object => |firstType| {
                            if (firstType.get("code")) |code| {
                                fieldType = .{ .ref = code.string };
                                if (std.mem.startsWith(u8, code.string, "http://hl7.org/fhirpath/System.")) {
                                    if (firstType.get("extension")) |extension| {
                                        if (try attemptToRetrieveValueUrlFromExtension(extension)) |valueStr| {
                                            fieldType = .{ .primitive = valueStr };
                                        }
                                    }
                                }
                            } else {
                                std.debug.print("Parsing the first type value something slipped through - {s}\n", .{id});
                            }
                        },
                        else => {},
                    }
                } else if (typeArray.items.len > 1) {
                    // TODO: handle this case
                }
            },
            else => {},
        }
    }

    const compositeKey = try std.fmt.allocPrint(arena, "{s}.{s}", .{ topLevelId, id });
    const needsBox = boxedFields.has(compositeKey);

    return ir.FhirField{ .name = id, .type_ref = fieldType, .is_optional = isOptional, .is_slice = isSlice, .description = definition, .is_boxed = needsBox, .min = min, .max = max };
}

fn stripTopLevelPrefix(path: []const u8, topLevelId: []const u8) []const u8 {
    if (std.mem.startsWith(u8, path, topLevelId) and path.len > topLevelId.len and path[topLevelId.len] == '.') {
        return path[topLevelId.len + 1 ..];
    }
    return path;
}

fn attemptToRetrieveValueUrlFromExtension(extensionValue: std.json.Value) !?[]const u8 {
    const extensionArray = switch (extensionValue) {
        .array => |a| a,
        else => return error.ExtensionIsNotAnArray,
    };

    for (extensionArray.items) |extension| {
        switch (extension) {
            .object => |obj| {
                if (obj.get("url")) |url| {
                    if (std.mem.eql(u8, "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type", url.string)) {
                        if (obj.get("valueUrl")) |value| {
                            return value.string;
                        }
                    }
                }
            },
            else => continue,
        }
    }

    std.debug.print("value url not on extension, GFL\n", .{});
    return null;
}

fn parseBackbonelementsFromFhirTypes(
    arena: std.mem.Allocator,
    // Pointer to the fhirTypesArr that we're collecting all the fhir types into
    fhirTypesArr: *std.ArrayList(ir.FhirType),
    fhirTypeIdx: usize,
) !void {
    const fhirType = fhirTypesArr.items[fhirTypeIdx];
    if (doesFhirTypeHaveBackboneElement(fhirType)) {
        switch (fhirType) {
            .structure => |fhirStruct| {
                var fields = try std.ArrayList(ir.FhirField).initCapacity(arena, fhirStruct.fields.items.len);
                //
                // DOD style crosswalk to index ref the fhirTypes
                var fhirTypesLookup = try std.ArrayList([]const u8).initCapacity(arena, 5);
                var fhirTypes = try std.ArrayList(ir.FhirType).initCapacity(arena, 5);

                for (fhirStruct.fields.items) |field| {
                    if (std.mem.containsAtLeast(u8, field.name, 1, ".")) {
                        for (fhirTypesLookup.items, 0..) |typeLookup, i| {
                            if (std.mem.startsWith(u8, field.name, typeLookup)) {
                                var fhirTypeToUpdate = fhirTypes.items[i];

                                var updatedField = field;
                                updatedField.name = field.name[typeLookup.len + 1 ..];

                                try fhirTypeToUpdate.structure.fields.append(arena, updatedField);
                                fhirTypes.items[i] = fhirTypeToUpdate;

                                break;
                            }
                        }
                    } else if (isFieldBackboneElement(field)) {
                        var modField = field;
                        try fhirTypesLookup.append(arena, modField.name);
                        const newName = try buildBackboneElementStructName(arena, fhirStruct.name, modField.name);
                        modField.type_ref = .{ .ref = newName };
                        try fields.append(arena, modField);
                        const newFhirType: ir.FhirType_Structure = .{
                            .name = newName,
                            .description = modField.description,
                            .is_resource = false,
                            .fields = try std.ArrayList(ir.FhirField).initCapacity(arena, 5),
                        };
                        try fhirTypes.append(arena, .{ .structure = newFhirType });
                    } else {
                        try fields.append(arena, field);
                    }
                }

                var modFhirStruct = fhirStruct;
                modFhirStruct.fields = fields;
                fhirTypesArr.items[fhirTypeIdx] = .{ .structure = modFhirStruct };

                try fhirTypesArr.appendSlice(arena, try fhirTypes.toOwnedSlice(arena));
            },
            else => {},
        }
    }
}

fn doesFhirTypeHaveBackboneElement(fhirType: ir.FhirType) bool {
    switch (fhirType) {
        .structure => |fhirStruct| {
            for (fhirStruct.fields.items) |field| {
                switch (field.type_ref) {
                    .ref => |r| {
                        if (std.mem.eql(u8, r, "BackboneElement") or std.mem.eql(u8, r, "Element")) {
                            return true;
                        }
                    },
                    else => {},
                }
            }
        },
        // TODO: Can anything else have BackboneElements?
        else => {},
    }

    return false;
}

fn isFieldBackboneElement(fhirType: ir.FhirField) bool {
    switch (fhirType.type_ref) {
        .ref => |r| {
            if (std.mem.eql(u8, r, "BackboneElement") or std.mem.eql(u8, r, "Element")) {
                return true;
            }
        },
        else => {},
    }

    return false;
}

fn buildBackboneElementStructName(arena: std.mem.Allocator, topLevelName: []const u8, elementName: []const u8) ![]const u8 {
    const tln = try utils.capitalizeFirstLetter(arena, topLevelName);
    const en = try utils.capitalizeFirstLetter(arena, elementName);

    const parts = &[_][]const u8{ tln, "_", en };
    return try std.mem.concat(arena, u8, parts);
}
