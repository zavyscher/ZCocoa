package com.core.coreGraphics
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	/**定义经典颜色值(同时包含常用滤镜:灰度,投影), 根据传入颜色值进行计算<b>[未扩展]</b>
	 * @author leetn-zavyscher
	 */
	public class ZColor
	{
		/**灰度滤镜*/
		public static const grayFilter: ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
		
		/**投影滤镜*/
		public static const dropFilter: DropShadowFilter = new DropShadowFilter(5, 45, 0, 1, 10, 10, 1);
		
		/**黑色描边*/
		public static const blackGlowFilter: GlowFilter = new GlowFilter(0x000000, 1, 2, 2, 5);
		
		/**白色描边*/
		public static const whiteGlowFilter: GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 5);
		
		/**自定义颜色描边*/
		public static function glowFilterWith(color: uint): GlowFilter
		{
			return new GlowFilter(color, 1, 5, 5, 3);
		}
	}
}