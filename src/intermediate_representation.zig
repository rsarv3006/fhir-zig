const std = @import("std");
// TODO: this crap needs to stream at some point, file in, ir streamed out

const ir = @import("ir.zig");

const boxedFields = std.StaticStringMap(void).initComptime(.{
    .{ "Identifier.assigner", {} },
});

// TODO: All this garbage will panic as written (specifically the json unwrapping without checking)
pub fn buildIntermediateRepresentation(arena: std.mem.Allocator, parsed: std.json.Parsed(std.json.Value)) ir.FhirIntermediateRepresentationError!std.ArrayList(ir.FhirType) {
    std.debug.print("Building Intermediate Representation...\n", .{});
    const obj = switch (parsed.value) {
        .object => |o| o,
        else => return ir.FhirIntermediateRepresentationError.InvalidFormat,
    };

    const definitionsValue = obj.get("definitions") orelse
        return ir.FhirIntermediateRepresentationError.MissingDefinitions;

    const definitions = switch (definitionsValue) {
        .object => |o| o,
        else => return ir.FhirIntermediateRepresentationError.MissingDefinitions,
    };

    std.debug.print("definitions count: {d}\n", .{definitions.count()});
    const definitionsCount = definitions.count();

    var fhirTypes = try std.ArrayList(ir.FhirType).initCapacity(arena, definitionsCount);

    var iter = definitions.iterator();
    while (iter.next()) |entry| {
        const key = entry.key_ptr.*;

        const fhirType = parseDefinitionObject(arena, key, entry.value_ptr.*) catch {
            std.debug.print("Error parsing definition for {s}\n", .{key});
            continue;
        };

        try fhirTypes.append(arena, fhirType);
    }
    return fhirTypes;
}

fn parseDefinitionObject(arena: std.mem.Allocator, definitionsKey: []const u8, value: std.json.Value) !ir.FhirType {
    const obj = switch (value) {
        .object => |o| o,
        else => return ir.FhirIntermediateRepresentationError.InvalidFormat,
    };

    var requiredFields: ?std.json.Array = null;

    if (obj.get("required")) |requiredSliceMaybe| {
        requiredFields = switch (requiredSliceMaybe) {
            .array => |a| a,
            else => null,
        };
    }

    var fhirType: ir.FhirType = undefined;

    if (obj.get("properties")) |props| {
        switch (props) {
            .object => |props_obj| {
                var itr = props_obj.iterator();
                const propsLength = itr.len;

                var fields = try std.ArrayList(ir.FhirField).initCapacity(arena, propsLength);

                var isResource = false;
                while (itr.next()) |field| {
                    // resourceType is a discriminator constant, not a data field
                    if (std.mem.eql(u8, field.key_ptr.*, "resourceType")) {
                        isResource = true;
                        continue;
                    }
                    const parsedField = parseField(arena, definitionsKey, field.key_ptr.*, field.value_ptr.*, requiredFields) catch {
                        std.debug.print("Failed to parse field for {s}\n", .{field.key_ptr.*});
                        continue;
                    };
                    try fields.append(arena, parsedField);
                }

                var description: []const u8 = "";
                if (obj.get("description")) |descriptionOnObj| {
                    description = switch (descriptionOnObj) {
                        .string => |descriptionString| descriptionString,
                        else => "",
                    };
                }

                fhirType = .{ .structure = .{ .name = definitionsKey, .fields = try fields.toOwnedSlice(arena), .is_resource = isResource, .description = description } };
            },
            else => {},
        }
    } else if (obj.get("type")) |primitiveType| {
        const pattern: ?[]const u8 = if (obj.get("pattern")) |p| p.string else null;
        const typeString = switch (primitiveType) {
            .string => |str| str,
            else => return error.FieldNotString,
        };
        fhirType = .{ .primitive = .{ .name = definitionsKey, .pattern = pattern, .type = typeString } };
    } else if (obj.get("oneOf")) |oneOf| {
        std.debug.print("Top of oneOf check...\n", .{});
        const oneOfArr = switch (oneOf) {
            .array => |arr| arr,
            else => return error.FieldNotArray,
        };

        var cleanedRefArr = try std.ArrayList([]const u8).initCapacity(arena, oneOfArr.items.len);

        for (oneOfArr.items) |item| {
            // TODO: Un bork this
            if (item.object.get("$ref")) |val| {
                try cleanedRefArr.append(arena, cleanRef(val.string));
            }
        }

        fhirType = .{ .oneOf = .{ .name = definitionsKey, .refs = try cleanedRefArr.toOwnedSlice(arena) } };
    } else if (std.mem.eql(u8, definitionsKey, "xhtml")) {
        fhirType = .{ .primitive = .{
            .name = definitionsKey,
            .pattern = null,
            .type = "string",
        } };
    } else {
        return error.UnknownDefinitionType;
    }

    return fhirType;
}

