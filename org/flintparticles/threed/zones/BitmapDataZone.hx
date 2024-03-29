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

package org.flintparticles.threed.zones;

import nme.display.BitmapData;
import nme.geom.Matrix3D;
import nme.geom.Point;
import nme.geom.Vector3D;
import org.flintparticles.common.utils.FastWeightedArray;
import org.flintparticles.threed.geom.Matrix3DUtils;
import org.flintparticles.threed.geom.Vector3DUtils;
import org.flintparticles.threed.zones.Zone3D;


/**
 * The BitmapData zone defines a shaped zone based on a BitmapData object.
 * The zone contains all pixels in the bitmap that are not transparent -
 * i.e. they have an alpha value greater than zero.
 */

class BitmapDataZone implements Zone3D 
{
	public var top(topGetter,topSetter):Vector3D;
	public var left(leftGetter,leftSetter):Vector3D;
	public var corner(cornerGetter,cornerSetter):Vector3D;
	public var bitmapData(bitmapDataGetter,bitmapDataSetter):BitmapData;
	
	private var _bitmapData : BitmapData;
	private var _corner : Vector3D;
	private var _top : Vector3D;
	private var _scaledWidth : Vector3D;
	private var _left : Vector3D;
	private var _scaledHeight : Vector3D;
	private var _normal : Vector3D;
	private var _basis : Matrix3D;
	private var _distToOrigin:Float;
	private var _dirty:Bool;
	private var _volume : Float;
	private var _validPoints : FastWeightedArray;
	
	/**
	 * The constructor creates a BitmapDataZone zone. To avoid distorting the zone, the top
	 * and left vectors should be perpendicular and the same lengths as the width and
	 * height of the bitmap data object. Vectors that are not the same width and height
	 * as the bitmap data object will scale the zone and vectors that are not perpendicular
	 * will skew the zone.
	 * 
	 * @param bitmapData The bitmapData object that defines the zone.
	 * @param corner The position for the top left corner of the bitmap data for the zone.
	 * @param top The top side of the zone from the corner. The length of the vector 
	 * indicates how long the side is.
	 * @param left The left side of the zone from the corner. The length of the
	 * vector indicates how long the side is.
	 */
	public function new( bitmapData : BitmapData = null, corner:Vector3D = null, top:Vector3D = null, left:Vector3D = null )
	{
		_bitmapData = bitmapData;
		this.corner = corner != null ? corner : new Vector3D();
		this.top = top != null ? top : Vector3D.X_AXIS;
		this.left = left != null ? left : new Vector3D( 0, 1, 0 );
		if( _bitmapData != null )
		{
			_dirty = true;
			invalidate();
		}
	}
	
	/**
	 * The bitmapData object that defines the zone.
	 */
	private function bitmapDataGetter() : BitmapData
	{
		return _bitmapData;
	}
	private function bitmapDataSetter( value : BitmapData ) : BitmapData
	{
		_bitmapData = value;
		invalidate();
		return _bitmapData;
	}

	/**
	 * The position for the top left corner of the bitmap data for the zone.
	 */
	private function cornerGetter() : Vector3D
	{
		return _corner.clone();
	}

	private function cornerSetter( value : Vector3D ) : Vector3D
	{
		_corner = Vector3DUtils.clonePoint( value );
		return _corner;
	}

	/**
	 * The top side of the zone from the corner. The length of the vector 
	 * indicates how long the side is.
	 */
	private function topGetter() : Vector3D
	{
		return _top.clone();
	}

	private function topSetter( value : Vector3D ) : Vector3D
	{
		_top = Vector3DUtils.cloneVector( value );
		_dirty = true;
		return _top;
	}

	/**
	 * The left side of the zone from the corner. The length of the
	 * vector indicates how long the side is.
	 */
	private function leftGetter() : Vector3D
	{
		return _left.clone();
	}

	private function leftSetter( value : Vector3D ) : Vector3D
	{
		_left = Vector3DUtils.cloneVector( value );
		_dirty = true;
		return _left;
	}

	/**
	 * This method forces the zone to revaluate itself. It should be called whenever the 
	 * contents of the BitmapData object change. However, it is an intensive method and 
	 * calling it frequently will likely slow your code down.
	 */
	public function invalidate():Void
	{
		_validPoints = new FastWeightedArray();
		//for( var x : Int = 0; x < _bitmapData.width ; ++x )
		var x : Int = 0;
		while( x < _bitmapData.width )
		{
			//for( var y : Int = 0; y < _bitmapData.height ; ++y )
			var y : Int = 0;
			while( y < _bitmapData.height )
			{
				var pixel : Int = _bitmapData.getPixel32( x, y );
				var ratio : Float = ( pixel >> 24 & 0xFF ) / 0xFF;
				if ( ratio != 0 )
				{
					_validPoints.add( new Point( x, _bitmapData.height-y ), ratio );
				}
				++y;
			}
			++x;
		}
		_volume = _top.crossProduct( _left ).length * _validPoints.totalRatios / ( _bitmapData.width * _bitmapData.height );
		_dirty = true;
	}

	private function init():Void
	{
		_normal = _top.crossProduct( _left );
		_distToOrigin = _normal.dotProduct( _corner );
		_scaledWidth = _top.clone();
		_scaledWidth.scaleBy( 1 / _bitmapData.width );
		_scaledHeight = _left.clone();
		_scaledHeight.scaleBy( 1 / _bitmapData.height );
		var perp:Vector3D = _top.crossProduct( _left );
		perp.normalize();
		_basis = Matrix3DUtils.newBasisTransform( _scaledWidth, _scaledHeight, perp );
		_basis.prependTranslation( -_corner.x, -_corner.y, -_corner.z );
		_dirty = false;
	}

	/**
	 * The contains method determines whether a point is inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @param x The x coordinate of the location to test for.
	 * @param y The y coordinate of the location to test for.
	 * @return true if point is inside the zone, false if it is outside.
	 */
	public function contains( p:Vector3D ):Bool
	{
		if( _dirty )
		{
			init();
		}
		var dist:Float = _normal.dotProduct( p );
		if( Math.abs( dist - _distToOrigin ) > 0.1 ) // test for close, not exact
		{
			return false;
		}
		var q:Vector3D = _basis.transformVector( p );
		
		var pixel : Int = _bitmapData.getPixel32( Math.round( q.x ), Math.round( _bitmapData.height-q.y ) );
		return ( pixel >> 24 & 0xFF ) != 0;
	}
	
	/**
	 * The getLocation method returns a random point inside the zone.
	 * This method is used by the initializers and actions that
	 * use the zone. Usually, it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getLocation():Vector3D
	{
		if( _dirty )
		{
			init();
		}
		var point:Point =  cast( _validPoints.getRandomValue(), Point ).clone();
		var d1:Vector3D = _scaledWidth;
		d1.scaleBy( point.x );
		var d2:Vector3D = _scaledHeight;
		d2.scaleBy( point.y );
		d1.incrementBy( d2 );
		return _corner.add( d1 );
	}
	
	/**
	 * The getVolume method returns the size of the zone.
	 * This method is used by the MultiZone class. Usually, 
	 * it need not be called directly by the user.
	 * 
	 * @return a random point inside the zone.
	 */
	public function getVolume():Float
	{
		return _volume;
	}
}
