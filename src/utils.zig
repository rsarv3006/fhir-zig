const std = @import("std");

const primitives = [_][]const u8{
    "i8",
    "u8",
    "i16",
    "u16",
    "i32",
    "u32",
    "i64",
    "u64",
    "i128",
    "u128",
    "isize",
    "usize",
    "c_char",
    "c_short",
    "c_ushort",
    "c_int",
    "c_uint",
    "c_long",
    "c_ulong",
    "c_longlong",
    "c_ulonglong",
    "c_longdouble",
    "f16",
    "f32",
    "f64",
    "f80",
    "f128",
    "bool",
    "void",
    "noreturn",
    "type",
    "anyerror",
    "anyframe",
    "anyopaque",
    "anytype",
    "true",
    "false",
    "null",
    "undefined",
    "comptime_float",
    "comptime_int",
    "comptime",
    "<",
    ">",
    "=",
    "<=",
    ">=",
};

pub fn isReserveKeyword(name: []const u8) bool {
    if (std.zig.Token.getKeyword(name) != null) return true;

    for (primitives) |p| {
        if (std.mem.eql(u8, name, p)) return true;
    }
    return false;
}

const BAD_CHARS = [_][]const u8{
    "<",
    ">",
    "=",
    "<=",
    ">=",
    "-",
    "/",
    ".",
    ",",
};

pub fn doesContainCharNotAllowedInName(name: []const u8) bool {
    for (BAD_CHARS) |i| {
        if (std.mem.find(u8, name, i) != null) return true;
    }

    return false;
}

const BAD_STARTING_CHARS = [_]u8{ '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };

pub fn doesStartWithBadChar(name: []const u8) bool {
    for (BAD_STARTING_CHARS) |i| {
        // TODO: Will this cause a bad access issue?
        if (i == name[0]) return true;
    }
    return false;
}

pub fn capitalizeFirstLetter(arena: std.mem.Allocator, s: []const u8) ![]const u8 {
    if (s.len == 0) return s;
    var capitalized = try arena.dupe(u8, s);
    capitalized[0] = std.ascii.toUpper(s[0]);
    return capitalized;
}

pub fn extractDebugId(arena: std.mem.Allocator, entry: std.json.Value) []const u8 {
    const entryObj = switch (entry) {
        .object => |o| o,
        else => return "<non-object entry>",
    };
    const resourceValue = entryObj.get("resource") orelse return "<no resource>";
    const resource = switch (resourceValue) {
        .object => |o| o,
        else => return "<resource not object>",
    };
    const resourceType = if (resource.get("resourceType")) |rt| switch (rt) {
        .string => |s| s,
        else => "?",
    } else "?";
    const id = if (resource.get("id")) |i| switch (i) {
        .string => |s| s,
        else => "?",
    } else "?";
    return std.fmt.allocPrint(arena, "{s}/{s}", .{ resourceType, id }) catch "<unknown>";
}

pub fn getStr(maybeVal: std.json.ObjectMap, key: []const u8) ![]const u8 {
    errdefer |err| std.log.err("Error for key '{s}': {s}", .{ key, @errorName(err) });

    if (maybeVal.get(key)) |maybeStr| {
        switch (maybeStr) {
            .string => |str| return str,
            else => return error.ValueNotString,
        }
    }
    return error.KeyNotPresent;
}

pub fn getObj(maybeVal: std.json.ObjectMap, key: []const u8) !std.json.ObjectMap {
    errdefer |err| std.log.err("Error for key '{s}': {s}", .{ key, @errorName(err) });

    if (maybeVal.get(key)) |maybeObj| {
        switch (maybeObj) {
            .object => |o| return o,
            else => return error.ValueNotObject,
        }
    }
    return error.KeyNotPresent;
}

pub fn getArr(maybeVal: std.json.ObjectMap, key: []const u8) !std.json.Array {
    errdefer |err| std.log.err("Error for key '{s}': {s}", .{ key, @errorName(err) });

    if (maybeVal.get(key)) |maybeArr| {
        switch (maybeArr) {
            .array => |a| return a,
            else => return error.ValueNotArray,
        }
    }
    return error.KeyNotPresent;
}

pub fn getInt(maybeVal: std.json.ObjectMap, key: []const u8) !i64 {
    errdefer |err| std.log.err("Error for key '{s}': {s}", .{ key, @errorName(err) });

    if (maybeVal.get(key)) |maybeInt| {
        switch (maybeInt) {
            .integer => |int| return int,
            else => return error.ValueNotInteger,
        }
    }
    return error.KeyNotPresent;
}

pub fn getBool(maybeVal: std.json.ObjectMap, key: []const u8) !bool {
    errdefer |err| std.log.err("Error for key '{s}': {s}", .{ key, @errorName(err) });

    if (maybeVal.get(key)) |maybeBool| {
        switch (maybeBool) {
            .bool => |b| return b,
            else => return error.ValueNotBool,
        }
    }
    return error.KeyNotPresent;
}
