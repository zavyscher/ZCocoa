package com.components.custom.views
{
	import com.components.ZView;
	import com.interfaces.ItemParentDelegate;
	
	public class ItemsParentView extends ZView
	{
		protected var _arrItems: Vector.<ItemBase> = new Vector.<ItemBase>();
		
		public var delegate: ItemParentDelegate;
		
		public function ItemsParentView()
		{
			super();
		}
		
		public function addItems(arr: Vector.<ItemBase>): void
		{
			_arrItems = arr;
			var len: int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				addItem(arr[i]);
			}
			this.layoutSubviews();
		}
		
		public function addItem(item: ItemBase, data: Object = null, isNeedLayout:Boolean=false): void
		{
			item.tag = _arrItems.length;
			item.data = data;
			item.callback = didClickItemHandler;
			_arrItems.push(item);
			this.addSubView(item);
			
			if (isNeedLayout)
				this.layoutSubviews();
		}
		
		private function didClickItemHandler(item: ItemBase): void
		{
			var len: int = _arrItems.length;
			for (var i: int = 0; i < len; i++)
			{
				_arrItems[i].selected = false;
				if (_arrItems[i].bindingView)
					_arrItems[i].bindingView.visible = false;
			}
			
			item.selected = true;
			if (item.bindingView)
				item.bindingView.visible = true;
			
			if (delegate)
			{
				delegate.didClickItem(item);
			}
		}
		
		public function getItemWithIndex(i: int): ItemBase
		{
			if (i >= _arrItems.length)
			{
				return null;
			}
			return _arrItems[i];
		}
		//
	}
}


