const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");
const Zprof = @import("zprof").Zprof;

// copy to src file I'm lazy and haven't made this not a sharp pointy edge... yet
// const generatedFhir = @import("./fhir_r4.zig");
// const generatedFhir = @import("./fhir_r5.zig");

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

    // const name: generatedFhir.HumanName = .{
    //     .family = .{ .value = "Test" },
    //     .given = &.{.{ .value = "Mc" }},
    // };
    // const patient: generatedFhir.Patient = .{ .active = .{ .value = true }, .name = &.{name} };

    // _ = patient;
}
