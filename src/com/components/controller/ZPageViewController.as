package com.components.controller
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ZPageViewController extends ZViewController
	{
		protected var _totalCount: int;
		protected var _pageSize: int;
		protected var _currentPage: int;
		protected var _numberOfPages: int;
		
		private var _prevBtn: Sprite;
		private var _nextBtn: Sprite;
		
		private var _prevFunc: Function;
		private var _nextFunc: Function;
		
		public function ZPageViewController()
		{
			super();
		}
		
		override public function viewDidAppear(animated:Boolean=false):void
		{
			currentPage = 0;
		}
		
		/**设置当前页数(只提供方法, 不包含逻辑)
		 * @param value 建议以1为起点
		 */		
		public function set currentPage(value: int):void
		{
			_currentPage = value;
		}
		
		public function get currentPage(): int
		{
			return _currentPage;
		}
		
		/**
		 * @param value 总页数
		 */		
		public function set numberOfPages(value:int):void
		{
			_numberOfPages = value;
		}
		
		public function get numberOfPages():int
		{
			return _numberOfPages;
		}
		
		/**上一页
		 * @param value
		 * @param func 回调参数是MouseEvent.CLICK事件, 注册对象是ZButton
		 */
		public function setPrevBtn(value: Sprite, func: Function): void
		{
			if (!value)
				return ;
			value.buttonMode = true;
			_prevFunc = func;
			_prevBtn = value;
			_prevBtn.addEventListener(MouseEvent.CLICK, onPrevPageHandler);
		}
		
		/**下一页
		 * @param value
		 * @param func 回调参数是MouseEvent.CLICK事件, 注册对象是ZButton
		 */
		public function setNextBtn(value: Sprite, func: Function): void
		{
			if (!value)
				return ;
			value.buttonMode = true;
			_nextFunc = func;
			_nextBtn = value;
			_nextBtn.addEventListener(MouseEvent.CLICK, onNextPageHandler);
		}
		
		private function onPrevPageHandler(e: MouseEvent): void
		{
			if (_prevFunc is Function)
			{
				_prevFunc(e);
			}
		}
		
		private function onNextPageHandler(e: MouseEvent): void
		{
			if (_nextFunc is Function)
			{
				_nextFunc(e);
			}
		}
		//
	}
}


