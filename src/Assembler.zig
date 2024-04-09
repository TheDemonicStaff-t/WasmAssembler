const std = @import("std");
// imported structs
const File = std.fs.File;
const Assembler = @This();

input_file: File = undefined,
output_file: ?File = undefined,
relocatable: bool = false,
dump: bool = false,
verbose: bool = false,
debug_info: bool = false,

pub fn init() Assembler {
    return .{};
}

pub fn deinit(self: *Assembler) void {
    self.input_file.close();
    if (self.output_file) |f| f.close();
}
