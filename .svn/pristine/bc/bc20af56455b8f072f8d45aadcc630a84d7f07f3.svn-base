package com.components.controller
{
	import com.components.ZView;
	import com.core.manager.StageManager;
	import com.greensock.TweenLite;
	import com.interfaces.IViewController;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**声明变量习惯一般从上到下依次是M>V>C<br>
	 * 默认自身带有view容器
	 *@author xzm
	 */
	public class ZViewController extends EventDispatcher implements IViewController
	{
		protected var viewWidth: Number;
		protected var viewHeight: Number;
		
		private var _view: ZView = new ZView();
		private var _navigationCtrl: ZNavigationController;
		
		protected var _tween: TweenLite;
		protected var _isAnimating: Boolean;
		
		public var name: String;
		
		private var _window: ZView;

		public function ZViewController()
		{
			super();
			this.loadView();
			this.view.mouseEnabled = true;
		}
		
		public function loadView(): void
		{
			this.view.parentController = this;
			this.view.addEventListener(Event.ADDED, onAdded);
			this.view.onAddedToStage = onAddedToStage;
			this.viewDidLoad();
		}
		
		protected function onAdded(e:Event): void
		{
			this.viewWillAppear();
			this.viewWillLayoutSubviews();
		}
		
		protected function onAddedToStage(e:Event): void
		{
			this.viewDidLayoutSubviews();
			this.viewDidAppear();
			
			if (this.view.hasEventListener(Event.REMOVED) == false)
				this.view.addEventListener(Event.REMOVED, onRemoved);
			if (this.view.hasEventListener(Event.REMOVED_FROM_STAGE) == false)
				this.view.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			
			viewWidth = this.view.width;
			viewHeight = this.view.height;
		}
		
		protected function onRemoved(e:Event): void
		{
			this.viewWillDisappear();
		}
		
		protected function onRemoveFromStage(e:Event): void
		{
			this.viewDidDisappear();
		}
		
		//还需要改善, 增加internal管理器
		public function viewDidLoad(): void{}
		
		public function viewDidUnload(): void{}
		
		public function viewWillUnload(): void{}
		
		public function viewWillAppear(animated:Boolean = false): void{}
		
		public function viewWillDisappear(animated:Boolean = false): void{}
		
		public function viewDidAppear(animated:Boolean = false): void{}
		
		public function viewDidDisappear(animated:Boolean = false): void{}
		
		public function viewDidLayoutSubviews(): void{}
		
		public function viewWillLayoutSubviews(): void{}
		
		public function get view(): ZView
		{
			return _view;
		}
		
		public function set view(value: ZView): void
		{
			if(value == null)
			{
				return;
			}
			else
			{
				if (_view)
				{
					_view.removeFromSuperView();
					deinit();
					_view = null;
				}
			}
			
			_view = value;
			_view.parentController = this;
		}
		
		public function get window():ZView
		{
			return _window;
		}
		
		public function set window(value:ZView):void
		{
			if (!_window || value == null)
			{
				_window = value;
			}
		}
		
		public function setNavigationController(value:ZNavigationController): void
		{
			_navigationCtrl = value;
		}
		
		public function get navigationController():ZNavigationController
		{
			return _navigationCtrl;
		}
		
		public function get isAnimating(): Boolean
		{
			return _isAnimating;
		}
		
		public function popViewControllerAnimated(animated: Boolean): ZViewController
		{
			if(_navigationCtrl)
			{
				return _navigationCtrl.popToViewControllerAnimated(animated);
			}
			
			return null;
		}
		
		public function popViewController(viewController: ZViewController, animated: Boolean = true): ZViewController
		{
			if(_navigationCtrl)
			{
				return _navigationCtrl.popToViewController(this, viewController);
			}
			return null ;
		}
		
		public function popToRootViewController(animated: Boolean = true, completion: Function = null): ZViewController
		{
			if(_navigationCtrl)
			{
				return _navigationCtrl.popRootViewController(animated, completion);
			}
			return null ;
		}
		
		/**提供给ZNavigationController使用的动画播放, 访问权限控制有限, 慎用
		 * @param completion 不带参数
		 */
		public function animatePush(completion: Function): void
		{
			_isAnimating = true;
			this.view.mouseChildren = false;
			viewWidth ||= StageManager.width;
			viewHeight ||= StageManager.height;
			this.view.x = viewWidth + this.view.offset.x;
			_tween = TweenLite.to(this.view, 1, {x: 0, onComplete: tweenCompletion, onCompleteParams: [completion]});
		}
		
		/**
		 * @param completion 不带参数
		 */
		public function animatePop(completion: Function): void
		{
			_isAnimating = true;
			_tween = TweenLite.to(this.view, 1, {x: viewWidth + this.view.offset.x, onComplete: tweenCompletion, onCompleteParams: [completion]});
		}
		
		/**tween动画完成后执行函数, tween对象进行kill和设为null
		 * @param completion
		 */		
		protected function tweenCompletion(completion: Function): void
		{
			_tween.kill();
			_tween = null;
			if (completion is Function)
			{
				_isAnimating = false;
				this.view.mouseChildren = true;
				completion();
			}
		}
		
		public function deinit(): void
		{
			_view.onAddedToStage = null;
			_view.removeEventListener(Event.ADDED, onAdded);
			_view.removeEventListener(Event.REMOVED, onRemoved);
			_view.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		//
	}
}


