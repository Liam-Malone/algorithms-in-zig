const std = @import("std");
const testing = std.testing;

fn euclid(a: *i32, b: *i32) i32 {
    while (b.* > 0) {
        const tmp = b.*;
        b.* = @mod(a.*, b.*);
        a.* = tmp;
    }
    return a.*;
}

test "gcd of 25 and 15 is 5" {
    var a: i32 = 15;
    var b: i32 = 25;
    try testing.expectEqual(@as(i32, 5), euclid(&a, &b));
}
