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

package org.flintparticles.threeD.actions;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.actions.Action;
import org.flintparticles.common.actions.ActionBase;
import org.flintparticles.threeD.particles.Particle3D;
import org.flintparticles.threeD.zones.Zone3D;

/**
 * The ZonedAction Action applies an action to the particle only if it is in the specified zone. 
 */
class ZonedAction extends ActionBase
{
	public var zone(zoneGetter,zoneSetter):Zone3D;
	public var invertZone(invertZoneGetter,invertZoneSetter):Bool;
	public var action(actionGetter,actionSetter):Action;
	override public var priority(priorityGetter,prioritySetter):Int;
	
	private var _action:Action;
	private var _zone:Zone3D;
	private var _invert:Bool;
	
	/**
	 * The constructor creates a ZonedAction action for use by 
	 * an emitter. To add a ZonedAction to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.emitters.Emitter#addAction()
	 * 
	 * @param action The action to apply when inside the zone.
	 * @param zone The zone in which to apply the action.
	 * @param invertZone If false (the default) the action is applied only to particles inside 
	 * the zone. If true the action is applied only to particles outside the zone.
	 */
	public function new( action:Action = null, zone:Zone3D = null, invertZone:Bool = false )
	{
		super();
		this.action = action;
		this.zone = zone;
		this.invertZone = invertZone;
	}
	
	/**
	 * The action to apply when inside the zone.
	 */
	private function actionGetter():Action
	{
		return _action;
	}
	private function actionSetter( value:Action ):Action
	{
		_action = value;
		return value;
	}
	
	/**
	 * The zone in which to apply the acceleration.
	 */
	private function zoneGetter():Zone3D
	{
		return _zone;
	}
	private function zoneSetter( value:Zone3D ):Zone3D
	{
		_zone = value;
		return value;
	}
	
	/**
	 * If false (the default), the action is applied to particles inside the zone.
	 * If true, the action is applied to particles outside the zone.
	 */
	private function invertZoneGetter():Bool
	{
		return _invert;
	}
	private function invertZoneSetter( value:Bool ):Bool
	{
		_invert = value;
		return value;
	}
	
	/**
	 * Provides access to the priority of the action being used.
	 * 
	 * @inheritDoc
	 */
	override private function priorityGetter():Int
	{
		return _action.priority;
	}
	override private function prioritySetter( value:Int ):Int
	{
		_action.priority = value;
		return value;
	}
	
	/**
	 * @inheritDoc
	 */
	override public function addedToEmitter( emitter:Emitter ):Void
	{
		_action.addedToEmitter( emitter );
	}
	
	/**
	 * @inheritDoc
	 */
	override public function removedFromEmitter( emitter:Emitter ):Void
	{
		_action.removedFromEmitter( emitter );
	}

	/**
	 * @inheritDoc
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		var p:Particle3D = cast( particle, Particle3D );
		if( _zone.contains( p.position ) )
		{
			if( !_invert )
			{
				_action.update( emitter, p, time );
			}
		}
		else
		{
			if( _invert )
			{
				_action.update( emitter, p, time );
			}
		}
	}
}
