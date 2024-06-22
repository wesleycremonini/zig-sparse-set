const std = @import("std");

const MAX_SIZE = 10000;

const yieldFn = fn (v: *usize) bool;
fn printer(v: *usize) bool {
    std.debug.print("{d}\n", .{v.*});
    return true;
}

const SparseSet = struct {
    dense: []usize,
    sparse: []usize,
    numberOfItems: usize = 0,

    fn add(ss: *SparseSet, value: u8) void {
        assert(ss.numberOfItems < MAX_SIZE);
        ss.dense[ss.numberOfItems] = value;
        ss.sparse[value] = ss.numberOfItems;
        ss.numberOfItems += 1;
    }

    fn search(ss: *SparseSet, value: u8) bool {
        return ss.sparse[value] < ss.numberOfItems and ss.dense[ss.sparse[value]] == value;
    }

    fn clear(ss: *SparseSet) void {
        ss.numberOfItems = 0;
    }

    fn iterate(ss: *SparseSet, yield: yieldFn) void {
        for (0..ss.numberOfItems) |i| if (!yield(&ss.dense[i])) break;
    }
};

pub fn main() !void {
    var denseArray: [MAX_SIZE]usize = undefined;
    var sparseArray: [MAX_SIZE]usize = undefined;

    var ss = SparseSet{ .dense = denseArray[0..], .sparse = sparseArray[0..] };

    ss.add(15);
    ss.add(22);
    ss.add(3);
    ss.add(7);
    ss.add(16);

    assert(ss.search(15));
    assert(ss.search(22));
    assert(ss.search(3));
    assert(ss.search(7));
    assert(ss.search(16));

    assert(!ss.search(14));
    assert(!ss.search(23));
    assert(!ss.search(2));
    assert(!ss.search(8));
    assert(!ss.search(17));

    ss.iterate(printer);

    ss.clear();

    assert(!ss.search(15));
    assert(!ss.search(22));
    assert(!ss.search(3));
    assert(!ss.search(7));
    assert(!ss.search(16));
}

fn assert(condition: bool) void {
    if (!condition) {
        std.debug.print("assertion failed\n", .{});
        std.process.exit(1);
    }
}
