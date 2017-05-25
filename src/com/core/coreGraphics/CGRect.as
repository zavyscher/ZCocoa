package com.core.coreGraphics
{
	/**
	 *@author xzm
	 */
	public class CGRect
	{
		public var origin:CGPoint;
		public var size:CGSize;
		
		public function CGRect(x: Number = 0, y: Number = 0, width: Number = 0, height: Number = 0)
		{
			origin = new CGPoint(x, y);
			size = new CGSize(width, height);
		}
		
		public static function get Zero():CGRect
		{
			return new CGRect();
		}
	}
}