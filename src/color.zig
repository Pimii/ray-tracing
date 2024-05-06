const std = @import("std");

pub const Color = struct {
    r: f64,
    g: f64,
    b: f64,

    const Self = @This();

    pub fn init(r: f64, g: f64, b: f64) Color {
        return Color{
            .r = r,
            .g = g,
            .b = b,
        };
    }

    pub fn mutliply(self: *Self, value: f64) void {
        self.r *= value;
        self.g *= value;
        self.b *= value;
    }

    pub fn blend(self: Self, color: Color) Color {
        return Color{
            .r = self.r + color.r,
            .g = self.g + color.g,
            .b = self.b + color.b,
        };
    }

    pub fn write(self: Self, writer: std.fs.File.Writer) !void {
        const rbyte = @as(u16, @intFromFloat(255.999 * self.r));
        const gbyte = @as(u16, @intFromFloat(255.999 * self.g));
        const bbyte = @as(u16, @intFromFloat(255.999 * self.b));

        try writer.print("{} {} {}\n", .{ rbyte, gbyte, bbyte });
    }
};
