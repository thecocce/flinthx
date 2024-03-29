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
 * The TargetVelocity action adjusts the velocity of the particle towards the 
 * target velocity.
 */
class TargetVelocity extends ActionBase
{
	public var targetVelocityX(targetVelocityXGetter,targetVelocityXSetter):Float;
	public var targetVelocityY(targetVelocityYGetter,targetVelocityYSetter):Float;
	public var rate(rateGetter, rateSetter):Float;
	
	private var _velX:Float;
	private var _velY:Float;
	private var _rate:Float;
	
	/**
	 * The constructor creates a TargetVelocity action for use by an emitter. 
	 * To add a TargetVelocity to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param velX The x coordinate of the target velocity, in pixels per second.
	 * @param velY The y coordinate of the target velocity, in pixels per second.
	 * @param rate Adjusts how quickly the particle reaches the target velocity.
	 * Larger numbers cause it to approach the target velocity more quickly.
	 */
	public function new( targetVelocityX:Float = 0, targetVelocityY:Float = 0, rate:Float = 0.1 )
	{
		super();
		this.targetVelocityX = targetVelocityX;
		this.targetVelocityY = targetVelocityY;
		this.rate = rate;
	}
	
	/**
	 * The y coordinate of the target velocity, in pixels per second.
	 */
	private function targetVelocityYGetter():Float
	{
		return _velY;
	}
	private function targetVelocityYSetter( value:Float ):Float
	{
		_velY = value;
		return _velY;
	}
	
	/**
	 * The x coordinate of the target velocity, in pixels per second.s
	 */
	private function targetVelocityXGetter():Float
	{
		return _velX;
	}
	private function targetVelocityXSetter( value:Float ):Float
	{
		_velX = value;
		return _velX;
	}
	
	/**
	 * Adjusts how quickly the particle reaches the target velocity.
	 * Larger numbers cause it to approach the target velocity more quickly.
	 */
	private function rateGetter():Float
	{
		return _rate;
	}
	private function rateSetter( value:Float ):Float
	{
		_rate = value;
		return _rate;
	}
	
	/**
	 * Calculates the difference between the particle's velocity and
	 * the target and adjusts the velocity closer to the target by an
	 * amount proportional to the difference, the time and the rate of convergence.
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
		p.velX += ( _velX - p.velX ) * _rate * time;
		p.velY += ( _velY - p.velY ) * _rate * time;
	}
}
