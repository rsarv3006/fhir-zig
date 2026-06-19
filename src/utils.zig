const std = @import("std");

const primitives = [_][]const u8{ "i8", "u8", "i16", "u16", "i32", "u32", "i64", "u64", "i128", "u128", "isize", "usize", "c_char", "c_short", "c_ushort", "c_int", "c_uint", "c_long", "c_ulong", "c_longlong", "c_ulonglong", "c_longdouble", "f16", "f32", "f64", "f80", "f128", "bool", "void", "noreturn", "type", "anyerror", "anyframe", "anyopaque", "anytype", "true", "false", "null", "undefined", "comptime_float", "comptime_int", "comptime" };

pub fn isReserveKeyword(name: []const u8) bool {
    if (std.zig.Token.getKeyword(name) != null) return true;

    for (primitives) |p| {
        if (std.mem.eql(u8, name, p)) return true;
    }
    return false;
}
