const std = @import("std");
const testing = std.testing;
const fhir = @import("root.zig");
const shared = @import("shared/parse_resource_union.zig");

test "Bundle parses a single Patient entry via Resource.jsonParseFromValue" {
    const json_text =
        \\{
        \\  "resourceType": "Bundle",
        \\  "type": "collection",
        \\  "entry": [
        \\    {
        \\      "resource": {
        \\        "resourceType": "Patient",
        \\        "id": "example",
        \\        "active": true
        \\      }
        \\    }
        \\  ]
        \\}
    ;

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    const parsed = try std.json.parseFromSlice(
        fhir.r4.generated.Bundle,
        alloc,
        json_text,
        .{},
    );
    defer parsed.deinit();

    const bundle = parsed.value;

    try testing.expect(bundle.entry != null);
    try testing.expectEqual(@as(usize, 1), bundle.entry.?.len);

    const entry = bundle.entry.?[0];
    try testing.expect(entry.resource != null);

    const resource = entry.resource.?;
    try testing.expect(resource == .Patient);

    const patient = resource.Patient;
    try testing.expectEqualStrings("example", patient.id.?);
    try testing.expectEqual(true, patient.active.?);
}

test "parseResourceUnion returns error.UnexpectedToken for unrecognized resourceType" {
    const json_text =
        \\{
        \\  "resourceType": "NotARealResource",
        \\  "id": "whatever"
        \\}
    ;

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var scanner = std.json.Scanner.initCompleteInput(alloc, json_text);
    defer scanner.deinit();

    const result = shared.parseResourceUnion(
        fhir.r4.generated.Resource,
        alloc,
        &scanner,
        .{},
    );

    try testing.expectError(error.UnexpectedToken, result);
}

test "parseResourceUnion returns error.MissingField when resourceType key is absent" {
    const json_text =
        \\{
        \\  "id": "whatever"
        \\}
    ;

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var scanner = std.json.Scanner.initCompleteInput(alloc, json_text);
    defer scanner.deinit();

    const result = shared.parseResourceUnion(
        fhir.r4.generated.Resource,
        alloc,
        &scanner,
        .{},
    );

    try testing.expectError(error.MissingField, result);
}

test "parseResourceUnion returns error.MissingField when resourceType is not a string" {
    const json_text =
        \\{
        \\  "resourceType": 42,
        \\  "id": "whatever"
        \\}
    ;

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var scanner = std.json.Scanner.initCompleteInput(alloc, json_text);
    defer scanner.deinit();

    const result = shared.parseResourceUnion(
        fhir.r4.generated.Resource,
        alloc,
        &scanner,
        .{},
    );

    try testing.expectError(error.MissingField, result);
}
