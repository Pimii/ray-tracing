const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;

pub const Color = Vec3;

pub fn write_color(writer: std.fs.File.Writer, color: Color) !void {
    const r: f64 = color.x;
    const g: f64 = color.y;
    const b: f64 = color.z;

    const rbyte = @as(u16, @intFromFloat(255.999 * r));
    const gbyte = @as(u16, @intFromFloat(255.999 * g));
    const bbyte = @as(u16, @intFromFloat(255.999 * b));

    try writer.print("{} {} {}\n", .{ rbyte, gbyte, bbyte });
}
