//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;

const ir = @import("intermediate_representation.zig");
const irTypes = @import("ir.zig");
const emitter = @import("emitter.zig");

// pub fn emitFhirTypes(arena: std.mem.Allocator, initIo: Io, inputFilePath: []const u8, outputFileName: []const u8) !void {
//     const cwd = std.Io.Dir.cwd();

//     const dir = try cwd.openDir(initIo, ".", .{ .iterate = true });
//     defer dir.close(initIo);

//     const file = try dir.openFile(initIo, inputFilePath, .{});
//     defer file.close(initIo);

//     var buffer: [5_000_000]u8 = undefined;
//     var file_reader = file.reader(initIo, &buffer);
//     const reader = &file_reader.interface;

//     const n = try reader.readSliceShort(&buffer);
//     const json_bytes = buffer[0..n];
//     const parsed = try std.json.parseFromSlice(std.json.Value, arena, json_bytes, .{});

//     cwd.createDir(initIo, "output", .default_dir) catch |e| switch (e) {
//         error.PathAlreadyExists => {},
//         else => return e,
//     };

//     var output_dir: std.Io.Dir = try cwd.openDir(initIo, "output", .{});
//     defer output_dir.close(initIo);

//     const fhirTypes = try ir.buildIntermediateRepresentation(arena, parsed);
//     std.debug.print("built {d} fhir types\n", .{fhirTypes.items.len});

//     const emitted = try emitter.emit(arena, fhirTypes);

//     std.debug.print("emitted - {d}\n", .{emitted.len});

//     const irFile: std.Io.File = try output_dir.createFile(initIo, outputFileName, .{});
//     defer irFile.close(initIo);

//     var file_writer = irFile.writer(initIo, &.{});
//     const writer = &file_writer.interface;

//     const byte_written = try writer.write(emitted);
//     std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});
// }

// pub fn emitFhirR4Types(arena: std.mem.Allocator, initIo: Io) !void {
//     const inputPath = "schemas/schema-json-r4/fhir.schema.json/fhir.schema.json";
//     try emitFhirTypes(arena, initIo, inputPath, "fhir_r4-dont-trust.zig");
// }

// pub fn emitFhirR5Types(arena: std.mem.Allocator, initIo: Io) !void {
//     const inputPath = "schemas/schema-json-r5/fhir.schema.json";
//     try emitFhirTypes(arena, initIo, inputPath, "fhir_r5.zig");
// }

pub fn emitFhirR4Types(arena: std.mem.Allocator, initIo: Io) !void {
    const start = std.Io.Clock.now(.awake, initIo);

    const cwd = std.Io.Dir.cwd();
    const dir = try cwd.openDir(initIo, ".", .{ .iterate = true });
    defer dir.close(initIo);

    const file = try dir.openFile(initIo, "schemas/schema-json-r4/profiles-resources.json", .{});
    defer file.close(initIo);

    const stat = try file.stat(initIo);

    var buffer = try arena.alloc(u8, stat.size);
    var file_reader = file.reader(initIo, buffer);

    const reader = &file_reader.interface;
    try reader.readSliceAll(buffer);

    const resourcesParsed = try std.json.parseFromSlice(std.json.Value, arena, buffer, .{});

    const typesFile = try dir.openFile(initIo, "schemas/schema-json-r4/profiles-types.json", .{});
    defer typesFile.close(initIo);
    const typesStat = try typesFile.stat(initIo);

    buffer = try arena.alloc(u8, typesStat.size);
    file_reader = typesFile.reader(initIo, buffer);
    const typesReader = &file_reader.interface;
    try typesReader.readSliceAll(buffer);

    const typesParsed = try std.json.parseFromSlice(std.json.Value, arena, buffer, .{});

    const fhirTypesArr = try ir.buildIntermediateRepresentationFromBundles(arena, &[_]std.json.Parsed(std.json.Value){ resourcesParsed, typesParsed });

    const out_file = try dir.createFile(initIo, "ir-rep.debug.json", .{});
    defer out_file.close(initIo);

    var out_buffer: [4096]u8 = undefined;
    var out_writer = out_file.writer(initIo, &out_buffer);
    const writer = &out_writer.interface;

    try std.json.Stringify.value(fhirTypesArr.items, .{ .whitespace = .indent_2 }, writer);
    try writer.flush();

    const emitted = try emitter.emit(arena, fhirTypesArr);

    std.debug.print("emitted - {d}\n", .{emitted.len});

    var output_dir: std.Io.Dir = try cwd.openDir(initIo, "output", .{});
    defer output_dir.close(initIo);

    const irFile: std.Io.File = try output_dir.createFile(initIo, "fhir_r4.zig", .{});
    defer irFile.close(initIo);

    var file_writer = irFile.writer(initIo, &.{});
    const writerZigOut = &file_writer.interface;

    const byte_written = try writerZigOut.write(emitted);
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});

    const end = std.Io.Clock.now(.awake, initIo);
    const duration = start.durationTo(end);
    std.debug.print("Elapsed time: {} ms\n", .{duration.toMilliseconds()});
}

