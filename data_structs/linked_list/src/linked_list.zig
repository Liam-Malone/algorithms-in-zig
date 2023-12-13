const std = @import("std");

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
        pub fn to_string(self: *Self, allocator: *std.mem.Allocator) !std.ArrayList([]const u8) {
            var u8s = std.ArrayList([]const u8).init(allocator.*);
            errdefer u8s.deinit();
            var pos: usize = 0;
            var comma = ",";
            var first: bool = true;
            var exit: bool = false;
            while (pos < self.len and !exit) : (pos += 1) {
                const item: ?T = self.get(pos) orelse null;
                if (item) |it| {
                    if (!first) try u8s.append(@ptrCast((comma))) else first = false;
                    const s = try std.fmt.allocPrint(allocator.*, "{any}", .{it});
                    try u8s.append(s);
                } else {
                    exit = true;
                }
            }
            return u8s;
        }
    };
}
