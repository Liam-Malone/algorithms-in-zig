const std = @import("std");
const testing = std.testing;

fn binsearch(key: i32, arr: []i32) usize {
    var lo: usize = 0;
    var hi: usize = arr.len - 1;
    while (lo <= hi) {
        const mid = lo + (hi - lo) / 2;
        if (key == arr[mid]) return mid;
        if (key > arr[lo]) {
            lo = mid + 1;
        } else if (key < arr[hi]) {
            hi = mid - 1;
        }
    }
    return arr.len + 1;
}

test "find number 5 in array 1-7 -- should give index 4" {
    var arr = [_]i32{ 1, 2, 3, 4, 5, 6, 7 };
    try testing.expectEqual(@as(usize, 4), binsearch(5, &arr));
}
