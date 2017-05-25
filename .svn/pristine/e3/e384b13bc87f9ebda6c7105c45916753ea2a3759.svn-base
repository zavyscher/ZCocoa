package com.components.custom.views
{
	import com.components.ZView;
	import com.core.coreGraphics.CGRect;
	import com.core.coreGraphics.CGSize;
	
	import flash.events.MouseEvent;

	public class ZCheckBox extends ItemBase
	{
		public static const NORMAL_SIZE: CGSize = new CGSize(24, 24);
		public static const SELECTED_SIZE: CGSize = new CGSize(18, 18);
		
		protected var _normalSkin: ZView;
		protected var _selectedSkin: ZView;
		
		public function ZCheckBox()
		{
			super();
		}
		
		override protected function didClickItemHandler(e: MouseEvent):void
		{
			selected = !_selected;
			if (callback is Function)
			{
				callback(this);
			}
		}
		
		public function setNormalSkin(size: CGSize, border: Boolean = true): void
		{
			_normalSkin = new ZView();
			if (border)
			{
				_normalSkin.graphics.lineStyle(0.2, 0x666666);
			}
			_normalSkin.drawRectWithColor(0xffffff, new CGRect(0, 0, size.width, size.height), border ? 0 : 1);
			this.addSubView(_normalSkin);
		}
		
		public function setSelectedSkin(size: CGSize): void
		{
			if (!_normalSkin)
			{
				setNormalSkin(new CGSize(size.width + 5, size.height + 5), false);
			}
			_selectedSkin = new ZView();
			_selectedSkin.drawRectWithColor(0xcccccc, new CGRect(0, 0, size.width, size.height));
			_selectedSkin.x = _normalSkin.x + 3;
			_selectedSkin.y = _normalSkin.y + 3.5;
			this.addSubView(_selectedSkin);
			_selectedSkin.visible = false;
		}
		
		override public function set selected(value:Boolean):void
		{
			_selected = value;
			if (_selectedSkin)
			{
				_selectedSkin.visible = value;
			}
		}
		//
	}
}


