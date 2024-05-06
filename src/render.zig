const Vec = @import("vec3.zig");
const Point3 = Vec.Point3;
const Color = @import("color.zig").Color;
const Ray = @import("ray.zig").Ray;

pub fn hit_sphere(center: Point3, radius: f64, ray: Ray) bool {
    const oc = Vec.subtract_vectors(center, ray.origin);
    const a = Vec.dot(ray.direction, ray.direction);
    const b = -2.0 * Vec.dot(ray.direction, oc);
    const c = Vec.dot(oc, oc) - radius * radius;
    const discriminant = b * b - 4 * a * c;
    return discriminant >= 0;
}

pub fn ray_color(ray: Ray) Color.Color {
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
