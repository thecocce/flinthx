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

package org.flintparticles.twoD.actions;

import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.events.ParticleEvent;
import org.flintparticles.twoD.particles.Particle2D;

/**
 * The BoundingBox action confines each particle to a rectangle region. The 
 * particle bounces back off the sides of the rectangle when it reaches 
 * the edge. The bounce treats the particle as a circular body. By default,
 * no energy is lost in the collision. This can be modified by setting the
 * bounce property to a value other than 1, its default value.
 * 
 * This action has a priority of -20, so that it executes after 
 * all movement has occured.
 */

class BoundingBox extends ActionBase
{
	public var top(topGetter,topSetter):Float;
	public var bounce(bounceGetter,bounceSetter):Float;
	public var right(rightGetter,rightSetter):Float;
	public var left(leftGetter,leftSetter):Float;
	public var bottom(bottomGetter, bottomSetter):Float;
	
	private var _left : Float;
	private var _top : Float;
	private var _right : Float;
	private var _bottom : Float;
	private var _bounce : Float;

	/**
	 * The constructor creates a BoundingBox action for use by 
	 * an emitter. To add a BoundingBox to all particles created by an emitter, 
	 * use the emitter's addAction method.
	 * 
	 * @see org.flintparticles.common.emitters.Emitter#addAction()
	 * 
	 * @param left The left coordinate of the box.
	 * @param top The top coordinate of the box.
	 * @param right The right coordinate of the box.
	 * @param bottom The bottom coordinate of the box.
	 * @param bounce The coefficient of restitution when the particles bounce off the
	 * sides of the box. A value of 1 gives a pure elastic collision, with no energy loss. 
	 * A value between 0 and 1 causes the particle to loose enegy in the collision. A value 
	 * greater than 1 causes the particle to gain energy in the collision.
	 */
	public function new( left:Float = 0, top:Float = 0, right:Float = 0, bottom:Float = 0, bounce:Float = 1 )
	{
		super();
		priority = -20;
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
		this.bounce = bounce;
	}

	/**
	 * The left coordinate of the bounding box.
	 */
	public function leftGetter():Float
	{
		return _left;
	}
	public function leftSetter( value:Float ):Float
	{
		_left = value;
		return _left;
	}

	/**
	 * The top coordinate of the bounding box.
	 */
	public function topGetter():Float
	{
		return _top;
	}
	public function topSetter( value:Float ):Float
	{
		_top = value;
		return _top;
	}

	/**
	 * The left coordinate of the bounding box.
	 */
	public function rightGetter():Float
	{
		return _right;
	}
	public function rightSetter( value:Float ):Float
	{
		_right = value;
		return _right;
	}

	/**
	 * The left coordinate of the bounding box.
	 */
	public function bottomGetter():Float
	{
		return _bottom;
	}
	public function bottomSetter( value:Float ):Float
	{
		_bottom = value;
		return _bottom;
	}

	/**
	 * The coefficient of restitution when the particles bounce off the
	 * sides of the box. A value of 1 gives a pure pure elastic collision, with no energy loss. 
	 * A value between 0 and 1 causes the particle to loose enegy in the collision. A value 
	 * greater than 1 causes the particle to gain energy in the collision.
	 */
	public function bounceGetter():Float
	{
		return _bounce;
	}
	public function bounceSetter( value:Float ):Float
	{
		_bounce = value;
		return _bounce;
	}

	/**
	 * Tests whether the particle is at the edge of the box and, if so,
	 * adjusts its velocity to bounce in back towards the center of the
	 * box.
	 * 
	 * <p>This method is called by the emitter and need not be called by the 
	 * user</p>
	 * 
	 * @param emitter The Emitter that created the particle.
	 * @param particle The particle to be updated.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Action#update()
	 */
	override public function update( emitter : Emitter, particle : Particle, time : Float ) : Void
	{
		var p:Particle2D = cast( particle,Particle2D );
		var radius:Float = particle.collisionRadius;
		var position:Float;
		if ( p.velX > 0 && ( position = p.x + radius ) >= _right )
		{
			p.velX = -p.velX * _bounce;
			p.x += 2 * ( _right - position );
			if ( emitter.hasEventListener( ParticleEvent.BOUNDING_BOX_COLLISION ) )
			{
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
		}
		else if ( p.velX < 0 && ( position = p.x - radius ) <= _left )
		{
			p.velX = -p.velX * _bounce;
			p.x += 2 * ( _left - position );
			if ( emitter.hasEventListener( ParticleEvent.BOUNDING_BOX_COLLISION ) )
			{
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
		}
		if ( p.velY > 0 && ( position = p.y + radius ) >= _bottom )
		{
			p.velY = -p.velY * _bounce;
			p.y += 2 * ( _bottom - position );
			if ( emitter.hasEventListener( ParticleEvent.BOUNDING_BOX_COLLISION ) )
			{
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
		}
		else if ( p.velY < 0 && ( position = p.y - radius ) <= _top )
		{
			p.velY = -p.velY * _bounce;
			p.y += 2 * ( _top - position );
			if ( emitter.hasEventListener( ParticleEvent.BOUNDING_BOX_COLLISION ) )
			{
				emitter.dispatchEvent( new ParticleEvent( ParticleEvent.BOUNDING_BOX_COLLISION, p ) );
			}
		}
	}
}
