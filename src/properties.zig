const Vec = @import("vec3.zig");
const Vec3 = Vec.Vec3;
const Point3 = Vec.Point3;

pub const default_width: u16 = 400;
pub const camera_center = Point3.init(0, 0, 0);

const aspect_ratio: f16 = 16.0 / 10.0;
const focal_length: f16 = 1.0;
const viewport_height: f16 = 2.0;

pub const Properties = struct {
    image_width: u16,
    image_height: u16,
    pixel_delta_horizontal: Vec3,
    pixel_delta_vertical: Vec3,
    pixel_starting_location: Point3,

    pub fn init(image_width: u16) Properties {
        const image_height = blk: {
            var height: u16 = @as(u16, @intFromFloat(@as(f16, @floatFromInt(image_width)) / aspect_ratio));
            if (height < 1) {
                height = 1;
            }
            break :blk height;
        };
        const viewport_width: f16 = viewport_height + (@as(f16, @floatFromInt(image_width)) / @as(f16, @floatFromInt(image_height)));

        const viewport_horizontal = Vec3.init(viewport_width, 0, 0);
        const viewport_vertical = Vec3.init(0, -viewport_height, 0);

        const pixel_delta_horizontal = Vec.divide_vector(@as(f64, @floatFromInt(image_width)), viewport_horizontal);
        const pixel_delta_vertical = Vec.divide_vector(@as(f64, @floatFromInt(image_height)), viewport_vertical);

        const viewport_upper_left_position = blk: {
            var position = camera_center;
            position.subtract(Vec3.init(0, 0, focal_length));
            position.subtract(Vec.divide_vector(2, viewport_horizontal));
            position.subtract(Vec.divide_vector(2, viewport_vertical));
            break :blk position;
        };

        const pixel_starting_location = blk: {
            const delta = Vec.multiply_vector(0.5, Vec.add_vectors(pixel_delta_horizontal, pixel_delta_vertical));
            const location = Vec.add_vectors(viewport_upper_left_position, delta);
            break :blk location;
        };

        return Properties{
            .image_width = image_width,
            .image_height = image_height,
            .pixel_delta_horizontal = pixel_delta_horizontal,
            .pixel_delta_vertical = pixel_delta_vertical,
            .pixel_starting_location = pixel_starting_location,
        };
    }
};
