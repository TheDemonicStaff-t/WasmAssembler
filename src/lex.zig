const std = @import("std");

const Token = struct {
    type: TokType,
    data: ?TokData,
};
const TokType = enum {
    left_paren,
    right_paren,
    unsined_int,
    signed_int,
    float,
    string,
    id,
};
const TokData = union(enum) {
    unsigned_int: u64,
    signed_int: i64,
    float: f64,
    string: ?[]u8,
};
