const std = @import("std");

const ir = @import("ir.zig");
const utils = @import("utils.zig");

const boxedFields = std.StaticStringMap(void).initComptime(.{
    .{ "Identifier.assigner", {} },
});

pub fn buildIntermediateRepresentationFromBundles(arena: std.mem.Allocator, bundles: []const std.json.Parsed(std.json.Value)) !std.ArrayList(ir.FhirType) {
    var fhirTypesArr = try std.ArrayList(ir.FhirType).initCapacity(arena, 3000);

    for (bundles) |bundle| {
        const builtTypes = try buildFromBundle(arena, bundle);
        try fhirTypesArr.appendSlice(arena, builtTypes.items);
    }

    var proccessedCount: usize = 0;

    while (proccessedCount < fhirTypesArr.items.len) {
        std.debug.print("processing for backbone elements... {d}\n", .{proccessedCount});
        const end = fhirTypesArr.items.len;
        for (fhirTypesArr.items[proccessedCount..end], proccessedCount..) |_, index| {
            try parseBackbonelementsFromFhirTypes(arena, &fhirTypesArr, index);
        }
        proccessedCount = end;
    }

    // oneOf handling
    var resourceNames = try std.ArrayList([]const u8).initCapacity(arena, 150);
    for (fhirTypesArr.items) |t| {
        switch (t) {
            .structure => |s| if (s.is_resource) try resourceNames.append(arena, s.name),
            else => {},
        }
    }
    try fhirTypesArr.append(arena, .{ .oneOf = .{ .name = "Resource", .refs = try resourceNames.toOwnedSlice(arena) } });

    return fhirTypesArr;
}

// TODO: This dumpster does not handle bad json structure... at all
fn buildFromBundle(arena: std.mem.Allocator, bundle: std.json.Parsed(std.json.Value)) !std.ArrayList(ir.FhirType) {
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
        const fhirType = parseEntryFromBundle(arena, entry) catch |err| {
            const debugId = utils.extractDebugId(arena, entry);
            std.debug.print("Failed to parse entry {s}: {s}\n", .{ debugId, @errorName(err) });
            continue;
        };
        if (fhirType) |t| try fhirTypesArr.append(arena, t);
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

    const id = try utils.getStr(resource, "id");

    const resourceType = try utils.getStr(resource, "resourceType");

    const description = utils.getStr(resource, "description") catch "";

    if (std.mem.eql(u8, id, "xhtml")) {
        var fields = try std.ArrayList(ir.FhirField).initCapacity(arena, 2);
        try fields.append(arena, .{ .name = "id", .description = null, .type_ref = .{ .primitive = "[]const u8" }, .is_optional = true, .is_slice = false });
        try fields.append(arena, .{ .name = "extension", .description = null, .type_ref = .{ .ref = "Extension" }, .is_optional = true, .is_slice = true });
        try fields.append(arena, .{ .name = "value", .description = "Actual xhtml", .type_ref = .{ .primitive = "[]const u8" }, .is_optional = false, .is_slice = false });
        fhirType = .{ .structure = .{ .name = id, .fields = fields, .is_resource = false, .description = description } };
        return fhirType;
    }

    if (std.mem.eql(u8, resourceType, "StructureDefinition")) {
        const kind = try utils.getStr(resource, "kind");

        const isResource = std.mem.eql(u8, kind, "resource");
        const isAbstract = utils.getBool(resource, "abstract") catch false;
        if (isAbstract and isResource) return null;

        const baseTypeName = try utils.getStr(resource, "type");

        const snapshotObj = try utils.getObj(resource, "snapshot");
        const elementsArr = try utils.getArr(snapshotObj, "element");

        var fields = try std.ArrayList(ir.FhirField).initCapacity(arena, elementsArr.items.len);
        for (elementsArr.items) |element| {
            const elementObj = switch (element) {
                .object => |o| o,
                else => return error.ElementIsNotAnObject,
            };
            const path = try utils.getStr(elementObj, "path");

            if (std.mem.eql(u8, path, baseTypeName)) continue;

            // TODO: slice refinement base element already covers the field; phase-3: capture for discriminator validation
            if (elementObj.get("sliceName") != null) continue;

            const field = try parseFhirFieldFromSnapshotElement(arena, baseTypeName, elementObj, path);
            try fields.append(arena, field);
        }

        fhirType = .{ .structure = .{ .name = id, .fields = fields, .is_resource = isResource, .description = description } };
    }

    return fhirType;
}

