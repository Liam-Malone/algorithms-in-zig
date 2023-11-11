const std = @import("std");
const testing = std.testing;
const mem = std.mem;

fn quicksort(arr: []i32, lo: usize, hi: usize) void {
    if (lo < hi) {
        var pi: usize = partition(arr, lo, hi);
        quicksort(arr, lo, @min(pi, pi -% 1));
        quicksort(arr, pi + 1, hi);
    }
}

fn partition(arr: []i32, lo: usize, hi: usize) usize {
    const pivot = arr[hi];
    var i = lo;
    var j = lo;
    while (j < hi) : (j += 1) {
        if (arr[j] < pivot) {
            mem.swap(i32, &arr[i], &arr[j]);
            i = i + 1;
        }
    }
    mem.swap(i32, &arr[i], &arr[hi]);
    return i;
}

pub fn main() !void {}

test "quicksort on array with numbers 1-8" {
    var unsorted_arr = [_]i32{ 1, 5, 8, 7, 6, 2, 3, 4 };
    const sorted_arr = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 };

    quicksort(&unsorted_arr, 0, unsorted_arr.len - 1);

    try testing.expectEqualSlices(i32, &sorted_arr, &unsorted_arr);
}
