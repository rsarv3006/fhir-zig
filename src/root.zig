//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

const ir = @import("intermediate_representation.zig");
const emitter = @import("emitter.zig");

pub fn emitFhirTypes(arena: std.mem.Allocator, initIo: Io, inputFilePath: []const u8, outputFileName: []const u8) !void {
    const cwd = std.Io.Dir.cwd();

    const dir = try cwd.openDir(initIo, ".", .{ .iterate = true });
    defer dir.close(initIo);

    const file = try dir.openFile(initIo, inputFilePath, .{});
    defer file.close(initIo);

    var buffer: [5_000_000]u8 = undefined;
    var file_reader = file.reader(initIo, &buffer);
    const reader = &file_reader.interface;

    const n = try reader.readSliceShort(&buffer);
    const json_bytes = buffer[0..n];
    const parsed = try std.json.parseFromSlice(std.json.Value, arena, json_bytes, .{});

    cwd.createDir(initIo, "output", .default_dir) catch |e| switch (e) {
        error.PathAlreadyExists => {},
        else => return e,
    };

    var output_dir: std.Io.Dir = try cwd.openDir(initIo, "output", .{});
    defer output_dir.close(initIo);

    const fhirTypes = try ir.buildIntermediateRepresentation(arena, parsed);
    std.debug.print("built {d} fhir types\n", .{fhirTypes.items.len});

    const emitted = try emitter.emit(arena, fhirTypes);

    std.debug.print("emitted - {d}\n", .{emitted.len});

    const irFile: std.Io.File = try output_dir.createFile(initIo, outputFileName, .{});
    defer irFile.close(initIo);

    var file_writer = irFile.writer(initIo, &.{});
    const writer = &file_writer.interface;

    const byte_written = try writer.write(emitted);
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
}

pub fn emitFhirR4Types(arena: std.mem.Allocator, initIo: Io) !void {
    const inputPath = "schemas/schema-json-r4/fhir.schema.json/fhir.schema.json";
    try emitFhirTypes(arena, initIo, inputPath, "fhir_r4.zig");
}

pub fn emitFhirR5Types(arena: std.mem.Allocator, initIo: Io) !void {
    const inputPath = "schemas/schema-json-r5/fhir.schema.json";
    try emitFhirTypes(arena, initIo, inputPath, "fhir_r5.zig");
}
