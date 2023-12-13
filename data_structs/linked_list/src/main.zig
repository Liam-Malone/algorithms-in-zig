const std = @import("std");
const lists = @import("linked_list.zig");

fn compare_u8_arrays(first: [][]const u8, second: [][]const u8) bool {
    if (first.len != second.len) return false;
    for (first, second) |str_1, str_2| {
        if (str_1.len != str_2.len) return false;
        for (0..str_1.len) |i| {
            if (str_1[i] != str_2[i]) return false;
        }
    }
    return true;
}

test "linked list: ensure init, push and pop work" {
    var list = lists.allocatingLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.push(42);
    try std.testing.expectEqual(@as(?i32, 42), list.pop());
    try list.push(42);
    try list.push(12);
    try std.testing.expectEqual(@as(?i32, 12), list.pop());
    try std.testing.expectEqual(@as(?i32, 42), list.pop());
}

test "linked list: ensure get works" {
    var list = lists.allocatingLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.push(42);
    try std.testing.expectEqual(@as(?i32, 42), list.get(0));
}

test "linked list: ensure string forming works" {
    var allocator = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    var arena_allocator = arena.allocator();
    var list = lists.allocatingLinkedList(i32).init(allocator);
    defer list.deinit();

    try list.push(2);
    try list.push(2);

    var reference_list = std.ArrayList([]const u8).init(allocator);
    defer reference_list.deinit();

    try reference_list.append(@ptrCast(("2")));
    try reference_list.append(@ptrCast((",")));
    try reference_list.append(@ptrCast(("2")));
    var expected: [][]const u8 = reference_list.items;

    const str_list = list.to_string(&arena_allocator) catch return error.FailedToFormatString;

    defer arena.deinit();

    var result: bool = compare_u8_arrays(expected, str_list.items);
    try std.testing.expectEqual(true, result);
}
test "doubly linked list: ensure init, push and pop work" {
    var list = lists.allocatingLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.push(42);
    try std.testing.expectEqual(@as(?i32, 42), list.pop());
    try list.push(42);
    try list.push(12);
    try std.testing.expectEqual(@as(?i32, 12), list.pop());
    try std.testing.expectEqual(@as(?i32, 42), list.pop());
}

test "doubly linked list: ensure get works" {
    var list = lists.allocatingLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.push(42);
    try std.testing.expectEqual(@as(?i32, 42), list.get(0));
}

test "doubly linked list: ensure string forming works" {
    var allocator = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    var arena_allocator = arena.allocator();
    var list = lists.allocatingLinkedList(i32).init(allocator);
    defer list.deinit();

    try list.push(2);
    try list.push(2);

    var reference_list = std.ArrayList([]const u8).init(allocator);
    defer reference_list.deinit();

    try reference_list.append(@ptrCast(("2")));
    try reference_list.append(@ptrCast((",")));
    try reference_list.append(@ptrCast(("2")));
    var expected: [][]const u8 = reference_list.items;

    const str_list = list.to_string(&arena_allocator) catch return error.FailedToFormatString;

    defer arena.deinit();

    var result: bool = compare_u8_arrays(expected, str_list.items);
    try std.testing.expectEqual(true, result);
}
