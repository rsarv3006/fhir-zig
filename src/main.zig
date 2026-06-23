const std = @import("std");
const Io = std.Io;

const fhir_zig = @import("fhir_zig");

// const generatedFhir = @import("../output/fhir_r4.zig");

// fn testTheThing() void {
//     const patient = generatedFhir.Patient {};
// }

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();

    try fhir_zig.emitFhirR4Types(arena, init.io);
}
