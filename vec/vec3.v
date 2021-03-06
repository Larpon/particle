// Copyright(C) 2020 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package

module vec

//import math

pub struct Vec3 {
pub mut:
	x f64
	y f64
	z f64
}

pub fn (mut v Vec3) zero() {
	v.x = 0.0
	v.y = 0.0
	v.z = 0.0
}

pub fn (mut v Vec3) copy() Vec3 {
	return Vec3{ v.x, v.y, v.z }
}

pub fn (mut v Vec3) from(u Vec3) {
	v.x = u.x
	v.y = u.y
	v.z = u.z
}

pub fn (mut v Vec3) from_vec2(u Vec2) {
	v.x = u.x
	v.y = u.y
}

pub fn (mut v Vec3) as_vec2() Vec2 {
	return Vec2{ v.x, v.y }
}
//
// Addition
//
// + operator overload. Adds two vectors
pub fn (v1 Vec3) + (v2 Vec3) Vec3 {
	return Vec3{v1.x + v2.x, v1.y + v2.y, v1.z + v2.z}
}

pub fn (v Vec3) add(u Vec3) Vec3 {
	return Vec3{ v.x + u.x, v.y + u.y, v.z + u.z }
}

pub fn (v Vec3) add_vec2(u Vec2) Vec3 {
	return Vec3{ v.x + u.x, v.y + u.y, v.z }
}

pub fn (v Vec3) add_f64(scalar f64) Vec3 {
	return Vec3{ v.x + scalar, v.y + scalar, v.z + scalar }
}

pub fn (v Vec3) add_f32(scalar f32) Vec3 {
	return Vec3{ v.x + scalar, v.y + scalar, v.z + scalar }
}

pub fn (mut v Vec3) plus(u Vec3) {
	v.x += u.x
	v.y += u.y
	v.z += u.z
}

pub fn (mut v Vec3) plus_f64(scalar f64) {
	v.x += scalar
	v.y += scalar
	v.z += scalar
}

pub fn (mut v Vec3) plus_f32(scalar f32) {
	v.x += scalar
	v.y += scalar
	v.z += scalar
}

//
// Subtraction
//
pub fn (v1 Vec3) - (v2 Vec3) Vec3 {
	return Vec3{v1.x - v2.x, v1.y - v2.y, v1.z - v2.z}
}

pub fn (v Vec3) sub(u Vec3) Vec3 {
	return Vec3{ v.x - u.x, v.y - u.y, v.z - u.z }
}

pub fn (v Vec3) sub_f64(scalar f64) Vec3 {
	return Vec3{ v.x - scalar, v.y - scalar, v.z - scalar }
}

pub fn (mut v Vec3) subtract(u Vec3) {
	v.x -= u.x
	v.y -= u.y
	v.z -= u.z
}

pub fn (mut v Vec3) subtract_f64(scalar f64) {
	v.x -= scalar
	v.y -= scalar
	v.z -= scalar
}
//
// Multiplication
//
pub fn (v1 Vec3) * (v2 Vec3) Vec3 {
	return Vec3{v1.x * v2.x, v1.y * v2.y, v1.z * v2.z}
}

pub fn (v Vec3) mul(u Vec3) Vec3 {
	return Vec3{ v.x * u.x, v.y * u.y, v.z * u.z }
}

pub fn (v Vec3) mul_f64(scalar f64) Vec3 {
	return Vec3{ v.x * scalar, v.y * scalar, v.z * scalar }
}

pub fn (mut v Vec3) multiply(u Vec3) {
	v.x *= u.x
	v.y *= u.y
	v.z *= u.z
}

pub fn (mut v Vec3) multiply_f64(scalar f64) {
	v.x *= scalar
	v.y *= scalar
	v.z *= scalar
}

//
// Division
//
pub fn (v1 Vec3) / (v2 Vec3) Vec3 {
	return Vec3{v1.x / v2.x, v1.y / v2.y, v1.z / v2.z }
}

pub fn (v Vec3) div(u Vec3) Vec3 {
	return Vec3{ v.x / u.x, v.y / u.y, v.z / u.z }
}

pub fn (v Vec3) div_f64(scalar f64) Vec3 {
	return Vec3{ v.x / scalar, v.y / scalar, v.z / scalar }
}

