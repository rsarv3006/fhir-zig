const parse_mod = @import("parse_resource_union.zig");
const stringify_mod = @import("stringify_resource_union.zig");

pub const parseResourceUnion = parse_mod.parseResourceUnion;
pub const stringifyResourceUnion = stringify_mod.stringifyResourceUnion;
