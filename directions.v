// Copyright(C) 2020 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package

module particle
import particle.vec

// Stochastic direction types
type StochasticDirection = PointDirection | AngleDirection | TargetDirection

pub struct PointDirection {
pub mut:
	point			vec.Vec2
	point_variation	vec.Vec2	// Will vary up/down to a maximum of these values
}

pub struct AngleDirection {
pub mut:
	angle				f32
	angle_variation		f32	// Will vary up/down to a maximum of this value
	magnitude			f32
	magnitude_variation	f32	// Will vary up/down to a maximum of this value
}

pub struct TargetDirection {
pub mut:
	//target_item			Item
	target					vec.Vec2
	target_variation		vec.Vec2	// Will vary up/down to a maximum of these values
	magnitude				f32
	magnitude_variation		f32	// Will vary up/down to a maximum of this value
	proportional_magnitude	bool
}

