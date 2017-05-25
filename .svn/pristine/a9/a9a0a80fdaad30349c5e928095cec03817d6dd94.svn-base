package com.components.custom.views
{
	import com.components.ZImageView;
	import com.components.ZView;
	import com.core.coreGraphics.CGPoint;
	import com.core.coreGraphics.CGRect;
	import com.core.manager.ResourceManager;
	import com.core.manager.StageManager;
	import com.core.utils.TimerUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**鸟瞰图(构成: 主图AirscapeOrigin, 副图(缩略图)AirscapeThumbnail, 摄像头AirscapeCamera)<br>
	 * 可通过构造函数定义新皮肤. 注: 未实现手势缩放
	 * @author leetn-zavyscher
	 */
	public class AirscapeThumbnail extends ZView
	{
		/**自定义事件名(可自行修改)*/
		public static var NAME: String = "AirscapeThumbnail";
		
		public var originWidth: Number;
		public var originHeight: Number;
		
		private var _imgMain: ZImageView;
		private var _viewCamera: AirscapeCamera;
		private var _viewInteration: ZView;
		private var _currDrag: ZView;
		
		private var _isAnimating: Boolean;
		/**{name : NAME, point : [scaleX, scaleY]}*/
		public var callback: Function;
		
		public function AirscapeThumbnail()
		{
			super();
			
			originWidth = 0;
			originHeight = 0;
			
			_viewInteration = new ZView();
			this.addSubView(_viewInteration);
			
			_imgMain = new ZImageView();
			_imgMain.mouseEnabled = true;
			_viewInteration.addSubView(_imgMain);
			
			this.alpha = 0.5;
		}
		
		public function setOriginSize(sizeW: Number, sizeH: Number): void
		{
			originWidth = sizeW;
			originHeight = sizeH;
		}
		
		private function onStartDragHandler(e: MouseEvent):void
		{
			_currDrag = e.currentTarget as ZView;
			_currDrag.startDrag();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragUpHandler);
			e.updateAfterEvent();
		}
		
		private function onEnterFrameHandler(e: Event):void
		{
			if (_currDrag.x <= -1)
			{
				_currDrag.x = 0;
			}
			else if (_currDrag.x >= _imgMain.width - _currDrag.width - 1)
			{
				_currDrag.x = _imgMain.width - _currDrag.width - 2;
			}
			
			if (_currDrag.y <= -1)
			{
				_currDrag.y = 0;
			}
			else if (_currDrag.y >= _imgMain.height - _currDrag.height - 1)
			{
				_currDrag.y = _imgMain.height - _currDrag.height - 2;
			}
			
			if (callback is Function)
			{
				var param: Object = new Object();
				param.name = NAME;
				var scaleX: Number = _currDrag.x / (_imgMain.width);
				var scaleY: Number = _currDrag.y / (_imgMain.height);
				param.point = [scaleX, scaleY];
				callback(param);
			}
		}
		
		private function onDragUpHandler(e: MouseEvent):void
		{
			if (_currDrag)
				_currDrag.stopDrag();
			
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragUpHandler);
		}
		
		public function set smallMapUrl(value: String): void
		{
			_isAnimating = true;
			_imgMain.alpha = 0;
			ResourceManager.getBitmap(_imgMain.bitmap, value,
				function():void
				{
					_imgMain.smoothing = true;
					var initDraw: Function = function(now: int, param: Object = null): void
					{
						var scaleA: Number = _imgMain.width / originWidth;
						var scaleB: Number = _imgMain.height / originHeight;
						var w: Number = StageManager.width * scaleA;
						var h: Number = StageManager.height * scaleB;
						if (!_viewCamera)
						{
							_viewCamera = new AirscapeCamera();
							_viewCamera.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragHandler);
							_viewInteration.addSubView(_viewCamera);
						}
						_viewCamera.drawRectWithColor(0x12B7F5, new CGRect(0, 0, w, h));
						TimerUtil.remove(initDraw);
					};
					TimerUtil.add(initDraw, 1000);
					var func: Function = function (now: int, param: Object = null): void
					{
						_imgMain.alpha += 0.15;
						if (_imgMain.alpha >= 1)
						{
							_isAnimating = false;
							_imgMain.alpha = 1;
							TimerUtil.remove(func);
						}
					};
					TimerUtil.add(func);
				}
			);
		}
		
		public function set point(value: CGPoint): void
		{
			//(大图)当前位置的对等比例 * 当前(小图)图片尺寸
			_viewCamera.x = value.x * (_imgMain.width);
			_viewCamera.y = value.y * (_imgMain.height);
		}
		//
	}
}