pub fn (mut v Vec3) divide(u Vec3) {
	v.x /= u.x
	v.y /= u.y
	v.z /= u.z
}

pub fn (mut v Vec3) divide_f64(scalar f64) {
	v.x /= scalar
	v.y /= scalar
	v.z /= scalar
}
/* TODO
//
// Utility
//
pub fn (v Vec3) length() f64 {
	if v.x == 0 && v.y == 0 { return 0.0 }
	return math.sqrt((v.x*v.x) + (v.y*v.y))
}

pub fn (v Vec3) dot(u Vec3) f64 {
	return (v.x * u.x) + (v.y*u.y)
}

// cross returns the cross product of v and u
pub fn (v Vec3) cross(u Vec3) f64 {
	return (v.x * u.y) - (v.y*u.x)
}

// unit return this vector's unit vector
pub fn (v Vec3) unit() Vec3 {
	length := v.length()
	return Vec3{ v.x/length, v.y/length }
}

pub fn (v Vec3) perp() Vec3 {
	return Vec3{ -v.y, v.x }
}

// perpendicular return the perpendicular vector of this
pub fn (v Vec3) perpendicular(u Vec3) Vec3 {
	return v - v.project(u)
}

// project returns the projected vector
pub fn (v Vec3) project(u Vec3) Vec3 {
	percent := v.dot(u) / u.dot(v)
	return u.mul_f64(percent)
}
*/
// eq returns a bool indicating if the two vectors are equal
pub fn (v Vec3) eq(u Vec3) bool {
	return v.x == u.x && v.y == u.y && v.z == u.z
}
/*
// eq_epsilon returns a bool indicating if the two vectors are equal within epsilon
pub fn (v Vec3) eq_epsilon(u Vec3) bool {
	return v.x.eq_epsilon(u.x) && v.y.eq_epsilon(u.y)
}

// eq_approx will return a bool indicating if vectors are approximately equal within the tolerance
pub fn (v Vec3) eq_approx(u Vec3, tolerance f64) bool {
	diff_x := math.fabs(v.x - u.x)
	diff_y := math.fabs(v.y - u.y)
	if diff_x <= tolerance && diff_y <= tolerance {
		return true
	}

	max_x := math.max(math.fabs(v.x), math.fabs(u.x))
	max_y := math.max(math.fabs(v.y), math.fabs(u.y))
	if diff_x < max_x * tolerance && diff_y < max_y * tolerance {
		return true
	}

	return false
}

// is_approx_zero will return a bool indicating if this vector is zero within tolerance
pub fn (v Vec3) is_approx_zero(tolerance f64) bool {
	if math.fabs(v.x) <= tolerance && math.fabs(v.y) <= tolerance {
		return true
	}
	return false
}

// eq_f64 returns a bool indicating if the x and y both equals the scalar
pub fn (v Vec3) eq_f64(scalar f64) bool {
	return v.x == scalar && v.y == scalar
}

// eq_f32 returns a bool indicating if the x and y both equals the scalar
pub fn (v Vec3) eq_f32(scalar f32) bool {
	return v.eq_f64(f64(scalar))
}v.y /= scalar

// distance returns the distance between the two vectors
pub fn (v Vec3) distance(u Vec3) f64 {
	return math.sqrt( (v.x-u.x) * (v.x-u.x) + (v.y-u.y) * (v.y-u.y) )
}

// manhattan_distance returns the Manhattan distance between the two vectors
pub fn (v Vec3) manhattan_distance(u Vec3) f64 {
	return math.fabs(v.x-u.x) + math.fabs(v.y-u.y)
}

// angle_between returns the angle in radians between the two vectors
pub fn (v Vec3) angle_between(u Vec3) f64 {
	return math.atan2( (v.y-u.y), (v.x-u.x) )
}

// angle returns the angle in radians of the vector
pub fn (v Vec3) angle() f64 {
	return math.atan2(v.y, v.x)
}

// abs will set x and y values to their absolute values
pub fn (mut v Vec3) abs() {
	if v.x < 0 {
		v.x = math.fabs(v.x)
	}
	if v.y < 0 {
		v.y = math.fabs(v.y)
	}
}
*/
