const std = @import("std");

pub fn main() !void {
    const image_width: u16 = 256;
    const image_height: u16 = 256;

    var stdout = std.io.getStdOut().writer();
    try stdout.print("P3\n{} {}\n255\n", .{ image_width, image_height });

    for (0..image_height) |j| {
        for (0..image_width) |i| {
            const r: f64 = @as(f64, @floatFromInt(i)) / (image_width - 1);
            const g: f64 = @as(f64, @floatFromInt(j)) / (image_height - 1);
            const b: f64 = 0.0;

            const ir = @as(u16, @intFromFloat(255.999 * r));
            const ig = @as(u16, @intFromFloat(255.999 * g));
            const ib = @as(u16, @intFromFloat(255.999 * b));

            try stdout.print("{} {} {}\n", .{ ir, ig, ib });
        }
    }
}
