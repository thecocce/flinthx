/*
* FLINT PARTICLE SYSTEM
* .....................
* 
* Author: Richard Lord
* Copyright (c) Richard Lord 2008-2011
* http://flintparticles.org
* 
* 
* Licence Agreement
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package org.flintparticles.twod.particles;

import nme.Vector;
import org.flintparticles.common.debug.ParticleFactoryStats;
import org.flintparticles.common.particles.ParticleFactory;
import org.flintparticles.common.particles.Particle;

/**
 * The ParticleCreator is used by the Emitter class to manage the creation and reuse of particles.
 * To speed up the particle system, the ParticleCreator class maintains a pool of dead particles 
 * and reuses them when a new particle is needed, rather than creating a whole new particle.
 */

class ParticleCreator2D implements ParticleFactory
{
	private var _particles:Vector<Particle>;
	
	/**
	 * The constructor creates a ParticleCreator object.
	 */
	public function new()
	{
		_particles = new Vector<Particle>();
	}
	
	/**
	 * Obtains a new Particle object. The createParticle method will return
	 * a dead particle from the poll of dead particles or create a new particle if none are
	 * available.
	 * 
	 * @return a Particle object.
	 */
	public function createParticle():Particle
	{
		ParticleFactoryStats.numParticles++;
		if ( _particles.length > 0 )
		{
			return _particles.pop();
		}
		else
		{
			return new Particle2D();
		}
	}
	
	/**
	 * Returns a particle to the particle pool for reuse
	 * 
	 * @param particle The particle to return for reuse.
	 */
	public function disposeParticle( particle:Particle ):Void
	{
		ParticleFactoryStats.numParticles--;
		if( Std.is( particle, Particle2D ) )
		{
			particle.initialize();
			_particles.push( particle );
		}
	}

	/**
	 * Empties the particle pool.
	 */
	public function clearAllParticles():Void
	{
		_particles = new Vector<Particle>();
	}
}
