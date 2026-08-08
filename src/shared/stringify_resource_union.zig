const std = @import("std");

pub fn stringifyResourceUnion(comptime Union: type, self: Union, jws: anytype) !void {
    switch (self) {
        inline else => |payload| try jws.write(payload),
    }
}
