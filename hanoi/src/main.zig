const std = @import("std");

fn hanoi(n: i32, from: u8, to: u8, aux: u8) !void {
    if (n == 0){
        return;
    }
    try hanoi(n-1, from, aux, to);
    std.debug.print("Move disk {}, from {c}, to {c}\n", .{n, from, to});
    try hanoi(n-1, aux, to, from);
}

pub fn main() !void {
    // add in CLI arg parsing to run this with any size tower
    //var args = std.process.argsWithAllocator();
    //const n = args.next();
    //std.debug.print("{any}", .{n});
    std.debug.print("Solving tower of hanoi with a size of 3\n\n", .{});
    try hanoi(3, 'A', 'B', 'C');
}
