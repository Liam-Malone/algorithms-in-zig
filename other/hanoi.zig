const std = @import("std");

fn hanoi(n: usize, from: u8, to: u8, aux: u8) !void {
    const stdout = std.io.getStdOut().writer();
    if (n == 0) {
        return;
    }
    try hanoi(n - 1, from, aux, to);
    try stdout.print("Move disk {}, from {c}, to {c}\n", .{ n, from, to });
    try hanoi(n - 1, aux, to, from);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    var n: usize = 3;
    const stderr = std.io.getStdErr().writer();

    if (args.len < 2) {
        try stderr.print("Error: no tower height provided\n", .{});
        std.process.exit(1);
    } else {
        n = try std.fmt.parseInt(usize, args[1], 10);
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Solving tower of hanoi with a size of {d}\n\n", .{n});

    try hanoi(n, 'A', 'B', 'C');
}
