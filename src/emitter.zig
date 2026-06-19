const std = @import("std");

const ir = @import("intermediate_representation.zig");
const utils = @import("utils.zig");

const SIZE_ESTIMATE: usize = 128;

pub fn emit(arena: std.mem.Allocator, fhirTypes: std.ArrayList(ir.FhirType)) ![]const u8 {
    var buffer = try std.ArrayList(u8).initCapacity(arena, fhirTypes.items.len * SIZE_ESTIMATE);
    for (fhirTypes.items) |fhirType| {
        try buffer.appendSlice(arena, try generateZigSource(arena, fhirType));
    }

    return buffer.toOwnedSlice(arena);
}

fn generateZigSource(arena: std.mem.Allocator, fhirType: ir.FhirType) ![]const u8 {
    switch (fhirType) {
        .structure => |fhirTypeStruct| {
            return try generateZigSourceFhirStructure(fhirTypeStruct);
        },
        .primitive => |fhirTypePrimitive| {
            return try generateZigSourceFhirPrimitive(arena, fhirTypePrimitive);
        },
        .enumeration => |fhirTypeEnumeration| {
            return try generateZigSourceFhirEnumeration(arena, fhirTypeEnumeration);
        },
    }
}

fn generateZigSourceFhirStructure(fhirStruct: ir.FhirType_Structure) ![]const u8 {
    _ = fhirStruct;
    return "";
}

fn generateZigSourceFhirPrimitive(arena: std.mem.Allocator, fhirPrimitive: ir.FhirType_Primitive) ![]const u8 {
    const description = fhirPrimitive.pattern orelse "";
    const name = try getSanitizedName(arena, fhirPrimitive.name);
    const parts = &[_][]const u8{ "// ", description, "\n", "pub const ", name, " = ", fhirPrimitiveToZigType(name), ";\n" };

    return try std.mem.concat(arena, u8, parts);
}

fn generateZigSourceFhirEnumeration(arena: std.mem.Allocator, fhirEnumeration: ir.FhirType_Enumeration) ![]const u8 {
    const name = try getSanitizedName(arena, fhirEnumeration.name);
    const description = fhirEnumeration.description orelse "";
    const parts = &[_][]const u8{ "// ", description, "\n", "pub const ", name, " = enum {\n" };

    var buffer = try std.ArrayList(u8).initCapacity(arena, name.len + description.len + fhirEnumeration.variants.len * 6 + 20);
    try buffer.appendSlice(arena, try std.mem.concat(arena, u8, parts));

    for (fhirEnumeration.variants) |variant| {
        const variantParts = &[_][]const u8{ variant, ",\n" };
        try buffer.appendSlice(arena, try std.mem.concat(arena, u8, variantParts));
    }
    try buffer.appendSlice(arena, "};");

    // TODO: This is probably not ideal, should probably pass in the buffer
    return try buffer.toOwnedSlice(arena);
}

const primitiveMap = std.StaticStringMap([]const u8).initComptime(.{
    .{ "boolean", "bool" },
    .{ "integer", "i64" },
    .{ "decimal", "f64" },
    .{ "positiveInt", "u64" },
    .{ "unsignedInt", "u64" },
});

fn fhirPrimitiveToZigType(name: []const u8) []const u8 {
    return primitiveMap.get(name) orelse "[]const u8";
}

fn getSanitizedName(arena: std.mem.Allocator, name: []const u8) ![]const u8 {
    if (utils.isReserveKeyword(name)) {
        const parts = &[_][]const u8{ "@\"", name, "\"" };
        return try std.mem.concat(arena, u8, parts);
    }
    return name;
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
