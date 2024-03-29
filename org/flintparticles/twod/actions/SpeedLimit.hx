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

package org.flintparticles.twod.actions;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.twod.particles.Particle2D;

/**
 * The SpeedLimit action limits each particle's maximum or minimum speed to the 
 * specified speed.
 * 
 * <p>This action has aa priority of -5, so that it executes after all accelerations 
 * have occured.</p>
 */

class SpeedLimit extends ActionBase
{
	public var isMinimum(isMinimumGetter,isMinimumSetter):Bool;
	public var limit(limitGetter, limitSetter):Float;
	
	private var _limit:Float;
	private var _limitSq:Float;
	private var _isMinimum:Bool;
	
	/**
	 * The constructor creates a SpeedLimit action for use by an emitter. 
	 * To add a SpeedLimit to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param speed The speed limit for the action in pixels per second.
	 * @param isMinimum If true, particles travelling slower than the speed limit
	 * are accelerated to the speed limit, otherwise particles travelling faster
	 * than the speed limit are decelerated to the speed limit.
	 */
	public function new( speed:Float = 1000, isMinimum:Bool = false )
	{
		super();
		priority = -5;
		this.limit = speed;
		this.isMinimum = isMinimum;
	}
	
	/**
	 * The speed limit
	 */
	private function limitGetter():Float
	{
		return _limit;
	}
	private function limitSetter( value:Float ):Float
	{
		_limit = value;
		_limitSq = value * value;
		return _limit;
	}
	
	/**
	 * Whether the speed is a minimum (true) or maximum (false) speed.
	 */
	private function isMinimumGetter():Bool
	{
		return _isMinimum;
	}
	private function isMinimumSetter( value:Bool ):Bool
	{
		_isMinimum = value;
		return _isMinimum;
	}

	/**
	 * Checks whether the particle's speed is above or below the speed limit
	 * as appropriate and, if so, alters its speed to match the speed limit.
	 * 
	 * <p>This method is called by the emitter and need not be called by the 
	 * user.</p>
	 * 
	 * @param emitter The Emitter that created the particle.
	 * @param particle The particle to be updated.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Action#update()
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle2D = cast( particle,Particle2D );
		var speedSq:Float = p.velX * p.velX + p.velY * p.velY;
		if ( ( _isMinimum && speedSq < _limitSq ) || ( !_isMinimum && speedSq > _limitSq ) )
		{
			var scale:Float = _limit / Math.sqrt( speedSq );
			p.velX *= scale;
			p.velY *= scale;
		}
	}
}
