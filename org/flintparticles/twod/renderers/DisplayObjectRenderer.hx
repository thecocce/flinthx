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

package org.flintparticles.twod.renderers;

import nme.display.DisplayObject;
import org.flintparticles.common.renderers.SpriteRendererBase;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twod.particles.Particle2D;


/**
 * The DisplayObjectRenderer adds particles to its display list 
 * and lets the flash player render them in its usual way.
 * 
 * <p>Particles may be represented by any DisplayObject and each particle 
 * must use a different DisplayObject instance. The DisplayObject
 * to be used should not be defined using the SharedImage initializer
 * because this shares one DisplayObject instance between all the particles.
 * The ImageClass initializer is commonly used because this creates a new 
 * DisplayObject for each particle.</p>
 * 
 * <p>The DisplayObjectRenderer has mouse events disabled for itself and any 
 * display objects in its display list. To enable mouse events for the renderer
 * or its children set the mouseEnabled or mouseChildren properties to true.</p>
 * 
 * <p>Because the DisplayObject3DRenderer directly uses the particle's image,
 * it is not suitable in situations where the same particle will be simultaneously
 * displayed by two different renderers.</p> 
 */
class DisplayObjectRenderer extends SpriteRendererBase
{
	/**
	 * The constructor creates a DisplayObjectRenderer. After creation it should
	 * be added to the display list of a DisplayObjectContainer to place it on 
	 * the stage and should be applied to an Emitter using the Emitter's
	 * renderer property.
	 * 
	 * @see org.flintparticles.twoD.emitters.Emitter#renderer
	 */
	public function new()
	{
		super();
	}
	
	/**
	 * @inheritDoc
	 */
	override private function renderParticles( particles:Array<Dynamic> ):Void
	{
		var particle:Particle2D;
		var img:DisplayObject;
		var len:Int = particles.length;
		//for( var i:Int = 0; i < len; ++i )
		for( i in 0 ... len )
		{
			particle = cast( particles[i],Particle2D );
			img = particle.image;
			img.transform.colorTransform = particle.colorTransform;
			img.transform.matrix = particle.matrixTransform;
		}
	}
	
	/**
	 * @inheritDoc
	 */
	override private function addParticle( particle:Particle ):Void
	{
		super.addParticle( particle );
		var p:Particle2D = cast(particle, Particle2D);
		addChildAt( p.image, 0 );
		var img:DisplayObject = p.image;
		img.transform.colorTransform = p.colorTransform;
		img.transform.matrix = p.matrixTransform;
	}
	
	/**
	 * @inheritDoc
	 */
	override private function removeParticle( particle:Particle ):Void
	{
		removeChild( particle.image );
		super.removeParticle( particle );
	}
}
