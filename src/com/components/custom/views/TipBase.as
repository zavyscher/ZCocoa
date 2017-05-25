package com.components.custom.views
{
	import com.components.ZImageView;
	import com.components.ZLabel;
	import com.components.ZView;
	import com.interfaces.ITip;
	import com.core.coreGraphics.ZColor;
	import com.core.manager.ResourceManager;
	
	/**提示框基类(鼠标交互)
	 * @author leetn-dmt-zavy
	 */	
	public class TipBase extends ZView implements ITip
	{
		protected var _urlBg: String;
		private var _data: *;
		
		protected var border: ZImageView;
		
		public function TipBase()
		{
			init();
		}
		
		protected function init():void
		{
			addBorder(_urlBg);
		}
		
		/**可通过重写此方法显示不同排版的数据
		 * @param value
		 */		
		public function show(value: *):void
		{
			this._data = value;
		}
		
		protected function get data(): *
		{
			return _data;
		}
		
		public function clean():void
		{
			this.removeFromSuperView();
		}
		
		final protected function addBorder(url: String): void
		{
			if(!border)
			{
				border = new ZImageView();
				this.addSubView(border);
				if (url)
				{
					ResourceManager.getBitmap(border.bitmap, url);
				}
			}
		}
		
		protected function createLine(x:int, y:int, width:int, url: String): ZImageView 
		{
			var line: ZImageView = new ZImageView();
			this.addSubView(line);
			line.x = x;
			line.y = y;
			ResourceManager.getBitmap(line.bitmap, url, function (): void{
				line.scaleX = width / line.image.width;
			});
			return line;
		}
		
		protected function createLabel(x:int, y:int, width:int, height:int, color:int = 0xffffff, content:String = ""): ZLabel 
		{
			var label: ZLabel = new ZLabel;
			label.multiline = true;
			label.wordWrap = true;
			label.leading = 4;
			label.filters = [ZColor.blackGlowFilter];
			this.addSubView(label);
			return label;
		}
		
		override public function get width():Number 
		{
			if(border)
			{
				return border.width;
			}
			else
			{
				return super.width;
			}
		}
		
		override public function get height():Number 
		{
			if(border)
			{
				return border.height;
			}
			else
			{
				return super.height;
			}
		}
	}
}


