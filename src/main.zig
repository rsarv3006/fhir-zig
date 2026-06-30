const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");

// copy to src file I'm lazy and haven't made this not a sharp pointy edge... yet
// const generatedFhir = @import("./fhir_r4.zig");

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();

    // try fhir_zig.emitFhirR4Types(arena, init.io);
    // try fhir_zig.emitFhirR5Types(arena, init.io);

    try fhir_zig.testRepFromBundle(arena, init.io);

    // const name: generatedFhir.HumanName = .{
    //     .family = "Test",
    //     .given = &.{"Mc"},
    // };
    // const patient: generatedFhir.Patient = .{ .active = true, .name = &.{name} };

    // _ = patient;
}
