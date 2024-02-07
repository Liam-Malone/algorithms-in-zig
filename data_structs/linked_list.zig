const std = @import("std");
const lists = @import("linked_list.zig");

pub fn allocatingLinkedList(comptime T: type) type {
    return struct {
        head: ?*Node = null,
        len: usize,
        allocator: std.mem.Allocator,

        const errors = error{
            FailedToInitializeNode,
        };

        const Self = @This();
        const Node = struct {
            data: T,
            next: ?*Node = null,

            pub fn init(data: T, next: ?*Node, allocator: std.mem.Allocator) !?*Node {
                var new = try allocator.create(Node);
                new.*.data = data;
                new.*.next = next;
                return new;
            }
            pub fn deinit(self: *Node, allocator: std.mem.Allocator) void {
                allocator.destroy(self);
                return;
            }
        };

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .head = null,
                .len = 0,
                .allocator = allocator,
            };
        }
        pub fn deinit(self: *Self) void {
            while (self.head) |head| {
                const temp = self.head;
                self.head = head.next;
                temp.?.deinit(self.allocator);
            }
        }

        pub fn push(self: *Self, data: T) !void {
            var new = try Node.init(data, self.head, self.allocator);
            if (new == null) return errors.FailedToInitializeNode;
            if (self.head != null) {
                var temp = self.head;
                self.head = new;
                new.?.*.next = temp;
            }
            self.head = new;
            self.len += 1;
        }
        pub fn pop(self: *Self) ?T {
            if (self.head) |head| {
                const data = head.data;
                const temp = self.head;
                self.head = temp.?.*.next;
                temp.?.deinit(self.allocator);
                return data;
            } else {
                return null;
            }
        }
        pub fn get(self: *Self, pos: usize) ?T {
            if (pos < 0 or pos >= self.len) {
                return null;
            } else {
                var current: ?*Node = self.head;
                var counter: usize = 0;
                while (current != null and counter < pos) {
                    current = current.?.*.next orelse null;
                    counter += 1;
                }
                if (current == null) return null else return current.?.*.data;
            }
        }

        //**********************//
        //  *** IMPORTANT: ***  //
        //  This LEAKS memory   //
        //  use ARENA allocator //
        //**********************//
        pub fn to_string(self: *Self, allocator: *std.mem.Allocator) ?[]const u8 {
            var idx: usize = 0;
            var str: []const u8 = "";
            while (idx < self.len) : (idx += 1) {
                var buf: [36]u8 = std.mem.zeroes([36]u8);
                if (idx == 0) {
                    str = std.mem.concat(allocator.*, u8, &[_][]const u8{ str, std.fmt.bufPrint(&buf, "{any}", .{self.get(idx)}) catch "" }) catch "";
                } else {
                    str = std.mem.concat(allocator.*, u8, &[_][]const u8{ str, std.fmt.bufPrint(&buf, ", {any}", .{self.get(idx)}) catch "" }) catch "";
                }
            }
            return str;
        }
    };
}

test "linked list: ensure init, push and pop work" {
    var list = lists.allocatingLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.push(42);
    try std.testing.expectEqual(@as(?i32, 42), list.pop());
    try list.push(42);
    try list.push(12);
    try std.testing.expectEqual(@as(?i32, 12), list.pop());
    try std.testing.expectEqual(@as(?i32, 42), list.pop());
}

test "linked list: ensure get works" {
    var list = lists.allocatingLinkedList(i32).init(std.testing.allocator);
    defer list.deinit();
    try list.push(42);
    try std.testing.expectEqual(@as(?i32, 42), list.get(0));
}

test "linked list: ensure string forming works" {
    var allocator = std.testing.allocator;
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    var arena_allocator = arena.allocator();
    var list = lists.allocatingLinkedList(i32).init(allocator);
    defer list.deinit();

    try list.push(2);
    try list.push(2);

    var expected: []const u8 = "2, 2";

    const str_list = list.to_string(&arena_allocator) orelse "";

    defer arena.deinit();

    var result: bool = std.mem.eql(u8, expected, str_list);
    try std.testing.expectEqual(true, result);
}
