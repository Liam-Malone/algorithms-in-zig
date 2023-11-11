const std = @import("std");
const testing = std.testing;

fn count_occurrences(allocator: std.mem.Allocator, arr: []u32) !u32 {
    var map = std.AutoHashMap(u32, usize).init(allocator);
    defer map.deinit();
    for (arr) |num| {
        if (map.contains(num)) {
            const count = map.get(num) orelse 0;
            try map.put(num, count + 1);
        } else {
            try map.put(num, 0);
        }
    }
    var occurrences: usize = 0;
    var most_common: u32 = 0;
    var iter = map.iterator();
    while (iter.next()) |entry| {
        if (entry.value_ptr.* > occurrences) {
            occurrences = entry.value_ptr.*;
            most_common = entry.key_ptr.*;
        }
    }
    return most_common;
}

pub fn main() !void {}

test "test occurrence counting" {
    var allocator = testing.allocator;
    var list = [_]u32{ 2, 2, 3, 2 };
    const x: u32 = try count_occurrences(allocator, &list);
    try testing.expectEqual(@as(u32, 2), x);
}
