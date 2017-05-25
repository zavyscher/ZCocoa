package com.components.custom.views
{
	import com.components.ZView;
	import com.core.coreGraphics.CGRect;
	
	/**鸟瞰图(构成: 主图AirscapeOrigin, 副图(缩略图)AirscapeThumbnail, 摄像头AirscapeCamera)<br>
	 * 可通过构造函数定义新皮肤. 注: 未实现手势缩放
	 * @author leetn-zavyscher
	 */
	public class AirscapeCamera extends ZView
	{
		public function AirscapeCamera()
		{
			super();
			this.mouseEnabled = true;
		}
		
		override public function drawRectWithColor(color:uint, rect:CGRect, alpha:Number=1):void
		{
			this.graphics.lineStyle(5, color);
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
			this.graphics.endFill();
		}
		//
	}
}


