package com.components.custom.views
{
	import com.components.ZButton;
	import com.components.ZView;
	import com.interfaces.ITarget;
	import com.interfaces.IValueObject;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class ItemBase extends ZView implements IValueObject, ITarget
	{
		protected var _data: Object;
		
		protected var _btn: ZButton;
		
		/**返回参数是本身*/
		public var callback: Function;
		
		public var bindingView: DisplayObject;
		
		protected var _selected: Boolean;
		
		public function ItemBase()
		{
			super();
			this.mouseEnabled = true;
			this.addEventListener(MouseEvent.CLICK, didClickItemHandler);
		}
		
		protected function didClickItemHandler(e: MouseEvent):void
		{
			selected = !_selected;
			if (callback is Function)
			{
				callback(this);
			}
		}
		
		public function setBtn(btn: ZButton): void
		{
			if (btn)
			{
				if (_btn)
				{
					_btn.removeFromSuperView();
				}
				this.addSubView(btn);
			}
			_btn = btn;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if (_btn)
			{
				_btn.selected = value;
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set data(value: Object):void
		{
			_data = value;
		}
		
		public function get data(): Object
		{
			return _data;
		}
		//
	}
}


