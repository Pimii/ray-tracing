const std = @import("std");

pub const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn init(x: f64, y: f64, z: f64) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn add(self: Vec3, vec: Vec3) void {
        self.x += vec.x;
        self.y += vec.y;
        self.z += vec.z;
    }

    pub fn multiply(self: Vec3, times: f64) void {
        self.x *= times;
        self.y *= times;
        self.z *= times;
    }

    pub fn divide(self: Vec3, times: f64) void {
        self.multiply(1 / times);
    }

    pub fn len_squared(self: Vec3) f64 {
        return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
    }

    pub fn len(self: Vec3) f64 {
        return std.math.sqrt(self.len_squared());
    }

    pub fn to_string(self: Vec3, buf: []u8) ![]u8 {
        return try std.fmt.bufPrint(buf, "{d:.2} {d:.2} {d:.2}", .{ self.x, self.y, self.z });
    }
};

pub const Point3 = Vec3;

pub fn add_vectors(vec1: Vec3, vec2: Vec3) Vec3 {
    return Vec3{
        .x = vec1.x + vec2.x,
        .y = vec1.y + vec2.y,
        .z = vec1.z + vec2.z,
    };
}

pub fn subtract_vectors(vec1: Vec3, vec2: Vec3) Vec3 {
    return Vec3{
        .x = vec1.x - vec2.x,
        .y = vec1.y - vec2.y,
        .z = vec1.z - vec2.z,
    };
}

pub fn multiply_vectors(vec1: Vec3, vec2: Vec3) Vec3 {
    return Vec3{
        .x = vec1.x * vec2.x,
        .y = vec1.y * vec2.y,
        .z = vec1.z * vec2.z,
    };
}

pub fn dot(vec1: Vec3, vec2: Vec3) f64 {
    return (vec1.x * vec2.x) + (vec1.y * vec2.y) + (vec1.z * vec2.z);
}

pub fn cross(vec1: Vec3, vec2: Vec3) Vec3 {
    return Vec3{
        .x = (vec1.y * vec2.z) - (vec1.z * vec2.y),
        .y = (vec1.z * vec2.x) - (vec1.x * vec2.z),
        .z = (vec1.x * vec2.y) - (vec1.y * vec2.x),
    };
}

pub fn unit_vector(vec: Vec3) Vec3 {
    vec.divide(vec.len());
    return vec;
}
