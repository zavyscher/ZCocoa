package com.core.coreGraphics
{
	import flash.geom.Point;

	/**
	 *@author xzm
	 */
	public class CGPoint extends Point
	{
		public function CGPoint(x:Number = 0, y:Number = 0)
		{
			super(x, y);
		}
		
		public static function get Zero():CGPoint
		{
			return new CGPoint();
		}
	}
}