const std = @import("std");
const ProgressPrinter = @import("progress_bar.zig").ProgressPrinter;
const Vec3 = @import("vec3.zig").Vec3;
const Color = @import("color.zig");

fn generate_image(writer: std.fs.File.Writer) !void {
    const image_width: u16 = 256;
    const image_height: u16 = 256;
    const progress = ProgressPrinter.init(image_height);

    try writer.print("P3\n{} {}\n255\n", .{ image_width, image_height });

    for (0..image_height) |j| {
        try progress.print(j);
        for (0..image_width) |i| {
            const pixel_color = Color.Color{
                .x = @as(f64, @floatFromInt(i)) / (image_width - 1),
                .y = @as(f64, @floatFromInt(j)) / (image_height - 1),
                .z = 0.0,
            };
            try Color.write_color(writer, pixel_color);
        }
    }
    try std.io.getStdOut().writeAll("Done");
}
pub fn main() !void {
    const image_file = try std.fs.cwd().createFile("image.ppm", .{});
    defer image_file.close();

    const file_writer = image_file.writer();
    try generate_image(file_writer);
}
