const std = @import("std");
const generated = @import("generated");

pub fn expectResource(comptime T: type, resource: generated.Resource) !T {
    const tag: std.meta.Tag(generated.Resource) = comptime blk: {
        for (@typeInfo(generated.Resource).@"union".fields) |f| {
            if (f.type == T) break :blk @field(std.meta.Tag(generated.Resource), f.name);
        }
        @compileError("not a known Resource variant");
    };
    if (std.meta.activeTag(resource) != tag) return error.UnexpectedResourceType;

    return @field(resource, @tagName(tag));
}