fn parseField(arena: std.mem.Allocator, definitionsKey: []const u8, key: []const u8, value: std.json.Value, requiredFields: ?std.json.Array) !ir.FhirField {
    const obj = switch (value) {
        .object => |o| o,
        else => return error.FieldNotObject,
    };

    var fieldType: ir.FieldType = .{ .primitive = "unknown" };
    var isSlice = false;

    const compositeKey = try std.fmt.allocPrint(arena, "{s}.{s}", .{ definitionsKey, key });
    const needsBox = boxedFields.has(compositeKey); // or .get(...) != null

    if (obj.get("$ref")) |refTypeField| {
        switch (refTypeField) {
            .string => |refThingy| {
                fieldType = .{ .ref = cleanRef(refThingy) };
            },
            else => {},
        }
    } else if (obj.get("type")) |typeField| {
        switch (typeField) {
            .string => |typeName| {
                if (std.mem.eql(u8, typeName, "array")) {
                    isSlice = true;
                    fieldType = try getItemsRef(arena, value);
                } else if (std.mem.eql(u8, typeName, "number")) {
                    const pattern = if (obj.get("pattern")) |p| switch (p) {
                        .string => |s| s,
                        else => null,
                    } else null;

                    if (pattern) |pat| {
                        if (std.mem.indexOf(u8, pat, "\\.") != null) {
                            fieldType = .{ .primitive = "decimal" };
                        } else {
                            fieldType = .{ .primitive = "integer" };
                        }
                    } else {
                        return error.FailedToParsePatternForTypeNumber;
                    }
                } else {
                    fieldType = .{ .primitive = typeName };
                }
            },
            else => {},
        }
    } else if (obj.get("enum")) |enumField| {
        switch (enumField) {
            .array => |arr| {
                const len = arr.items.len;
                var enumItems = try std.ArrayList([]const u8).initCapacity(arena, len);
                for (arr.items) |enumItem| {
                    // TODO: This will probably blow up
                    try enumItems.append(arena, enumItem.string);
                }
                fieldType = .{ .inline_enum = try enumItems.toOwnedSlice(arena) };
            },
            else => {},
        }
    }

    var isOptional = true;
    if (requiredFields) |required| {
        for (required.items) |requiredField| {
            if (std.mem.eql(u8, requiredField.string, key)) {
                isOptional = false;
            }
        }
    }

    var description: []const u8 = "";
    if (obj.get("description")) |descriptionOnObj| {
        description = switch (descriptionOnObj) {
            .string => |descriptionString| descriptionString,
            else => "",
        };
    }

    return ir.FhirField{ .name = key, .type_ref = fieldType, .is_optional = isOptional, .is_slice = isSlice, .description = description, .is_boxed = needsBox };
}

fn cleanRef(ref: []const u8) []const u8 {
    const prefix = "#/definitions/";
    if (std.mem.startsWith(u8, ref, prefix)) {
        return ref[prefix.len..];
    } else {
        return ref;
    }
}

fn getItemsRef(arena: std.mem.Allocator, value: std.json.Value) !ir.FieldType {
    const obj = switch (value) {
        .object => |o| o,
        else => return error.FieldNotObject,
    };

    if (obj.get("items")) |items| {
        const itemsObj = switch (items) {
            .object => |o| o,
            else => return error.FieldNotObject,
        };

        if (itemsObj.get("$ref")) |ref| {
            switch (ref) {
                .string => |s| return .{ .ref = cleanRef(s) },
                else => {},
            }
        } else if (itemsObj.get("enum")) |enumField| {
            switch (enumField) {
                .array => |arr| {
                    var enumItems = try std.ArrayList([]const u8).initCapacity(arena, arr.items.len);
                    for (arr.items) |enumItem| {
                        try enumItems.append(arena, enumItem.string);
                    }
                    return .{ .inline_enum = try enumItems.toOwnedSlice(arena) };
                },
                else => {},
            }
        }
    }
    return error.MissingItemsRef;
}
