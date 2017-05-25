package com.components.custom.views
{
	import com.components.ZImageView;
	import com.components.ZLabel;
	import com.components.ZView;
	import com.interfaces.IDraggable;
	import com.core.coreGraphics.ZImage;
	import com.core.manager.TipManager;
	
	/**(存储信息的)格子基类
	 * @author leetn-dmt-zavy
	 */	
	public class GridBase extends ZView implements IDraggable
	{
		protected static const ICON:uint 		= 0x1;
		protected static const ICON_BG:uint 	= 0x2;
		protected static const COUNT:uint 		= 0x4;
		protected static const LOCK:uint		= 0x8;
		protected static const BG:uint 			= 0x10;
		protected static const INFO:uint		= 0x20;
		protected static const SELECT:uint		= 0x40;
		
		private var _data: *;
		
		protected var bg: ZImageView;
		public var icon: ZImageView;
		protected var iconBg: ZImageView;
		protected var selectBg: ZImageView;
		protected var countTf: ZLabel;
		protected var infoTf: ZLabel;
		protected var lock: ZImageView;
		
		protected var _tipClass:Class;
		
		/**
		 * @param grids 将类型值用或运算符连接 如: ICON | ICON_BG | 
		 */		
		public function GridBase(grids: int)
		{
			if((grids & BG) > 0)
			{
				bg = new ZImageView();
				addChild(bg);
			}
			if((grids & INFO) > 0)
			{
				infoTf = new ZLabel();
				addChild(infoTf);
			}
			if((grids & ICON_BG) > 0)
			{
				iconBg = new ZImageView();
				addChild(iconBg);
			}
			if((grids&ICON) > 0)
			{
				icon = new ZImageView();
				addChild(icon);
			}
			if((grids&SELECT) > 0)
			{
				selectBg = new ZImageView();
				addChild(selectBg);
			}
			if((grids&COUNT) > 0)
			{
				countTf = new ZLabel();
				addChild(countTf);
			}
			if((grids&LOCK) > 0)
			{
				lock = new ZImageView();
				addChild(lock);
			}
			mouseChildren = false;
			init();
		}
		
		protected function init():void
		{
		}
		
		public function getIconBitmapData(): ZImage
		{
			if(!icon)return null;
			return icon.image;
		}	
		
		public function getIconBgBitmapdata(): ZImage 
		{
			if(!iconBg)return null;
			return iconBg.image;
		}
		
		public function set data(value: Object): void
		{
			_data = value;
			TipManager.bind(_tipClass, this, data);
		}
		
		public function get data(): Object
		{
			return _data;
		}
	}
}