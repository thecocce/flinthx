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

package org.flintparticles.threed.initializers;

import nme.geom.Vector3D;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.threed.geom.Vector3DUtils;
import org.flintparticles.threed.particles.Particle3D;

/**
 * The FaceAxis Initializer sets the face axis of the particle. The face axis
 * is a unit vector in the coordinate space of the particle that indicates the
 * "forward" direction for the particle.
 * 
 * <p>The face axis is used when rotating the particle to the direction of
 * motion and when using a display object to represent the particle - the display
 * object is rotated so that its x axis points in the direction of the facing axis
 * of the particle.</p>
 */

class FaceAxis extends InitializerBase
{
	public var axis(axisGetter,axisSetter):Vector3D;
	
	private var _axis : Vector3D;

	/**
	 * The constructor creates a FaceAxis initializer for use by 
	 * an emitter. To add a FaceAxis to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * @param axis The face axis for the particles.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( axis : Vector3D = null )
	{
		super();
		this.axis = axis != null ? axis : Vector3D.X_AXIS;
	}
	
	/**
	 * The face axis of the particles.
	 */
	private function axisGetter():Vector3D
	{
		return _axis;
	}
	private function axisSetter( value:Vector3D ):Vector3D
	{
		_axis = Vector3DUtils.cloneUnit( value );
		return _axis;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter : Emitter, particle : Particle ) : Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		p.faceAxis = _axis.clone();
	}
}
