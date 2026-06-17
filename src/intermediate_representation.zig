const std = @import("std");

pub const ZigPrimitive = enum {
    boolean,
    integer,
    decimal,
    string,
};

// TODO: add a description: ?[]const u8 that we parse the description field into (for FhirTypes and FhirFields)
pub const FhirType_Primitive = struct {
    pattern: ?[]const u8,
    name: []const u8,
};

pub const FhirType_Structure = struct {
    name: []const u8,
    description: ?[]const u8,
    fields: []FhirField,
    is_resource: bool,
};

pub const FhirType_Enumeration = struct {
    name: []const u8,
    description: ?[]const u8,
    variants: []const []const u8,
};

pub const FhirField = struct {
    name: []const u8,
    description: ?[]const u8,
    type_ref: FieldType,
    is_optional: bool,
    is_slice: bool,
};

pub const FieldType = union(enum) {
    ref: []const u8,
    primitive: []const u8,
    inline_enum: []const []const u8,
};

pub const FhirType = union(enum) {
    primitive: FhirType_Primitive,
    structure: FhirType_Structure,
    enumeration: FhirType_Enumeration,
};

pub const FhirIntermediateRepresentationError = error{
    MissingDefinitions,
    InvalidFormat,
    OutOfMemory,
};

// All this garbage will panic as written
pub fn buildIntermediateRepresentation(parsed: std.json.Parsed(std.json.Value), arena: std.mem.Allocator) FhirIntermediateRepresentationError!std.ArrayList(FhirType) {
    std.debug.print("Building Intermediate Representation\n", .{});
    const obj = switch (parsed.value) {
        .object => |o| o,
        else => return FhirIntermediateRepresentationError.InvalidFormat,
    };

    const definitions = switch (obj.get("definitions").?) {
        .object => |o| o,
        else => return FhirIntermediateRepresentationError.MissingDefinitions,
    };

    std.debug.print("definitions count: {d}\n", .{definitions.count()});
    const definitionsCount = definitions.count();

    var fhirTypes = try std.ArrayList(FhirType).initCapacity(arena, definitionsCount);

    var iter = definitions.iterator();
    while (iter.next()) |entry| {
        const key = entry.key_ptr.*;

        // if (std.mem.eql(u8, key, "Patient")) {
        //     std.debug.print("{s}\n", .{key});

        //     const valueString = try std.json.Stringify.valueAlloc(arena, entry.value_ptr.*, .{ .whitespace = .indent_2 });
        //     std.debug.print("{s}", .{valueString});
        // }

        const fhirType = parseDefinitionObject(arena, key, entry.value_ptr.*) catch {
            std.debug.print("Error parsing definition for {s}\n", .{key});
            continue;
        };

        try fhirTypes.append(arena, fhirType);
    }
    return fhirTypes;
}

fn parseDefinitionObject(arena: std.mem.Allocator, key: []const u8, value: std.json.Value) !FhirType {
    const obj = switch (value) {
        .object => |o| o,
        else => return FhirIntermediateRepresentationError.InvalidFormat,
    };

    var requiredFields: ?std.json.Array = null;

    if (obj.get("required")) |requiredSliceMaybe| {
        requiredFields = switch (requiredSliceMaybe) {
            .array => |a| a,
            else => null,
        };
    }

    var fhirType: FhirType = undefined;

    if (obj.get("properties")) |props| {
        switch (props) {
            .object => |props_obj| {
                var itr = props_obj.iterator();
                const propsLength = itr.len;

                var fields = try std.ArrayList(FhirField).initCapacity(arena, propsLength);

                var isResource = false;
                while (itr.next()) |field| {
                    // resourceType is a discriminator constant, not a data field
                    if (std.mem.eql(u8, field.key_ptr.*, "resourceType")) {
                        isResource = true;
                        continue;
                    }
                    const parsedField = parseField(arena, field.key_ptr.*, field.value_ptr.*, requiredFields) catch {
                        std.debug.print("Failed to parse field for {s}\n", .{field.key_ptr.*});
                        continue;
                    };
                    try fields.append(arena, parsedField);
                }

                fhirType = .{ .structure = .{ .name = key, .fields = try fields.toOwnedSlice(arena), .is_resource = isResource } };
            },
            else => {},
        }
    } else if (obj.get("type")) |_| {
        const pattern: ?[]const u8 = if (obj.get("pattern")) |p| p.string else null;
        fhirType = .{ .primitive = .{ .name = key, .pattern = pattern } };
    } else {
        return error.UnknownDefinitionType;
    }

    return fhirType;
}

fn parseField(arena: std.mem.Allocator, key: []const u8, value: std.json.Value, requiredFields: ?std.json.Array) !FhirField {
    const obj = switch (value) {
        .object => |o| o,
        else => return error.FieldNotObject,
    };

    var fieldType: FieldType = .{ .primitive = "unknown" };
    var isSlice = false;

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

    return FhirField{ .name = key, .type_ref = fieldType, .is_optional = isOptional, .is_slice = isSlice };
}

fn cleanRef(ref: []const u8) []const u8 {
    const prefix = "#/definitions/";
    if (std.mem.startsWith(u8, ref, prefix)) {
        return ref[prefix.len..];
    } else {
        return ref;
    }
}

fn getItemsRef(arena: std.mem.Allocator, value: std.json.Value) !FieldType {
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