pub fn emitFhirR5Types(arena: std.mem.Allocator, initIo: Io) !void {
    const start = std.Io.Clock.now(.awake, initIo);

    const cwd = std.Io.Dir.cwd();
    const dir = try cwd.openDir(initIo, ".", .{ .iterate = true });
    defer dir.close(initIo);

    const file = try dir.openFile(initIo, "schemas/schema-json-r5/profiles-resources.json", .{});
    defer file.close(initIo);

    const stat = try file.stat(initIo);

    var buffer = try arena.alloc(u8, stat.size);
    var file_reader = file.reader(initIo, buffer);

    const reader = &file_reader.interface;
    try reader.readSliceAll(buffer);

    const resourcesParsed = try std.json.parseFromSlice(std.json.Value, arena, buffer, .{});

    const typesFile = try dir.openFile(initIo, "schemas/schema-json-r5/profiles-types.json", .{});
    defer typesFile.close(initIo);
    const typesStat = try typesFile.stat(initIo);

    buffer = try arena.alloc(u8, typesStat.size);
    file_reader = typesFile.reader(initIo, buffer);
    const typesReader = &file_reader.interface;
    try typesReader.readSliceAll(buffer);

    const typesParsed = try std.json.parseFromSlice(std.json.Value, arena, buffer, .{});

    const fhirTypesArr = try ir.buildIntermediateRepresentationFromBundles(arena, &[_]std.json.Parsed(std.json.Value){ resourcesParsed, typesParsed });

    const out_file = try dir.createFile(initIo, "ir-rep.debug.json", .{});
    defer out_file.close(initIo);

    var out_buffer: [4096]u8 = undefined;
    var out_writer = out_file.writer(initIo, &out_buffer);
    const writer = &out_writer.interface;

    try std.json.Stringify.value(fhirTypesArr.items, .{ .whitespace = .indent_2 }, writer);
    try writer.flush();

    const emitted = try emitter.emit(arena, fhirTypesArr);

    std.debug.print("emitted - {d}\n", .{emitted.len});

    var output_dir: std.Io.Dir = try cwd.openDir(initIo, "output", .{});
    defer output_dir.close(initIo);

    const irFile: std.Io.File = try output_dir.createFile(initIo, "fhir_r5.zig", .{});
    defer irFile.close(initIo);

    var file_writer = irFile.writer(initIo, &.{});
    const writerZigOut = &file_writer.interface;

    const byte_written = try writerZigOut.write(emitted);
    std.debug.print("Successfully wrote {d} bytes.\n", .{byte_written});

    const end = std.Io.Clock.now(.awake, initIo);
    const duration = start.durationTo(end);
    std.debug.print("Elapsed time: {} ms\n", .{duration.toMilliseconds()});
}
