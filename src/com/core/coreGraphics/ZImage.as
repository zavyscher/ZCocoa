package com.core.coreGraphics
{
	import flash.display.BitmapData;
	
	public class ZImage extends BitmapData
	{
		public function ZImage(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}