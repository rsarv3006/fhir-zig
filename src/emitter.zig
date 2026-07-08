const std = @import("std");

const ir = @import("ir.zig");
const utils = @import("utils.zig");

const SIZE_ESTIMATE: usize = 128;

pub fn emit(arena: std.mem.Allocator, fhirTypes: std.ArrayList(ir.FhirType)) ![]const u8 {
    std.debug.print("Emitting Fhir Types...\n", .{});
    var buffer = try std.ArrayList(u8).initCapacity(arena, fhirTypes.items.len * SIZE_ESTIMATE);
    for (fhirTypes.items) |fhirType| {
        try buffer.appendSlice(arena, try generateZigSource(arena, fhirType));
    }

    return buffer.toOwnedSlice(arena);
}

fn generateZigSource(arena: std.mem.Allocator, fhirType: ir.FhirType) ![]const u8 {
    switch (fhirType) {
        .structure => |fhirTypeStruct| {
            return try generateZigSourceFhirStructure(arena, fhirTypeStruct);
        },
        .primitive => |fhirTypePrimitive| {
            return try generateZigSourceFhirPrimitive(arena, fhirTypePrimitive);
        },
        .enumeration => |fhirTypeEnumeration| {
            return try generateZigSourceFhirEnumeration(arena, fhirTypeEnumeration);
        },
        .oneOf => |fhirTypeOneOf| {
            return try generateZigSourceFhirOneOf(arena, fhirTypeOneOf);
        },
    }
}

fn generateZigSourceFhirOneOf(arena: std.mem.Allocator, fhirTypeOneOf: ir.FhirType_OneOf) ![]const u8 {
    const name = try getSanitizedName(arena, fhirTypeOneOf.name);
    const parts = &[_][]const u8{ "pub const ", name, " = union(enum) {\n" };

    var buffer = try std.ArrayList(u8).initCapacity(arena, name.len + fhirTypeOneOf.refs.len * 10);
    try buffer.appendSlice(arena, try std.mem.concat(arena, u8, parts));

    for (fhirTypeOneOf.refs) |refItem| {
        const sanitizedRefItem = try getSanitizedName(arena, refItem);
        try buffer.appendSlice(arena, "    ");
        try buffer.appendSlice(arena, sanitizedRefItem);
        try buffer.appendSlice(arena, ": ");
        try buffer.appendSlice(arena, sanitizedRefItem);
        try buffer.appendSlice(arena, ",\n");
    }

    try buffer.appendSlice(arena, "};\n");

    return buffer.toOwnedSlice(arena);
}

fn generateZigSourceFhirStructure(arena: std.mem.Allocator, fhirStruct: ir.FhirType_Structure) ![]const u8 {
    const description = try getSanitizedDescription(arena, fhirStruct.description);
    const name = try getSanitizedName(arena, fhirStruct.name);
    const parts = &[_][]const u8{ description, "\n", "pub const ", name, " = struct {\n" };

    var buffer = try std.ArrayList(u8).initCapacity(arena, name.len + description.len + fhirStruct.fields.items.len * 20 + 20);
    try buffer.appendSlice(arena, try std.mem.concat(arena, u8, parts));

    if (fhirStruct.is_resource) {
        const isResourceParts = &[_][]const u8{ "    resourceType: []const u8 = \"", fhirStruct.name, "\",\n" };
        try buffer.appendSlice(arena, try std.mem.concat(arena, u8, isResourceParts));
    }

    for (fhirStruct.fields.items) |field| {
        const sanitizedFieldName = try getSanitizedName(arena, field.name);
        const sanitizedFieldDescription = try getSanitizedDescription(arena, field.description);

        try buffer.appendSlice(arena, "    ");
        try buffer.appendSlice(arena, sanitizedFieldDescription);
        try buffer.appendSlice(arena, "\n    ");
        try buffer.appendSlice(arena, sanitizedFieldName);
        try buffer.appendSlice(arena, ": ");

        if (field.is_optional) {
            try buffer.appendSlice(arena, "?");
        }

        if (field.is_slice) {
            try buffer.appendSlice(arena, "[] const ");
        }

        if (field.is_boxed) {
            try buffer.appendSlice(arena, "*const ");
        }

        switch (field.type_ref) {
            .primitive => |primitiveFieldType| {
                try buffer.appendSlice(arena, primitiveFieldType);
            },
            .inline_enum => |inlineEnumFieldType| {
                try buffer.appendSlice(arena, "enum {\n");
                for (inlineEnumFieldType) |enumField| {
                    const sanitizedEnumField = try getSanitizedName(arena, enumField);
                    try buffer.appendSlice(arena, sanitizedEnumField);
                    try buffer.appendSlice(arena, ", \n");
                }

                try buffer.appendSlice(arena, "}\n");
            },
            .ref => |refFieldType| {
                try buffer.appendSlice(arena, refFieldType);
            },
            .choice => |choiceFieldType| {
                _ = choiceFieldType;
                unreachable;
            },
        }

        if (field.is_optional) {
            try buffer.appendSlice(arena, " = null");
        }

        try buffer.appendSlice(arena, ",\n");
    }

    try buffer.appendSlice(arena, "\n};\n\n");

    return buffer.toOwnedSlice(arena);
}

