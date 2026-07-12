const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");

// copy to src file I'm lazy and haven't made this not a sharp pointy edge... yet
// const generatedFhir = @import("./fhir_r4.zig");
// const generatedFhir = @import("./fhir_r5.zig");

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();

    try fhir_zig.emitFhirR4Types(arena, init.io);
    try fhir_zig.emitFhirR5Types(arena, init.io);

    // _ = arena;

    // const name: generatedFhir.HumanName = .{
    //     .family = .{ .value = "Test" },
    //     .given = &.{.{ .value = "Mc" }},
    // };
    // const patient: generatedFhir.Patient = .{ .active = .{ .value = true }, .name = &.{name} };

    // _ = patient;
}