fn parseFhirFieldFromSnapshotElement(arena: std.mem.Allocator, topLevelId: []const u8, element: std.json.ObjectMap, path: []const u8) !ir.FhirField {
    var id = stripTopLevelPrefix(path, topLevelId);
    const minSigned = try utils.getInt(element, "min");
    const maxStr = try utils.getStr(element, "max");
    const definition = try utils.getStr(element, "definition");

    var isSlice = false;
    var max: ?u32 = null;

    if (std.mem.eql(u8, maxStr, "*")) {
        isSlice = true;
    } else {
        const parsedMax = try std.fmt.parseUnsigned(u32, maxStr, 10);
        max = parsedMax;
        isSlice = parsedMax > 1;
    }

    const min: u32 = @intCast(minSigned);

    const isOptional = if (min == 0) true else false;

    var fieldType: ir.FieldType = .{ .primitive = "unknown" };

    if (std.mem.containsAtLeast(u8, id, 1, "[x]")) {
        if (std.mem.find(u8, id, "[")) |idSplitIdx| {
            id = id[0..idSplitIdx];
            const typeArray = try utils.getArr(element, "type");
            var choices = try std.ArrayList(ir.ChoiceOption).initCapacity(arena, typeArray.items.len);

            for (typeArray.items) |typeArrayItem| {
                switch (typeArrayItem) {
                    .object => |typeObj| {
                        const codeString = utils.getStr(typeObj, "code") catch continue;
                        const suffix = try utils.capitalizeFirstLetter(arena, codeString);
                        const typeRef = try resolveFieldTypeFromTypeObject(typeObj);
                        try choices.append(arena, .{ .suffix = suffix, .typeRef = typeRef });
                    },
                    else => {},
                }
            }

            fieldType = .{ .choice = try choices.toOwnedSlice(arena) };
        }
    } else if (element.get("contentReference")) |contentRef| {
        switch (contentRef) {
            .string => |contentReferenceString| {
                const cleanedRefStr = cleanRef(contentReferenceString);

                const structName = try contentReferenceStringToRefStructName(arena, cleanedRefStr);

                fieldType = .{ .ref = structName };
            },
            else => {},
        }
    } else if (element.get("type")) |elementTypeValue| {
        switch (elementTypeValue) {
            .array => |typeArray| {
                if (typeArray.items.len == 1) {
                    const firstTypeValue = typeArray.items[0];
                    switch (firstTypeValue) {
                        .object => |firstType| {
                            fieldType = try resolveFieldTypeFromTypeObject(firstType);
                        },
                        else => {},
                    }
                }
            },
            else => {},
        }
    }

    const compositeKey = try std.fmt.allocPrint(arena, "{s}.{s}", .{ topLevelId, id });
    const needsBox = boxedFields.has(compositeKey);

    return ir.FhirField{ .name = id, .type_ref = fieldType, .is_optional = isOptional, .is_slice = isSlice, .description = definition, .is_boxed = needsBox, .min = min, .max = max };
}

fn resolveFieldTypeFromTypeObject(typeObj: std.json.ObjectMap) !ir.FieldType {
    const codeString = try utils.getStr(typeObj, "code");

    var fieldType: ir.FieldType = .{ .ref = codeString };

    if (std.mem.startsWith(u8, codeString, "http://hl7.org/fhirpath/System.")) {
        if (typeObj.get("extension")) |extension| {
            if (try attemptToRetrieveValueUrlFromExtension(extension)) |valueStr| {
                fieldType = .{ .primitive = valueStr };
            }
        }
    }

    return fieldType;
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
        const obj = switch (extension) {
            .object => |o| o,
            else => continue,
        };

        const url = utils.getStr(obj, "url") catch continue;

        if (std.mem.eql(u8, "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type", url)) {
            const valueUrl = utils.getStr(obj, "valueUrl") catch continue;
            return valueUrl;
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

fn cleanRef(ref: []const u8) []const u8 {
    const prefix = "#";
    if (std.mem.startsWith(u8, ref, prefix)) {
        return ref[prefix.len..];
    } else {
        return ref;
    }
}

fn contentReferenceStringToRefStructName(arena: std.mem.Allocator, contentRefStr: []const u8) ![]const u8 {
    var copy = try arena.dupe(u8, contentRefStr);
    for (contentRefStr, 0..) |_, idx| {
        const thing = contentRefStr[idx];
        if (thing == '.') {
            copy[idx] = '_';
            if (idx + 1 >= contentRefStr.len) return error.MalformedContentReference;
            copy[idx + 1] = std.ascii.toUpper(contentRefStr[idx + 1]);
        }
    }
    return copy;
}
