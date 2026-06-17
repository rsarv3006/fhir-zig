const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");
const ir = @import("intermediate_representation.zig");

pub fn writeTestZigFile(arena: std.mem.Allocator, output_dir: std.Io.Dir, io: Io, resourceName: []const u8) !void {
    const parts = &[_][]const u8{ resourceName, ".zig" };
    const filename = try std.mem.concat(arena, u8, parts);
    const file: std.Io.File = try output_dir.createFile(io, filename, .{});
    defer file.close(io);

    var file_writer = file.writer(io, &.{});
    const writer = &file_writer.interface;

    const thing =
        \\ const std = @import("std");
        \\ pub fn main(init: std.process.Init) !void {
        \\  std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
        \\ }
    ;

    const byte_written = try writer.write(thing);
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}

pub fn main(init: std.process.Init) !void {
    // Prints to stderr, unbuffered, ignoring potential errors.
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // This is appropriate for anything that lives as long as the process.
    const arena: std.mem.Allocator = init.arena.allocator();
    // std.json.parseFromTokenSource(comptime T: type, allocator: Allocator, scanner_or_reader: anytype, options: ParseOptions)

    const cwd = std.Io.Dir.cwd();

    const dir = try cwd.openDir(init.io, ".", .{ .iterate = true });
    defer dir.close(init.io);

    const file = try dir.openFile(init.io, "schema-json/fhir.schema.json/fhir.schema.json", .{});
    defer file.close(init.io);

    var buffer: [5_000_000]u8 = undefined;
    var file_reader = file.reader(init.io, &buffer);
    const reader = &file_reader.interface;

    const n = try reader.readSliceShort(&buffer);
    const json_bytes = buffer[0..n];
    const parsed = try std.json.parseFromSlice(std.json.Value, arena, json_bytes, .{});

    const definitions = parsed.value.object.get("definitions") orelse {
        std.debug.print("no definitions key found\n", .{});
        return;
    };

    cwd.createDir(init.io, "output", .default_dir) catch |e| switch (e) {
        error.PathAlreadyExists => {},
        else => return e,
    };

    var output_dir: std.Io.Dir = try cwd.openDir(init.io, "output", .{});
    defer output_dir.close(init.io);

    var iter = definitions.object.iterator();
    while (iter.next()) |entry| {
        const key = entry.key_ptr.*;
        if (std.mem.count(u8, key, "_") == 0 and std.mem.eql(u8, key, "Patient")) {
            try writeTestZigFile(arena, output_dir, init.io, key);
        }
    }

    const fhirTypes = try ir.buildIntermediateRepresentation(parsed, arena);
    std.debug.print("built {d} fhir types\n", .{fhirTypes.items.len});

    var outArr = try std.ArrayList(u8).initCapacity(arena, 5_000_000);

    for (fhirTypes.items) |fhirType| {
        switch (fhirType) {
            .structure => |s| {
                try outArr.print(arena, "structure: {s} is_resource:{}\n", .{ s.name, s.is_resource });
                for (s.fields) |field| {
                    const type_info = switch (field.type_ref) {
                        .ref => |r| r,
                        .primitive => |p| p,
                        .inline_enum => "inline_enum",
                    };
                    try outArr.print(arena, "  {s} optional:{} slice:{} type:{s}\n", .{ field.name, field.is_optional, field.is_slice, type_info });
                }
            },
            .primitive => |p| {
                try outArr.print(arena, "primitive: {s}\n", .{p.name});
            },
            .enumeration => |e| {
                try outArr.print(arena, "enum: {s}\n", .{e.name});
            },
        }
    }

    const irFile: std.Io.File = try output_dir.createFile(init.io, "ir.out.txt", .{});
    defer irFile.close(init.io);

    var file_writer = irFile.writer(init.io, &.{});
    const writer = &file_writer.interface;

    const byte_written = try writer.write(try outArr.toOwnedSlice(arena));
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}
