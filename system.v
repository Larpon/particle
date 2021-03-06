// Copyright(C) 2020 Lars Pontoppidan. All rights reserved.
// Use of this source code is governed by an MIT license file distributed with this software package

module particle

const (
	rad_pi_div_180 = 0.017453292520444443 // ~ pi/180 in radians
)

type Component = Emitter | Painter | Affector

// System
pub struct SystemConfig {
	pool	int
}

pub struct System {
	width			int
	height			int
mut:
	pool			[]&Particle
	bin				[]&Particle

	image_cache		map[string]Image

	emitters		[]Emitter
	painters		[]Painter
	affectors		[]Affector

	dt				f64
}

pub fn (mut s System) init(sc SystemConfig) {
	$if debug {
		eprintln(@MOD+'.'+@STRUCT+'::'+@FN+' creating $sc.pool particles.')
	}
	for i := 0; i < sc.pool; i++ {
		p := s.new_particle()
		s.bin << p
	}
	$if debug {
		eprintln(@MOD+'.'+@STRUCT+'::'+@FN+' created $sc.pool particles.')
	}

	if s.painters.len == 0 {
		$if debug {
			eprintln(@MOD+'.'+@STRUCT+'::'+@FN+' adding default painter.')
		}
		s.add(Painter(RectPainter{
			groups: [""]
			color: particle.default_color
		}))
	}
}

pub fn (mut s System) add(c Component) {
	//eprintln('Adding something')
	match mut c {
		Emitter {
			eprintln('Adding emitter')
			//e := c as Emitter
			c.system = s
			s.emitters << c
		}
		Painter {
			mut p := c
			match mut p {
				RectPainter {
					eprintln('Adding rectangle painter')
					//e := c as Emitter
					s.painters << p
				}
				ImagePainter {
					eprintln('Adding image painter')
					//e := c as Emitter
					//c.system = s
					s.painters << p
				}
				else {
					eprintln('Unknown Painter type')
				}
			}
		}
		Affector {
			mut a := c
			match mut a {
				GravityAffector {
					eprintln('Adding gravity affector')
					s.affectors << a
				}
				AttractorAffector {
					eprintln('Adding attractor affector')
					s.affectors << a
				}
				else {
					eprintln('Unknown Affector type')
				}
			}
		}
		/*
		else {
			println('Unknown system component (V BUG unprintable)') //${c} BUG doesn't print
			return
		}*/
	}
}

pub fn (mut s System) get_emitter(index int) &Emitter {
	return &s.emitters[index]
}

pub fn (mut s System) get_emitters(groups []string) []&Emitter {
	mut collected := []&Emitter{}
	for i := 0; i < s.emitters.len; i++ {
		emitter := &s.emitters[i]
		for group in groups {
			if emitter.group == group {
				collected << emitter
			}
		}
	}
	return collected
}

pub fn (mut s System) update(dt f64) {
	s.dt = dt
	// Guard against total freeze on low framerates
	if s.dt <= 0.0 {
		s.dt = 0.000001
	}
	// Emitters extract particles from the bin to the pool
	for i := 0; i < s.emitters.len; i++ {
		s.emitters[i].update(dt)
	}
	// Run through the pool of currently active particles
	mut p := &Particle(0)
	for i := 0; i < s.pool.len; i++ {
		p = s.pool[i]
		if p.is_dead() {
			s.bin << p
			s.pool.delete(i)
			continue
		}
		// Init painters if necessary
		if !p.is_ready() {
			for mut painter in s.painters {
				match mut painter {
					RectPainter {
						if p.group in painter.groups {
							painter.init(mut p)
						}
					}
					ImagePainter {
						if p.group in painter.groups {
							painter.init(mut p)
						}
					}
					else {
						//eprintln('Painter type ${painter} not supported') // <- struct printing results in some C error
						eprintln('Painter type init not needed')
					}
				}
			}
		}
		// Affect particle
		for mut affector in s.affectors {
			match mut affector {
				GravityAffector {
					if affector.groups.len == 0 || p.group in affector.groups {
						if affector.collides(p) {
							affector.affect(mut p)
						}
					}
				}
				AttractorAffector {
					if affector.groups.len == 0 || p.group in affector.groups {
						affector.affect(mut p)
					}
				}
				else {
					//eprintln('Affector type ${painter} not supported') // <- struct printing results in some C error
					eprintln('Affector type not supported')
				}
			}
		}

		p.update(dt)
		if p.is_dead() {
			s.bin << p
			s.pool.delete(i)
			continue
		}
		// TODO could be optimized so particle pool is only only traversed once??
		// Draw call would be here... remove other draw calls
	}
}

pub fn (mut s System) draw() {
	mut p := &Particle(0)
	//for mut p in s.pool {
	for i := 0; i < s.pool.len; i++ {
		p = s.pool[i]
		if p.is_dead() || !p.is_ready() {
			continue
		}
		for mut painter in s.painters {
			match mut painter {
				RectPainter {
					if p.group in painter.groups {
						painter.draw(mut p)
					}
				}
				ImagePainter {
					if p.group in painter.groups {
						painter.draw(mut p)
					}
				}
				else {
					//eprintln('Painter type ${painter} not supported') // <- struct printing results in some C error
					eprintln('Painter type not supported')
				}
			}
		}
	}
}

pub fn (mut s System) reset() {
	eprintln(@MOD+'.'+@STRUCT+'::'+@FN)
	eprintln('Resetting ${s.pool.len} from pool ${s.bin.len}')
	for p in s.pool {
		mut pm := p
		pm.reset()
		pm.life_time = 0
	}
	for p in s.bin {
		mut pm := p
		pm.reset()
		pm.life_time = 0
	}
}

pub fn (mut s System) free() {

	for key, image in s.image_cache {
		eprintln('Freeing ${key} from image cache')
		mut im := image
		im.free()
	}
	eprintln('Freeing ${s.pool.len} from pool')
	for p in s.pool {
		if p == 0 {
			print(ptr_str(p)+' ouch')
			continue
		}
		unsafe{
			p.free()
		}
	}
	s.pool.clear()

	eprintln('Freeing ${s.bin.len} from bin')
	for p in s.bin {

		if p == 0 {
			eprint(ptr_str(p)+' ouch')
			continue
		}

		unsafe{
			//println('Freeing from bin')
			p.free()
		}
	}
	s.bin.clear()
}
