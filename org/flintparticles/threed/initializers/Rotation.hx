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
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.initializers.InitializerBase;
import org.flintparticles.threed.geom.Quaternion;
import org.flintparticles.threed.geom.Vector3DUtils;
import org.flintparticles.threed.particles.Particle3D;

/**
 * The Rotation Initializer sets the rotation of the particle. The rotation is
 * relative to the rotation of the emitter.
 */

class Rotation extends InitializerBase
{
	public var angle(angleGetter,null):Float;
	public var maxAngle(maxAngleGetter,null):Float;
	public var minAngle(minAngleGetter,null):Float;
	public var axis(axisGetter,null):Vector3D;
	
	private var _axis : Vector3D;
	private var _min : Float;
	private var _max : Float;
	private var _rot:Quaternion;

	/**
	 * The constructor creates a Rotation initializer for use by 
	 * an emitter. To add a Rotation to all particles created by an emitter, use the
	 * emitter's addInitializer method.
	 * 
	 * <p>The rotation of particles initialized by this class
	 * will be a random value between the minimum and maximum
	 * values set. If no maximum value is set, the minimum value
	 * is used with no variation.</p>
	 * 
	 * @param axis The axis around which the rotation occurs.
	 * @param minAngle The minimum angle, in radians, for the particle's rotation.
	 * @param maxAngle The maximum angle, in radians, for the particle's rotation.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
	 */
	public function new( axis:Vector3D = null, minAngle:Float = 0, maxAngle:Float = -1 )
	{
		super();
		_rot = new Quaternion();
		this.axis = axis != null ? axis : Vector3D.Z_AXIS;
		this.minAngle = minAngle;
		this.maxAngle = maxAngle;
	}
	
	/**
	 * The axis for the rotation.
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
	 * The minimum angle for particles initialised by 
	 * this initializer.
	 */
	private function minAngleGetter():Float
	{
		return _min;
	}
	private function minAngleSetter( value:Float ):Float
	{
		_min = value;
		return value;
	}
	
	/**
	 * The maximum angle for particles initialised by 
	 * this initializer.
	 */
	private function maxAngleGetter():Float
	{
		return _max;
	}
	private function maxAngleSetter( value:Float ):Float
	{
		_max = value;
		return value;
	}
	
	/**
	 * When reading, returns the average of minAngle and maxAngle.
	 * When writing this sets both maxAngle and minAngle to the 
	 * same angle value.
	 */
	private function angleGetter():Float
	{
		if( Math.isNaN( _max ) || _min == _max )
		{
			return _min;
		}
		return ( _max + _min ) / 2;
	}
	private function angleSetter( value:Float ):Float
	{
		_max = _min = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function initialize( emitter : Emitter, particle : Particle ) : Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		var angle:Float;
		if( Math.isNaN( _max ) || _min == _max )
		{
			angle = _min;
		}
		else
		{
			angle = _min + Math.random() * ( _max - _min );
		}
		_rot.setFromAxisRotation( _axis, angle );
		p.rotation.preMultiplyBy( _rot );
	}
}
