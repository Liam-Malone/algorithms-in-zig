const std = @import("std");

fn binsearch(key: i32, arr: []i32) usize {
    var lo: usize = 0;
    var hi: usize = arr.len - 1;
    while (hi <= lo) {
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

pub fn main() void {
    var arr = [_]i32{ 1, 2, 3, 4, 5, 6, 7 };
    std.debug.print("index of {d}, is : {d}\n", .{ 5, binsearch(5, &arr) });
}
