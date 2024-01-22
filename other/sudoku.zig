const std = @import("std");

const USAGE_MSG =
    \\
    \\ Usage: sudoku [options]
    \\
    \\ OPTIONS:
    \\  Options must be provided before input
    \\
    \\  f [path/to/file]  -- the file from which to read the sudoku puzzle 
    \\  s {string input}  -- the sudoku puzzle in string form
    \\                       example: 
    \\                       { {3, 0, 6, ..., 0}, {.....} , ...}
    \\
;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var alloc = gpa.allocator();

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    const stdout = std.io.getStdOut().writer();
}

fn solve_puzzle(puzzle: [][]u8) bool {
}

test "solve test" {
    const allocator = std.testing.testing_allocator;

    var input_table: [9][9]u8 = [9][9]u8{
         {3, 0, 6, 5, 0, 8, 4, 0, 0},
         {5, 2, 0, 0, 0, 0, 0, 0, 0},
         {0, 8, 7, 0, 0, 0, 0, 3, 1},
         {0, 0, 3, 0, 1, 0, 0, 8, 0},
         {9, 0, 0, 8, 6, 3, 0, 0, 5},
         {0, 5, 0, 0, 9, 0, 6, 0, 0}, 
         {1, 3, 0, 0, 0, 0, 2, 5, 0},
         {0, 0, 0, 0, 0, 0, 0, 7, 4},
         {0, 0, 5, 2, 0, 6, 3, 0, 0},
    };
    var output_table:[9][9]u8 = [9][9]u8{
        { 3, 1, 6, 5, 7, 8, 4, 9, 2 },
        { 5, 2, 9, 1, 3, 4, 7, 6, 8 },
        { 4, 8, 7, 6, 2, 9, 5, 3, 1 },
        { 2, 6, 3, 4, 1, 5, 9, 8, 7 },
        { 9, 7, 4, 8, 6, 3, 1, 2, 5 },
        { 8, 5, 1, 7, 9, 2, 6, 4, 3 },
        { 1, 3, 8, 9, 4, 7, 2, 5, 6 },
        { 6, 9, 2, 3, 5, 1, 8, 7, 4 },
        { 7, 4, 5, 2, 8, 6, 3, 1, 9 },
    };

}
