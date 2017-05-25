package com.core.coreGraphics
{
	import flash.text.TextFormat;
	
	public class ZFont extends TextFormat
	{
		/**
		 * @param font SimHei
		 * @param size
		 * @param color
		 * @param bold
		 * @param italic
		 * @param underline
		 * @param url
		 * @param target
		 * @param align
		 * @param leftMargin
		 * @param rightMargin
		 * @param indent
		 * @param leading
		 */		
		public function ZFont(font:String=null, size:Object=null, color:Object=null, bold:Object=null, italic:Object=null, underline:Object=null, url:String=null, target:String=null, align:String=null, leftMargin:Object=null, rightMargin:Object=null, indent:Object=null, leading:Object=null)
		{
			super(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
		}
		
		public static function fontBySize(size: Object): ZFont
		{
			return new ZFont(null, size);
		}
		
		public static function boldSystemFontOfSize(size: Object): ZFont
		{
			return new ZFont(null, size, null, true);
		}
	}
}