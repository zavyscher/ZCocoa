package com.components
{
	import com.core.coreGraphics.CGSize;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**[未优化]<b>使用方法(目前)</b>: 设置skin为null, 设置target(滚动目标), 然后通过contentSize设置/修改显示区域
	 * @author leetn-zavyscher
	 */
	public class ZScrollView extends ZView
	{
		public static const OFF:int = 1;
		public static const AUTO:int = 2;
		public static const ON:int = 3;
		/**可在显示皮肤前设置按钮尺寸*/
		public static var DEFAULT_SKIN_BTN_WIDTH: Number = 32;
		
		private var _contenSize: CGSize;
		private var _mask: Shape;
		private var _target: DisplayObject;
		
		private var _track: ZButton;
		private var _btnUp: BtnUp;
		private var _btnDown: BtnDown;
		private var _indicator: BtnIndicator;
		private var _viewScrollBar: ZView;
		private var _contentView: ZView;
		
		public var lineScrollSize: int = 15;
		public var minIndicatorHeight: int = 10;
		
		private var _mode: int = AUTO;
		private var _scrollPosition: int;
		private var _startDownY: Number;
		private var _startThumbPosition: Number;
		private var _frameCount: int;
		
		public var offsetX:Number = 6;
		public var offsetY:Number = 0;
		
		private var _downTarget: ZButton;
		private var _staticStage: Stage;
		
		public function ZScrollView()
		{
			super();
			this.mouseEnabled = true;
			
			_mask = new Shape();
			_contentView = new ZView();
			_viewScrollBar = new ZView();
			
			this.addSubView(_contentView);
			this.addSubView(_viewScrollBar);
			
			onAddedToStage = didAddedToStage;
			onRemovedFromStage = didRemovedFromStage;
		}
		
		/**
		 * @param value
		 */		
		override public function set skin(value:Object):void
		{
			super.skin = value;
			if (value)
			{
				if (value.hasOwnProperty("btnUp"))
				{
					
				}
				else
				{
					
				}
				if (value.hasOwnProperty("btnDown"))
				{
					
				}
				else
				{
					
				}
			}
			else
			{
				_btnUp = new BtnUp();
				
				_track = new ZButton();
				_track.y = _btnUp.rightBottomPoint.y;
				_track.graphics.beginFill(0x999999, 0.3);
				_track.graphics.drawRect(0, 0, _btnUp.width, _btnUp.height * 10);
				_track.graphics.endFill();
				
				_btnDown = new BtnDown();
				_btnDown.y = _track.rightBottomPoint.y + 0.5;
				
				_indicator = new BtnIndicator();
				_indicator.y = _track.y;
				
				_viewScrollBar.addSubView(_track);
				_viewScrollBar.addSubView(_indicator);
				_viewScrollBar.addSubView(_btnUp);
				_viewScrollBar.addSubView(_btnDown);
			}
		}
		
		private function didAddedToStage(e: Event):void
		{
			_btnUp.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_track.addEventListener(MouseEvent.CLICK, onMouseDownHandler);
			_btnDown.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_indicator.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_indicator.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseRollHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseRollHandler);
			addEventListener(Event.RESIZE, onResize);
			_staticStage = stage;
		}
		
		private function didRemovedFromStage(e: Event):void
		{
			_btnUp.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_track.removeEventListener(MouseEvent.CLICK, onMouseDownHandler);
			_btnDown.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_indicator.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_indicator.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			removeEventListener(Event.RESIZE, onResize);
			updateMask();
		}
		
		private function onMouseRollHandler(e: MouseEvent):void
		{
			return;
			if (e.type == MouseEvent.MOUSE_OVER)
			{
				alpha = 1;
			}
			else if (e.type == MouseEvent.MOUSE_OUT)
			{
				alpha = 0;
			}
		}
		
		private function onMouseDownHandler(e: MouseEvent):void
		{
			_downTarget = e.currentTarget as ZButton;
			switch(e.currentTarget)
			{
				case _btnUp:
					scrollUp();
					_staticStage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
					addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					break;
				
				case _btnDown:
					scrollDown();
					_staticStage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
					addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					break;
				
				case _track:
					scrollTrack();
					break;
				
				case _indicator:
					scrollIndicatorDown(e);
					break;
				
				default:
					break;
			}
			e.stopPropagation();
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
			_frameCount++;
			if(_frameCount % 3 == 0)
			{
				if(_downTarget == _btnDown)
				{
					scrollDown();
				}
				else if(_downTarget == _btnUp)
				{
					scrollUp();
				}
			}
		}
		
		private function updateMask():void
		{
			updateMaskLater();
			setTimeout(updateMaskLater, 80);
		}
		
		private function updateMaskLater():void
		{
			_mask.graphics.clear();
			if(this.parent && _target && _target.parent)
			{
				_target.mask = _mask;
				this.parent.addChild(_mask);
				_mask.x = target.x;//遮罩起始点X
				_mask.y = target.y;//遮罩起始点Y
				_mask.graphics.beginFill(0x000000, 1);
				_mask.graphics.drawRect(0, 0, target.width + offsetX, this.height + offsetY);//目前只支持纵向滚动条
				_mask.graphics.endFill();
			}
			else
			{
				if(_mask.parent)
				{
					_mask.parent.removeChild(_mask);
				}
			}
		}
		
		private function scrollUp():void
		{
			this.scrollPosition = this.scrollPosition - this.lineScrollSize;
		}
		
		private function scrollDown():void
		{
			this.scrollPosition = this.scrollPosition + this.lineScrollSize;
		}
		
		private function scrollTrack():void
		{
			if(mouseY < _indicator.y)
			{
				this.scrollPosition = this.scrollPosition - _indicator.height;
			}
			else if(mouseY > _indicator.y + _indicator.height)
			{
				this.scrollPosition = this.scrollPosition + _indicator.height;
			}
		}
		
		private function scrollIndicatorDown(e: MouseEvent):void
		{
			_staticStage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			_staticStage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			_startThumbPosition = this.scrollPosition;
			_startDownY = e.stageY;
		}
		
		private function onStageMouseMove(e:MouseEvent):void
		{
			this.scrollPosition = _startThumbPosition + (e.stageY - _startDownY);
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			_staticStage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			_staticStage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onMouseWheelHandler(e:MouseEvent):void
		{
			if(mode != OFF)
			{
				this.scrollPosition = scrollPosition - lineScrollSize * e.delta;
			}
		}
		
		private function onResize(e:Event):void
		{
			updateThumb();
			updateMode();
		}
		
		/**
		 * @param size 可视化区域尺寸
		 */		
		public function set contentSize(size: CGSize):void
		{
			_track.height = size.height - 10;
			_btnDown.y = size.height - _btnDown.height;
			setTimeout(updateThumb, 50);
			setTimeout(updateMode, 50);
			updateMask();
		}
		
		private function updateThumb():void
		{
			updatePosition();
		}
		
		private function updateMode():void
		{
			this.visible = true;
			_indicator.visible = true;
			if(mode == OFF)
			{
				this.visible = false;
			}
			else if(mode == ON)
			{
				if(!target || this.height >= target.height)
				{
					_indicator.visible = false;
				}
			}
			else if(mode == AUTO)
			{
				if(!target || this.height >= target.height)
				{
					this.visible = false;
				}
			}
		}
		
		public function set mode(value:int):void
		{
			_mode = value;
			updateMode();
		}
		
		public function get mode():int
		{
			return _mode;
		}
		
		/**建议设置滚动条和目标内容于相同父容器中
		 * @param value 要用滚动条显示的内容
		 */
		public function set target(value:DisplayObject):void
		{
			if(_target != null)
			{
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
				_target.removeEventListener(Event.RESIZE, onResize);
			}
			_target = value;
			_target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			_target.addEventListener(Event.RESIZE, onResize);
			updateMask();
			updateMode();
			updateThumb();
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set scrollPosition(value: int): void
		{
			_scrollPosition = value;
			updatePosition();
		}
		
		public function get scrollPosition(): int
		{
			return _scrollPosition;
		}
		
		private function updatePosition():void
		{
			if(target)
			{
				if(target.height > _btnDown.y + _btnDown.height)
				{
					//可滚动高度
					var scrollHeight:Number = _btnDown.y - _indicator.height - _btnUp.height;
					_scrollPosition = Math.min(Math.max(0, scrollPosition), scrollHeight);
					_indicator.y = Math.min(scrollPosition + _btnUp.height, _btnDown.y - _indicator.height);
					target.y = 0 - scrollPosition / scrollHeight * (target.height + DEFAULT_SKIN_BTN_WIDTH - this.height);
				}
				else
				{
					target.y = 0;
					_indicator.y = _btnUp.height;
				}
			}
		}
		
		override public function addSubView(view:ZView):ZView
		{
			if (view != _viewScrollBar && view != _contentView)
			{
				_contentView.addSubView(view);
			}
			else
			{
				super.addSubView(view);
			}
			return view;
		}
		
		public function rollToUp(): void
		{
			
		}
		
		public function rollToDown(): void
		{
			
		}
		
		public function rollToTop(): void
		{
			
		}
		
		public function rollToBottom(): void
		{
			
		}
		//
	}
}

import com.components.ZButton;
import com.components.ZScrollView;
import com.components.ZView;


class BtnUp extends ZButton
{
	private var arrow: ZView;
	
	public function BtnUp()
	{
		super();
		
		this.graphics.lineStyle(1, 0x999999, 0.3, true);
		this.graphics.beginFill(0xcccccc);
		this.graphics.drawRoundRect(0, 0, ZScrollView.DEFAULT_SKIN_BTN_WIDTH, ZScrollView.DEFAULT_SKIN_BTN_WIDTH, 1);
		this.graphics.endFill();
		
		var edgeGap: Number = ZScrollView.DEFAULT_SKIN_BTN_WIDTH * 0.1;
		arrow = new ZView();
		arrow.graphics.lineStyle(1, 0x999999, 0.8, true);
		arrow.graphics.beginFill(0x000000);
		arrow.graphics.moveTo(ZScrollView.DEFAULT_SKIN_BTN_WIDTH >> 1, edgeGap);
		arrow.graphics.lineTo(edgeGap, ZScrollView.DEFAULT_SKIN_BTN_WIDTH - edgeGap * 2);
		arrow.graphics.lineTo(ZScrollView.DEFAULT_SKIN_BTN_WIDTH - edgeGap, ZScrollView.DEFAULT_SKIN_BTN_WIDTH - edgeGap * 2);
		arrow.graphics.lineTo(ZScrollView.DEFAULT_SKIN_BTN_WIDTH >> 1, edgeGap);
		arrow.graphics.endFill();
		this.addSubView(arrow);
	}
}

class BtnDown extends ZButton
{
	private var arrow: ZView;
	
	public function BtnDown()
	{
		super();
		
		this.graphics.lineStyle(1, 0x999999, 0.3, true);
		this.graphics.beginFill(0xcccccc);
		this.graphics.drawRoundRect(0, 0, ZScrollView.DEFAULT_SKIN_BTN_WIDTH, ZScrollView.DEFAULT_SKIN_BTN_WIDTH, 1);
		this.graphics.endFill();
		
		var edgeGap: Number = ZScrollView.DEFAULT_SKIN_BTN_WIDTH * 0.1;
		arrow = new ZView();
		arrow.graphics.lineStyle(1, 0x999999, 0.8, true);
		arrow.graphics.beginFill(0x000000);
		arrow.graphics.moveTo(ZScrollView.DEFAULT_SKIN_BTN_WIDTH >> 1, ZScrollView.DEFAULT_SKIN_BTN_WIDTH - edgeGap);
		arrow.graphics.lineTo(edgeGap, edgeGap * 2);
		arrow.graphics.lineTo(ZScrollView.DEFAULT_SKIN_BTN_WIDTH - edgeGap, edgeGap * 2);
		arrow.graphics.lineTo(ZScrollView.DEFAULT_SKIN_BTN_WIDTH >> 1, ZScrollView.DEFAULT_SKIN_BTN_WIDTH - edgeGap);
		arrow.graphics.endFill();
		this.addSubView(arrow);
	}
}

class BtnIndicator extends ZButton
{
	public function BtnIndicator()
	{
		super();
		this.graphics.lineStyle(1, 0x999999, 1, true);
		this.graphics.beginFill(0x999999, 0.8);
		this.graphics.drawRoundRect(ZScrollView.DEFAULT_SKIN_BTN_WIDTH / 4, 0, ZScrollView.DEFAULT_SKIN_BTN_WIDTH / 2, ZScrollView.DEFAULT_SKIN_BTN_WIDTH * 3, 3);
		this.graphics.endFill();
	}
	
	override public function set height(value:Number):void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 0x999999, 1, true);
		this.graphics.beginFill(0x999999, 0.8);
		this.graphics.drawRoundRect(ZScrollView.DEFAULT_SKIN_BTN_WIDTH / 4, 0, ZScrollView.DEFAULT_SKIN_BTN_WIDTH / 2, value, 3);
		this.graphics.endFill();
		super.height = value;
	}
}


