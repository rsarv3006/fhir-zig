const std = @import("std");
// TODO: this crap needs to stream at some point, file in, ir streamed out

const ir = @import("ir.zig");

const boxedFields = std.StaticStringMap(void).initComptime(.{
    .{ "Identifier.assigner", {} },
});

// TODO: This dumpster does not handle bad json structure... at all
pub fn buildIntermediateRepresentationFromBundles(arena: std.mem.Allocator, fhirTypesArr: *std.ArrayList(ir.FhirType), bundle: std.json.Parsed(std.json.Value)) !void {
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

    for (entryArray.items) |entry| {
        const fhirType = parseEntryFromBundle(arena, entry) catch {
            continue;
        };

        if (fhirType) |t| {
            try fhirTypesArr.append(arena, t);
        }
    }
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
        // std.debug.print("{s} - {s}\n", .{ id, resourceType });

        const elementsArr = resource.get("snapshot").?.object.get("element").?.array;
        var fields = try std.ArrayList(ir.FhirField).initCapacity(arena, elementsArr.items.len);
        for (elementsArr.items) |element| {
            const path = element.object.get("path").?.string;
            if (std.mem.eql(u8, path, id)) continue;

            const field = try parseFhirFieldFromSnapshotElement(arena, id, element);
            try fields.append(arena, field);
        }

        fhirType = .{ .structure = .{ .name = id, .fields = try fields.toOwnedSlice(arena), .is_resource = isResource, .description = description } };
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

fn attemptToRetrieveValueUrlFromExtension(extension: std.json.Value) !?[]const u8 {
    const extensionArray = switch (extension) {
        .array => |a| a,
        else => return error.ExtensionIsNotAnArray,
    };

    if (extensionArray.items.len == 0) {
        return error.ExtensionArrayLenZero;
    }

    const extensionFirstItemObj = switch (extensionArray.items[0]) {
        .object => |o| o,
        else => return error.ExtensionFirstItemIsNotAnObject,
    };

    const maybeValue = extensionFirstItemObj.get("valueUrl");
    if (maybeValue) |value| {
        return value.string;
    }

    std.debug.print("value url not on extension, GFL\n", .{});
    return null;
}
