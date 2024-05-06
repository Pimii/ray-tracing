const std = @import("std");
const ProgressPrinter = @import("progress_bar.zig").ProgressPrinter;
const Properties = @import("properties.zig");
const Vec = @import("vec3.zig");
const Vec3 = Vec.Vec3;
const Point3 = Vec.Point3;
const Color = @import("color.zig");
const Ray = @import("ray.zig").Ray;

fn hit_sphere(center: Point3, radius: f64, ray: Ray) bool {
    const oc = Vec.subtract_vectors(center, ray.origin);
    const a = Vec.dot(ray.direction, ray.direction);
    const b = -2.0 * Vec.dot(ray.direction, oc);
    const c = Vec.dot(oc, oc) - radius * radius;
    const discriminant = b * b - 4 * a * c;
    return discriminant >= 0;
}

fn ray_color(ray: Ray) Color.Color {
    if (hit_sphere(Point3.init(0, 0, -1), 0.5, ray)) {
        return Color.Color.init(1, 0, 0);
    }
    const unit_direction = Vec.unit_vector(ray.direction);
    const alpha = 0.5 * (unit_direction.y + 1.0);
    const lerp = blk: {
        var lerp = Vec.multiply_vector(1.0 - alpha, Color.Color.init(1.0, 1.0, 1.0));
        lerp.add(Vec.multiply_vector(alpha, Color.Color.init(0.1, 0.8, 0.8)));
        break :blk lerp;
    };
    return lerp;
}

fn generate_image(writer: std.fs.File.Writer) !void {
    const properties = Properties.Properties.init(Properties.default_width);
    const progress = ProgressPrinter.init(properties.image_height);

    try writer.print("P3\n{} {}\n255\n", .{ properties.image_width, properties.image_height });

    for (0..properties.image_height) |j| {
        try progress.print(j);
        for (0..properties.image_width) |i| {
            const pixel_center = blk: {
                var horizontal_pixel = properties.pixel_delta_horizontal;
                horizontal_pixel.multiply(@as(f64, @floatFromInt(i)));

                var vertical_pixel = properties.pixel_delta_vertical;
                vertical_pixel.multiply(@as(f64, @floatFromInt(j)));

                var pixel_center = properties.pixel_starting_location;
                pixel_center.add(horizontal_pixel);
                pixel_center.add(vertical_pixel);

                break :blk pixel_center;
            };
            const ray_direction = Vec.subtract_vectors(pixel_center, Properties.camera_center);
            const ray = Ray.init(Properties.camera_center, ray_direction);

            const pixel_color = ray_color(ray);
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
