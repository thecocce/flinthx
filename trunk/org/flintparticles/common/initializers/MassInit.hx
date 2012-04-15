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

package org.flintparticles.common.initializers;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.MassInit;
import org.flintparticles.common.initializers.InitializerBase;

/**
 * The MassInit Initializer sets the mass of the particle.
 */

class MassInit extends InitializerBase
{
	public var mass(massGetter, massSetter):Float;
	
	private var _mass:Float;
	
	/**
	 * The constructor creates a MassInit initializer for use by 
	 * an emitter. To add a MassInit to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * @param mass the mass for particles
	 * initialized by the instance.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( mass:Float = 1 )
	{
		super();
		_mass = mass;
	}
	
	/**
	 * When reading, returns the average of minMass and maxMass.
	 * When writing this sets both minMass and maxMass to the 
	 * same mass value.
	 */
	public function massGetter():Float
	{
		return _mass;
	}
	public function massSetter( value:Float ):Float
	{
		_mass = value;
		return _mass;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter:Emitter, particle:Particle ):Void
	{
		particle.mass = _mass;
	}
}
