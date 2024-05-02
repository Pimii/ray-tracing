const Vec = @import("vec3.zig");
const Vec3 = Vec.Vec3;
const Point3 = Vec.Point3;

pub const Ray = struct {
    origin: Point3,
    direction: Vec3,

    pub fn init(origin: Point3, direction: Vec3) Ray {
        return Ray{
            .origin = origin,
            .direction = direction,
        };
    }

    pub fn at(self: Ray, t: f64) Point3 {
        return Vec.add_vectors(self.origin, Vec.multiply_vector(t, self.direction));
    }
};
