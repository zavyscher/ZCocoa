package com.components
{
	import com.interfaces.ItemParentDelegate;
	
	import flash.events.MouseEvent;

	public class ZTabBar extends ZView
	{
		private var _arrItems: Vector.<ZBarButtonItem> = new Vector.<ZBarButtonItem>();
		public var gap: int;
		public var delegate: ItemParentDelegate;
		
		public function ZTabBar()
		{
			super();
		}
		
		public function addItems(arr: Vector.<ZBarButtonItem>):void
		{
			_arrItems = arr;
			var len: int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				addItem(arr[i]);
			}
			this.layoutSubviews();
		}
		
		public function addItem(item: ZBarButtonItem, isNeedLayout: Boolean = false): void
		{
			item.tag = _arrItems.length;
			item.addEventListener(MouseEvent.CLICK, didClickHandler);
			_arrItems.push(item);
			this.addSubView(item);
			
			if (isNeedLayout)
				this.layoutSubviews();
		}
		
		override public function layoutSubviews():void
		{
			var len: int = _arrItems.length;
			for (var i: int = 0; i < len; i++)
			{
				var item: ZBarButtonItem = _arrItems[i];
				item.x = (item.width + gap) * i;
				item.y = 0;
			}
		}
		
		public function removeItem(item: ZBarButtonItem):void
		{
			var index: int = _arrItems.indexOf(item);
			if (index != -1)
			{
				_arrItems.splice(index, 1);
			}
		}
		
		//根据索引移除
		//code
		private function didClickHandler(e: MouseEvent):void
		{
			if (delegate)
			{
				var target: ZBarButtonItem = e.currentTarget as ZBarButtonItem;
				delegate.didClickItem(target);
			}
		}
	}
}