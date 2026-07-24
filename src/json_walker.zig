const std = @import("std");

pub fn walkJsonFile(
    arena: std.mem.Allocator,
    initIo: std.Io,
    inputFilePath: []const u8,
) !void {
    std.debug.print("Walking json file: {s}\n", .{inputFilePath});
    const cwd = std.Io.Dir.cwd();

    const dir = try cwd.openDir(initIo, ".", .{ .iterate = true });
    defer dir.close(initIo);

    const file = try dir.openFile(initIo, inputFilePath, .{});
    defer file.close(initIo);

    const buffer = try arena.alloc(u8, 64_000);
    defer arena.free(buffer);

    var bufferedReader = file.reader(initIo, buffer);

    var jsonReader = std.json.Reader.init(arena, &bufferedReader.interface);
    defer jsonReader.deinit();

    std.debug.assert(try jsonReader.next() == .object_begin);

    var shouldLoop = true;
    while (shouldLoop) {
        const token = try jsonReader.next();

        switch (token) {
            .object_end => {
                shouldLoop = false;
            },
            .string => |key| {
                if (std.mem.eql(u8, key, "resourceType")) {
                    const nextFromResourceType = try jsonReader.next();

                    std.debug.print("key: {s} - val: {s}\n", .{ key, nextFromResourceType.string });
                } else if (std.mem.eql(u8, key, "entry")) {
                    break;
                } else {
                    try jsonReader.skipValue();
                }
            },
            else => {},
        }
    }

    std.debug.assert(try jsonReader.next() == .array_begin);

    var entryArena = std.heap.ArenaAllocator.init(arena);
    defer entryArena.deinit();

    shouldLoop = true;
    while (shouldLoop) {
        const peek = try jsonReader.peekNextTokenType();
        if (peek == .array_end) {
            _ = try jsonReader.next();
            break;
        }

        _ = entryArena.reset(.retain_capacity);

        const entryAllocator = entryArena.allocator();
        _ = try std.json.innerParse(std.json.Value, entryAllocator, &jsonReader, .{
            .max_value_len = std.json.default_max_value_len,
        });

        // std.debug.print("\n=== entryValue ===\n", .{});
        // std.debug.print("{f}\n", .{std.json.fmt(entryValue, .{ .whitespace = .indent_2 })});
        // std.debug.print("\n==================\n", .{});

        // resource = myCodec.parseResourceFromValue(entry_value, entry_allocator)

        // validate(resource)

    }
}

// // ===== ENTRY ARRAY LOOP =====

// expect(json_reader.next() == .array_begin)   // consumes '['

// entry_arena = ArenaAllocator.init(page_allocator)

// loop {
//     peek = json_reader.peekNextTokenType()
//     // peeking does NOT advance the cursor -- just looks ahead

//     if (peek == .array_end) {
//         json_reader.next()   // now actually consume the ']'
//         break                 // done with all entries
//     }

//     // ---- one entry starts here ----
//     _ = entry_arena.reset(.retain_capacity)
//     entry_allocator = entry_arena.allocator()

//     // materialize just THIS one entry as a Value tree
//     // (this is one call, consumes exactly one JSON value's worth
//     //  of tokens, leaves cursor positioned right after it)
//     entry_value = json.innerParse(
//         json.Value,
//         entry_allocator,
//         &json_reader,
//         options,
//     )

//     // now hand that Value tree to YOUR custom codec
//     // (this is the part that knows about _fieldName shadow keys,
//     //  choice-type suffix probing, resourceType dispatch, etc.)
//     resource = myCodec.parseResourceFromValue(entry_value, entry_allocator)

//     validate(resource)   // or whatever you do with it

//     // entry_value and resource both die here -- next loop iteration
//     // resets entry_arena and frees all of it in one shot
// }

// // entry_arena.deinit() when totally done
