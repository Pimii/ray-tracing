const std = @import("std");

fn generate_image(writer: std.fs.File.Writer) !void {
    const image_width: u16 = 256;
    const image_height: u16 = 256;

    try writer.print("P3\n{} {}\n255\n", .{ image_width, image_height });

    for (0..image_height) |j| {
        for (0..image_width) |i| {
            const r: f64 = @as(f64, @floatFromInt(i)) / (image_width - 1);
            const g: f64 = @as(f64, @floatFromInt(j)) / (image_height - 1);
            const b: f64 = 0.0;

            const ir = @as(u16, @intFromFloat(255.999 * r));
            const ig = @as(u16, @intFromFloat(255.999 * g));
            const ib = @as(u16, @intFromFloat(255.999 * b));

            try writer.print("{} {} {}\n", .{ ir, ig, ib });
        }
    }
}
pub fn main() !void {
    const image_file = try std.fs.cwd().createFile("image.ppm", .{});
    defer image_file.close();

    const file_writer = image_file.writer();
    try generate_image(file_writer);
}
