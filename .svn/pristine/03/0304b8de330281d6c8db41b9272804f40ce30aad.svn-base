package com.components.controller
{
	import com.core.manager.StageManager;
	
	import flash.events.MouseEvent;
	
	/**导航视图控制器
	 * @author leetn-dmt-zavy
	 */	
	public class ZNavigationController extends ZViewController
	{
		private static const ANIMATION_PUSH: String = "animation_push";
		private static const ANIMATION_POP: String = "animation_pop";
		
		private var _viewControllers: Vector.<ZViewController>;
		private var _rootViewController:ZViewController;
		private var _currentViewController: ZViewController;
		private var _previousViewController: ZViewController;
		
		/**结构是[<b>ZViewController</b>, <b>String[ANIMATION_PUSH, ANIMATION_POP]</b>(切换类型:插入;返回), <b>Function</b>(完成后回调), <b>Boolean</b>(过渡动画开关), <b>ZViewController</b>(前一个视图控制器, 未用)]*/
		private var _animationArr: Array;
		private var temX: Number;
		private var temY: Number;
		
		public function ZNavigationController(root: ZViewController)
		{
			_viewControllers = new Vector.<ZViewController>();
			_rootViewController = root;
			root.setNavigationController(this);
			this.view.addSubView(_rootViewController.view);
			this.view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		
		private function onMouseDownHandler(e: MouseEvent):void
		{
			temX = e.stageX;
			temY = e.stageY;
			this.view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			this.view.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		private function onMouseUpHandler(e: MouseEvent):void
		{
			if (temX < 100 && e.stageX > StageManager.halfWidth)
			{
				this.popViewControllerAnimated(true);
			}
			this.view.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			this.view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		
		public function get rootViewController():ZViewController
		{
			return _rootViewController;
		}
		
		public function get viewControllers():Vector.<ZViewController>
		{
			return _viewControllers;
		}
		
		/**当前弹出显示的VC*/
		public function get currentPopUpViewController(): ZViewController
		{
			return _currentViewController;
		}
		
		/**
		 * @param viewController
		 * @param animated
		 * @param completion no params
		 */		
		public function pushViewController(viewController: ZViewController, animated: Boolean = false, completion: Function = null): void
		{
			if (_currentViewController == viewController)
				return;
			
			_currentViewController = viewController;
			viewController.setNavigationController(this);
			_previousViewController = (_viewControllers.length > 0) ? _viewControllers[_viewControllers.length - 1] : _rootViewController;
			
			_viewControllers.push(viewController);
			if (animated)
			{
				_animationArr ||= [];
				_animationArr.push([viewController, ANIMATION_PUSH, completion, animated, _previousViewController]);
				beginAnimations();
				this.view.addSubView(viewController.view);
			}
			else
			{
				this.view.addSubView(viewController.view);
				if (completion is Function)
				{
					completion();
				}
			}
		}
		
		/**一般只供ViewController调用
		 * @param animated
		 * @return 返回将要显示的VC(上一层VC)
		 */		
		public function popToViewControllerAnimated(animated: Boolean): ZViewController
		{
			var currentViewController: ZViewController = _viewControllers.pop();
			var temCompletion: Function = function (): void
			{
				if (!currentViewController)
				{
					return;
				}
				currentViewController.viewWillDisappear(animated);
				currentViewController.view.removeFromSuperView();
				currentViewController.viewDidDisappear(animated);
			};
			var len: int = _viewControllers.length;
			if (len > 0)
			{
				_currentViewController = _viewControllers[len - 1];
				if (len > 1)
				{
					_previousViewController = _viewControllers[len - 2];
				}
				else
				{
					_previousViewController
				}
			}
			else
			{
				_currentViewController = null ;
				_previousViewController = _rootViewController;
			}
			if (animated)
			{
				_animationArr ||= [];
				_animationArr.push([currentViewController, ANIMATION_POP, temCompletion, animated, _previousViewController]);
				beginAnimations();
			}
			else
			{
				temCompletion();
			}
			
			return _previousViewController;
		}
		
		/**一般只供ViewController调用
		 * @param currentViewController
		 * @param popTargetViewController 想要弹出的目标视图控制器
		 */
		public function popToViewController(currentViewController: ZViewController, popTargetViewController: ZViewController, animated: Boolean = true): ZViewController
		{
			var curIndex: int = _viewControllers.indexOf(currentViewController);
			var popIndex: int = _viewControllers.indexOf(popTargetViewController);
			if (curIndex != -1 && popIndex != -1)
			{
				var delLen: int = curIndex - popIndex - 1;
				if (delLen > 0)
				{
					for (var i: int = 0; i < delLen; i++)
					{
						var index: int = curIndex - 1 + i;
						_viewControllers[index].view.removeFromSuperView();
					}
					_viewControllers.splice(curIndex - 1, delLen);
				}
				return this.popToViewControllerAnimated(animated);
			}
			return null ;
		}
		
		public function popRootViewController(animated: Boolean = true, completion: Function = null): ZViewController
		{
			var len: int = _viewControllers.length;
			for (var i: int = 0; i < len; i++)
			{
				var vc: ZViewController = _viewControllers[i];
				if (animated && i == len - 1)
				{
					vc.animatePop(function (): void {
						vc.view.removeFromSuperView();
						vc = null;
						if (completion is Function)
							completion();
					});
					continue;
				}
				vc.view.removeFromSuperView();
				vc = null;
			}
			_viewControllers = new Vector.<ZViewController>();
			return _rootViewController;
		}
		
		public function get previousViewController(): ZViewController
		{
			return (_viewControllers.length > 0) ? _viewControllers[_viewControllers.length - 1] : null;
		}
		
		private function beginAnimations(): void
		{
			if (_animationArr.length < 1)
				return;
			
			if (!_isAnimating)
			{
				_isAnimating = true;
				var animation: Array = _animationArr.shift();
				var func: Function = function(): void
				{
					if (animation[0] && animation[2] is Function)
					{
						animation[2]();
						var currentViewController: ZViewController = animation[0];
						if (animation[1] == ANIMATION_PUSH)
						{
							currentViewController.viewWillAppear(animation[3]);
							currentViewController.viewDidAppear(animation[3]);
						}
						else
						{
							currentViewController.viewWillDisappear(animation[3]);
							currentViewController.viewDidDisappear(animation[3]);
						}
						currentViewController = null;
					}
					_isAnimating = false;
					beginAnimations();
				};
				if (!animation[0])
				{
					func();
					return ;
				}
				
				if (animation[1] == ANIMATION_PUSH)
				{
					(animation[0] as ZViewController).animatePush(func);
				}
				else
				{
					(animation[0] as ZViewController).animatePop(func);
				}
			}
		}
		//
	}
}


