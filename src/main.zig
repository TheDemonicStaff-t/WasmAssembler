const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const cwd = std.fs.cwd();

const eql = std.mem.eql;

const Assembler = @import("Assembler.zig");

pub fn main() !void {
    var args = std.process.ArgIterator.init();
    _ = args.next().?;
    var wasm = Assembler.init();
    defer wasm.deinit();
    while (args.next()) |arg| {
        if (arg[0] == '-' and arg[1] == '-') {
            if (eql(u8, arg[2..], "help")) {
                try stdout.print("{s}\n", .{HELP_MESSAGE});
                return;
            } else if (eql(u8, arg[2..], "version")) {
                try stdout.print("WHAT EVEN IS A VERSION??\n", .{});
            } else if (eql(u8, arg[2..], "verbose")) {
                wasm.verbose = true;
            } else if (eql(u8, arg[2..], "debug-parser")) {
                wasm.debug_info = true;
            } else if (eql(u8, arg[2..], "dump-module")) {
                wasm.dump = true;
            } else if (eql(u8, arg[2..], "output")) {
                if (arg.len > 8) {
                    wasm.output_file = if (arg[8] == '=') try cwd.openFileZ(arg[9..], .{ .mode = .write_only }) else try cwd.openFileZ(arg[8..], .{ .mode = .write_only });
                } else {
                    wasm.output_file = try cwd.openFileZ(args.next().?, .{ .mode = .write_only });
                }
            } else if (eql(u8, arg[2..], "relocatable")) {
                wasm.relocatable = true;
            } else {
                try stderr.print("unkown option: {s} was provided\n{s}\n", .{ arg, HELP_MESSAGE });
                return;
            }
        } else if (arg[0] == '-') {
            if (arg[1] == 'v') {
                wasm.verbose = true;
            } else if (arg[1] == 'd') {
                wasm.dump = true;
            } else if (arg[1] == 'o') {
                wasm.output_file = if (arg.len > 1) try cwd.openFileZ(arg[2.. :0], .{ .mode = .write_only }) else try cwd.openFileZ(args.next().?, .{ .mode = .write_only });
            } else if (arg[1] == 'r') {
                wasm.relocatable = true;
            } else if (arg[1] == 'h') {
                try stdout.print("{s}\n", .{HELP_MESSAGE});
            } else {
                try stderr.print("unkown option: -{c} was provided\n{s}\n", .{ arg[1], HELP_MESSAGE });
                return;
            }
        } else {
            wasm.input_file = try cwd.openFileZ(arg, .{});
        }
    }
    wasm.output_file = null;
}

const HELP_MESSAGE =
    \\Usage: wasm [options] wat_file
    \\Options:
    \\ -h --help : print this message
    \\ -v --verbose : verbose logging during compilations
    \\ -d --dump-module : print assembled hex file to stdout
    \\ -o --output : set binary outpit
    \\ -r --relocatable : make linkable file
    \\ --version : print version message
    \\ --debug-parser : enable parse debugging
;
