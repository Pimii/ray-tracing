const vec = @import("vec3.zig");
const Point3 = vec.Point3;
const Color = @import("color.zig").Color;
const Ray = @import("ray.zig").Ray;
const math = @import("std").math;

fn hit_sphere(center: Point3, radius: f64, ray: Ray) f64 {
    const oc = vec.subtract_vectors(center, ray.origin);
    const a = vec.dot(ray.direction, ray.direction);
    const b = -2.0 * vec.dot(ray.direction, oc);
    const c = vec.dot(oc, oc) - radius * radius;
    const discriminant = b * b - 4 * a * c;

    if (discriminant < 0) {
        return -1.0;
    } else {
        return (-b - math.sqrt(discriminant)) / (2.0 * a);
    }
}

fn background_color(ray: Ray) Color {
    const unit_direction = vec.unit_vector(ray.direction);
    const alpha = 0.5 * (unit_direction.y + 1.0);
    const lerp = blk: {
        var lerp = vec.multiply_vector(1.0 - alpha, Color.init(1.0, 1.0, 1.0));
        lerp.add(vec.multiply_vector(alpha, Color.init(0.3, 0.6, 0.9)));
        break :blk lerp;
    };
    return lerp;
}

pub fn ray_color(ray: Ray) Color {
    const t = hit_sphere(Point3.init(0, 0, -1), 0.5, ray);
    if (t > 0.0) {
        const n = vec.unit_vector(vec.subtract_vectors(ray.at(t), vec.Vec3.init(0, 0, -1)));
        return vec.multiply_vector(0.5, Color.init(n.x + 1, n.y + 1, n.z + 1));
    }
    return background_color(ray);
}
