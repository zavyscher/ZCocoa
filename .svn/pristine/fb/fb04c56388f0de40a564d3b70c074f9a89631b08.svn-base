package com.components
{
	public class ZPageControl extends ZView
	{
		private var _numberOfPages: int;
		private var _currentPage: int;
		public var gap: int = 24;

		private var _pageIndicatorTintColor: uint = 0x000000;
		private var _currentPageIndicatorTintColor: uint = 0xffffff;
		
		private var _arrIndicators: Array;
		
		private var _ctnIndicators: ZView;
		
		public var hidesForSinglePage: Boolean;

		public function ZPageControl()
		{
			super();
			_arrIndicators = [];
			_ctnIndicators = new ZView();
			this.addSubView(_ctnIndicators);
		}
		
		public function cleanIndicators(): void
		{
//			var len: int = _arrIndicators.length;
//			for (var i: int = 0; i < len; i++)
//			{
//				var item: Indicator = _arrIndicators[i] as Indicator;
//				item.removeFromSuperView();
//				//code
//			}
			while (_ctnIndicators.numChildren > 0)
			{
				var item: Indicator = _ctnIndicators.removeChildAt(0) as Indicator;
				item.deinit();
			}
		}
		
		public function set numberOfPages(value:int):void
		{
			_numberOfPages = value;
//			for (var i: int = 0; i < value; i++)
//			{
//				var item: Indicator = Indicator.getInstance();
//				item.color = pageIndicatorTintColor;
//				item.x = (item.width + gap) * i;
//				_ctnIndicators.addSubView(item);
//			}
			//code
		}
		
		public function get numberOfPages():int
		{
			return _numberOfPages;
		}
		
		public function set currentPage(value:int):void
		{
			_currentPage = value;
		}
		
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		public function set pageIndicatorTintColor(value: uint):void
		{
			_pageIndicatorTintColor = value;
		}
		
		public function get pageIndicatorTintColor(): uint
		{
			return _pageIndicatorTintColor;
		}
		
		public function set currentPageIndicatorTintColor(value: uint):void
		{
			_currentPageIndicatorTintColor = value;
		}
		
		public function get currentPageIndicatorTintColor(): uint
		{
			return _currentPageIndicatorTintColor;
		}
		
	}
}

import com.components.ZView;
import com.core.pool.ObjectPool;

class Indicator extends ZView
{
	private static var iconSize: int = 24;
	
	public static function getInstance(): Indicator {
		return ObjectPool.getObjectByClass(Indicator);
	}
	
	public function Indicator()
	{
	}
	
	public function set color(value: uint): void
	{
		this.graphics.clear();
		
		this.graphics.beginFill(value);
		this.graphics.drawCircle(iconSize >> 1, iconSize >> 1, iconSize);
		this.graphics.endFill();
	}
	
	override public function deinit():void
	{
		this.graphics.clear();
		ObjectPool.recycle(this);
	}
}