fn generateZigSourceFhirPrimitive(arena: std.mem.Allocator, fhirPrimitive: ir.FhirType_Primitive) ![]const u8 {
    const description = try getSanitizedDescription(arena, fhirPrimitive.pattern);
    const name = try getSanitizedName(arena, fhirPrimitive.name);

    const parts = &[_][]const u8{ description, "\n", "pub const ", name, " = ", fhirPrimitiveToZigType(name), ";\n" };

    return try std.mem.concat(arena, u8, parts);
}

fn generateZigSourceFhirEnumeration(arena: std.mem.Allocator, fhirEnumeration: ir.FhirType_Enumeration) ![]const u8 {
    const name = try getSanitizedName(arena, fhirEnumeration.name);
    const description = try getSanitizedDescription(arena, fhirEnumeration.description);
    const parts = &[_][]const u8{ description, "\n", "pub const ", name, " = enum {\n" };

    var buffer = try std.ArrayList(u8).initCapacity(arena, name.len + description.len + fhirEnumeration.variants.len * 6 + 20);
    try buffer.appendSlice(arena, try std.mem.concat(arena, u8, parts));

    for (fhirEnumeration.variants) |variant| {
        const variantParts = &[_][]const u8{ variant, ",\n" };
        try buffer.appendSlice(arena, try std.mem.concat(arena, u8, variantParts));
    }
    try buffer.appendSlice(arena, "};\n");

    // TODO: This is probably not ideal, should probably pass in the buffer
    return try buffer.toOwnedSlice(arena);
}

// TODO: validate this translation against the spec
const primitiveMap = std.StaticStringMap([]const u8).initComptime(.{
    .{ "boolean", "bool" },
    .{ "integer", "i32" },
    .{ "decimal", "f64" },
    .{ "positiveInt", "u32" },
    .{ "unsignedInt", "u32" },
    .{ "number", "f64" },
    .{ "integer64", "i64" },
});

fn fhirPrimitiveToZigType(name: []const u8) []const u8 {
    return primitiveMap.get(name) orelse "[]const u8";
}

fn getSanitizedName(arena: std.mem.Allocator, name: []const u8) ![]const u8 {
    if (utils.isReserveKeyword(name) or utils.doesContainCharNotAllowedInName(name) or utils.doesStartWithBadChar(name)) {
        const parts = &[_][]const u8{ "@\"", name, "\"" };
        return try std.mem.concat(arena, u8, parts);
    }

    return name;
}

// TODO: Can we pass the description in as a reference to save on value copy
fn getSanitizedDescription(arena: std.mem.Allocator, description: ?[]const u8) ![]const u8 {
    const nonNullDescription = description orelse "";
    if (std.mem.eql(u8, nonNullDescription, "")) {
        return "";
    }

    // Hardcoded int is a WAG here for extra space needed by the slashes
    var sanitizedDescriptionBuffer = try std.ArrayList(u8).initCapacity(arena, nonNullDescription.len + 16);

    try sanitizedDescriptionBuffer.appendSlice(arena, "    /// ");
    for (nonNullDescription) |descrByte| {
        if (descrByte == '\t' or descrByte == '\r') {
            try sanitizedDescriptionBuffer.appendSlice(arena, " ");
        } else {
            try sanitizedDescriptionBuffer.append(arena, descrByte);
        }
        if (descrByte == '\n') {
            try sanitizedDescriptionBuffer.appendSlice(arena, "    /// ");
        }
    }

    return try sanitizedDescriptionBuffer.toOwnedSlice(arena);
}

// Tests
test "getSanitizedName - non-reserved" {
    const allocator = std.testing.allocator;
    const result = try getSanitizedName(allocator, "Patient");
    try std.testing.expect(std.mem.eql(u8, "Patient", result));
}

test "getSanitizedName - reserved" {
    const allocator = std.testing.allocator;
    const result = try getSanitizedName(allocator, "type");
    defer allocator.free(result);
    try std.testing.expect(std.mem.eql(u8, "@\"type\"", result));
}
