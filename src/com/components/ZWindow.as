package com.components
{
	import com.components.controller.ZViewController;
	import com.core.utils.Singleton;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**这是一个特殊view, 整个程序里面只有唯一一个, 包含四个层面, 分别是背景,UI界面,交互(特殊操作),提示
	 * @author leetn-zavyscher
	 */	
	public class ZWindow extends ZView
	{
		private static var _instance: ZWindow;
		private var _rootViewController: ZViewController;
		
		private var backgroundLayer: ZView = new ZView();
		private var uiLayer: ZView = new ZView();
		private var interactLayer: ZView = new ZView();
		private var tipLayer: ZView = new ZView();
		
		public static var bgViews: Array = [];
		public static var uiViews: Array = [];
		public static var interactViews: Array = [];
		public static var tipViews: Array = [];
		
		public function ZWindow()
		{
			super();
			
			this.name = "ZWindow";
			backgroundLayer.name = "backgroundLayer";
			uiLayer.name = "uiLayer";
			interactLayer.name = "interactLayer";
			tipLayer.name = "tipLayer";
			
			this.addSubView(backgroundLayer);
			this.addSubView(uiLayer);
			this.addSubView(interactLayer);
			this.addSubView(tipLayer);
		}
		
		public static function initWith(screen: DisplayObjectContainer): ZWindow
		{
			if (!_instance)
			{
				_instance = Singleton.getInstance(ZWindow);
			}
			return screen.addChild(_instance) as ZWindow;
		}
		
		public static function get instance():ZWindow
		{
			return _instance;
		}
		
		public function addToBackground(view: DisplayObject): void
		{
			backgroundLayer.addChild(view);
			bgViews.push(view);
		}
		
		public function removeFromBackground(view: DisplayObject): void
		{
			backgroundLayer.removeChild(view);
			var index: int = bgViews.indexOf(view);
			bgViews.splice(index, 1);
		}
		
		public function addToUI(view: DisplayObject): void
		{
			uiLayer.addChild(view);
			uiViews.push(view);
		}
		
		public function removeFromUI(view: DisplayObject): void
		{
			uiLayer.removeChild(view);
			var index: int = uiViews.indexOf(view);
			uiViews.splice(index, 1);
		}
		
		public function addToInteract(view: DisplayObject): void
		{
			interactLayer.addChild(view);
			interactViews.push(view);
		}
		
		public function removeFromInteract(view: DisplayObject): void
		{
			interactLayer.removeChild(view);
			var index: int = interactViews.indexOf(view);
			interactViews.splice(index, 1);
		}
		
		public function addToTip(view: DisplayObject): void
		{
			tipLayer.addChild(view);
			tipViews.push(view);
		}
		
		public function removeFromTip(view: DisplayObject): void
		{
			tipLayer.removeChild(view);
			var index: int = tipViews.indexOf(view);
			tipViews.splice(index, 1);
		}
		
		public function set rootViewController(value: ZViewController):void
		{
			_rootViewController = value;
			this.addToUI(value.view);
		}
	}
}


