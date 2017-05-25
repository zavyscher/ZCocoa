package com.core.manager
{
	import com.core.resourse.ZLoader;
	
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	/**字体库, 一次性加载嵌入(demo, 未扩展完成)
	 */	
	public class FontManager
	{
		/**保存字体类, 结构:[ClassName : Class]*/
		private static var _fontDic: Dictionary = new Dictionary();
		
		public static function getFont(url: String, className: String, complete: Function, priority: int = 10):void
		{
			if (getFontWithName(className) == null)
			{
				ZLoader.addFont(url, className, function(info: Object): void
				{
					onLoad(info);
					if (complete is Function)
					{
						complete(getFontWithName(info.className));
					}
				}, null, priority);
			}
			else
			{
				if (complete is Function)
				{
					complete(getFontWithName(className));
				}
			}
		}
		
		private static function onLoad(info: Object):void
		{
			if (info.content is Class)
			{
				var fontClass: Class = info.content as Class;
				Font.registerFont(fontClass);
				_fontDic[info.className] = fontClass;
			}
		}
		
		public static function getFontWithName(fontName: String): Class
		{
			if (_fontDic[fontName] == undefined)
			{
				return null;
			}
			return _fontDic[fontName];
		}
	}
}


