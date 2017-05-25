package com.components
{
	import com.components.controller.ZViewController;
	import com.core.coreGraphics.CGPoint;
	import com.core.coreGraphics.CGRect;
	import com.core.coreGraphics.CGSize;
	import com.core.utils.Methods;
	import com.interfaces.ISkin;
	import com.interfaces.IView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**除了根容器外, 其他显示可交互对象都继承于UIView
	 *@author xzm
	 */
	public class ZView extends Sprite implements IView, ISkin
	{
		public var tag: int;
		/**所有ZView类型对象都会保存在此数组中*/
		public var subviews: Array = [];
		
		public var onAddedToStage: Function;
		//		public var onAdded: Function;
		//		public var onRemoved: Function;
		public var onRemovedFromStage: Function;
		
		private var _parentController: ZViewController;
		private var _frame: CGRect;
		private var _offset: CGPoint = new CGPoint();
		private var _skin: Object;

		/**默认情况下不支持鼠标事件
		 */		
		public function ZView()
		{
			//			this.visible = false;
			this.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE, didAddToStage);
			//由于as的事件机制和内存引用的问题, 不能随便用事件监听, 且目前还没需要这么具体的流程
			//			this.addEventListener(Event.ADDED, didAdded);
			//			this.addEventListener(Event.REMOVED, didRemoved);
			this.addEventListener(Event.REMOVED_FROM_STAGE, didRemoveFromStage);
		}
		
		private function didAddToStage(e: Event): void
		{
			this.layoutSubviews();
			if (onAddedToStage is Function)
			{
				onAddedToStage(e);
			}
		}
		
		private function didRemoveFromStage(e: Event):void
		{
			if (onRemovedFromStage is Function)
			{
				onRemovedFromStage(e);
			}
		}
		
		public function get frame():CGRect
		{
			if (!_frame)
			{
				_frame = new CGRect(this.x, this.y, this.width, this.height);
			}
			return _frame;
		}
		
		public function set frame(value:CGRect): void
		{
			_frame = value;
			this.x = value.origin.x;
			this.y = value.origin.y;
			this.width = value.size.width;
			this.height = value.size.height;
			//			this.visible = true;
		}
		
		/**偏移量
		 * @param point 正数为向下降, 负数为向上升
		 */		
		public function set offset(point: CGPoint): void
		{
			_offset = point ? point : new CGPoint();
			
			this.x += point.x;
			this.y += point.y;
		}
		
		public function get offset(): CGPoint
		{
			return _offset;
		}
		
		public function set skin(value:Object): void
		{
			_skin = value;
		}
		
		public function get skin():Object
		{
			return _skin;
		}
		
		public function addSubView(view: ZView):ZView
		{
			this.subviews.push(view);
			this.addChild(view);
			return view;
		}
		
		public function insertView(view: ZView, atIndex: int):ZView
		{
			this.subviews.push(atIndex, 0, view);
			this.addChildAt(view, atIndex);
			return view;
		}
		
		public function removeSubView(view: ZView):ZView
		{
			var childIndex:int = getChildIndex(view);
			this.subviews.splice(childIndex, 1);
			this.removeChild(view);
			return view;
		}
		
		public function removeFromSuperView():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function get parentController():ZViewController
		{
			return _parentController;
		}
		
		public function set parentController(value:ZViewController):void
		{
			if(_parentController)
				return;
			_parentController = value;
		}
		
		public function layoutSubviews():void
		{
		}
		
		public function drawRectWithColor(color: uint, rect: CGRect, alpha:Number = 1): void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, alpha);
			this.graphics.drawRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
			this.graphics.endFill();
		}
		
		public function set backgroundColor(color: uint):void
		{
			this.drawRectWithColor(color, new CGRect(0, 0, this.width, this.height));
		}
		
		/**
		 * @return 显示矩形的右边和底部
		 */
		public function get rightBottomPoint(): CGPoint
		{
			var rightX: Number = this.x + this.width;
			var bottomY: Number = this.y + this.height;
			return new CGPoint(rightX, bottomY);
		}
		
		public function get halfWidth(): Number
		{
			return (this.width >> 1);
		}
		
		public function get halfHeight(): Number
		{
			return (this.height >> 1);
		}
		
		public function setCenterWithSize(size: CGSize): void
		{
			this.x = (size.width >> 1) - halfWidth;
			this.y = (size.height >> 1) - halfHeight;
		}
		
		public function cleanBackgroundColor():void
		{
			this.graphics.clear();
		}
		
		public function deinit():void
		{
		}
		
		public function clearSubviews(canDispose: Boolean = true, ...exceptViews): void
		{
			Methods.clearSubviews(this, canDispose, exceptViews);
			this.subviews = [];
		}
		//
	}
}


