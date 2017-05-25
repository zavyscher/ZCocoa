package com.components.controller
{
	import com.components.ZBarButtonItem;
	import com.components.ZTabBar;
	import com.components.ZView;
	import com.core.coreGraphics.CGPoint;
	
	public class ZTabBarViewController extends ZViewController
	{
		public var viewControllers: Array;
		private var _items: Array = [];
		
		protected var viewContent: ZView = new ZView();
		protected var viewTabBar: ZView = new ZView();
		private var _tabBar: ZTabBar = new ZTabBar();
		
		public function ZTabBarViewController()
		{
			super();
			viewControllers = [];
			_items = [];
			this.view.addSubView(viewContent);
			this.view.addSubView(viewTabBar);
			viewTabBar.addSubView(_tabBar);
			setTabBarPos(new CGPoint(0, 0));
		}
		
		public function setTabBarPos(pos: CGPoint):void
		{
			_tabBar.x = pos.x;
			_tabBar.y = pos.y;
			pos = null;
		}
		
		public function setItems(itemsArr: Array): void
		{
			if (!itemsArr)//不能出现数组为空的情况
			{
				itemsArr = [];
			}
			_items = itemsArr;
			var len: int = itemsArr.length;
			for (var i: int = 0; i < len; i++)
			{
				var item: ZBarButtonItem = itemsArr[i] as ZBarButtonItem;
				_tabBar.addItem(item);
			}
			if (_tabBar.numChildren > 0)
				_tabBar.layoutSubviews();
		}
		
		public function get tabBar(): ZTabBar
		{
			return _tabBar;
		}
	}
}