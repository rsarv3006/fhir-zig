const std = @import("std");
const utils = @import("../utils.zig");

pub fn parseResourceUnion(comptime Union: type, allocator: std.mem.Allocator, source: anytype, options: std.json.ParseOptions) std.json.ParseError(@TypeOf(source.*))!Union {
    var opts = options;
    if (opts.max_value_len == null) opts.max_value_len = std.json.default_max_value_len;

    const value = try std.json.Value.jsonParse(allocator, source, opts);

    const resourceType = utils.getStr(value.object, "resourceType") catch {
        return error.MissingField;
    };

    inline for (@typeInfo(Union).@"union".fields) |f| {
        if (std.mem.eql(u8, resourceType, f.name)) {
            const parsed = try std.json.innerParseFromValue(f.type, allocator, value, opts);
            return @unionInit(Union, f.name, parsed);
        }
    }

    return error.UnexpectedToken;
}
