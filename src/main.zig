const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");
const ir = @import("intermediate_representation.zig");
const emitter = @import("emitter.zig");

// const generatedFhir = @import("../output/fhir_r4.zig");

// fn testTheThing() void {
//     const patient = generatedFhir.Patient {};
// }

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();

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

    cwd.createDir(init.io, "output", .default_dir) catch |e| switch (e) {
        error.PathAlreadyExists => {},
        else => return e,
    };

    var output_dir: std.Io.Dir = try cwd.openDir(init.io, "output", .{});
    defer output_dir.close(init.io);

    const fhirTypes = try ir.buildIntermediateRepresentation(arena, parsed);
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
            else => {
                // TODO: Ignoring the one of ir type
            },
        }
    }

    const emitted = try emitter.emit(arena, fhirTypes);

    std.debug.print("emitted - {d}\n", .{emitted.len});

    const irFile: std.Io.File = try output_dir.createFile(init.io, "fhir_r4.zig", .{});
    defer irFile.close(init.io);

    var file_writer = irFile.writer(init.io, &.{});
    const writer = &file_writer.interface;

    const byte_written = try writer.write(emitted);
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}
