const std = @import("std");
const testing = std.testing;

fn fib_tail(comptime n: comptime_int, comptime last: comptime_int, comptime second_last: comptime_int) comptime_int {
    if (n <= 1) {
        return last;
    } else {
        return fib_tail(n - 1, last + second_last, last);
    }
}

fn fibonacci(comptime n: comptime_int) comptime_int {
    return fib_tail(n - 1, 1, 1);
}

test "get 6th element of fibonacci sequence" {
    const sixth: i32 = 8;
    try testing.expectEqual(sixth, fibonacci(@as(i32, 6)));
}
