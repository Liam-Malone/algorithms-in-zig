const std = @import("std");
const testing = std.testing;

fn factorial(comptime n: comptime_int) comptime_int {
    if (n > 0) {
        return n * factorial(n - 1);
    } else {
        return 1;
    }
}

test "factorial of 3 should give 6" {
    const n: u32 = 3;
    try testing.expectEqual(@as(u32, 6), factorial(n));
}

test "factorial of 8 should return 40320" {
    const n: u32 = 8;
    try testing.expectEqual(@as(u32, 40320), factorial(n));
}
