const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");
const Zprof = @import("zprof").Zprof;

pub fn main(init: std.process.Init) !void {
    // const arena: std.mem.Allocator = init.arena.allocator();

    var debug_alloc: std.heap.DebugAllocator(.{ .stack_trace_frames = 32 }) = .init;
    defer _ = debug_alloc.deinit();

    var zprof: Zprof(.{}) = .init(debug_alloc.allocator(), undefined);

    const allocator = zprof.allocator();

    try fhir_zig.emitFhirR4Types(allocator, init.io);
    try fhir_zig.emitFhirR5Types(allocator, init.io);

    // try fhir_zig.pocTestJsonRead(allocator, init.io);

    std.debug.print("Has leaks: {}\n", .{zprof.profiler.hasLeaks()});

    // _ = arena;

    const name: fhir_zig.r4.generated.HumanName = .{
        .family = "Test",
        .given = &.{"Mc"},
    };
    const patient: fhir_zig.r4.generated.Patient = .{ .name = &.{name}, .active = true };

    _ = patient;
}
