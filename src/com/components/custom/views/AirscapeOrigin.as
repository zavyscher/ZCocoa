package com.components.custom.views
{
	import com.components.ZImageView;
	import com.components.ZView;
	import com.core.coreGraphics.CGPoint;
	import com.core.coreGraphics.CGSize;
	import com.core.event.IParamDispatcher;
	import com.core.event.ParamEvent;
	import com.core.manager.ResourceManager;
	import com.core.manager.StageManager;
	import com.core.utils.TimerUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**鸟瞰图(构成: 主图AirscapeOrigin, 副图(缩略图)AirscapeThumbnail, 摄像头AirscapeCamera)<br>
	 * 可通过构造函数定义新皮肤. 注: 未实现手势缩放
	 * @author leetn-zavyscher
	 */
	public class AirscapeOrigin extends ZView
	{
		public static const NAME: String = "ViewOriginMap";
		/**0: 缩小;*/
		public static const ZOOM_OUT: int = 0;
		/**1: 放大;*/
		public static const ZOOM_IN: int = 1;
		
		private var _zoomScale: Number = 0;
		/**将要改变为的宽度*/
		private var _targetW: Number;
		/**将要改变为的高度*/
		private var _targetH: Number;
		/**0: 缩小; 1: 放大;*/
		private var _zoomType: int;
		
		private var _viewDrag: ZView;
		private var _imgMain: ZImageView;
		
		private var _isInit: Boolean = true;
		private var _isLoading: Boolean;
		private var _isZoom: Boolean;
		/**{name : NAME, point : [scaleX, scaleY]}*/
		public var callback: Function;
		public var completion: Function;
		public var dispatcher: IParamDispatcher;
		
		public function AirscapeOrigin()
		{
			super();
			
			_viewDrag = new ZView();
			_viewDrag.mouseChildren = false;
			_viewDrag.mouseEnabled = true;
			_viewDrag.doubleClickEnabled = true;
			_viewDrag.addEventListener(MouseEvent.DOUBLE_CLICK, onZoomHandler);
			this.addChild(_viewDrag);
			
			_imgMain = new ZImageView();
			_viewDrag.addSubView(_imgMain);
		}
		
		private function onZoomHandler(e: MouseEvent):void
		{
			if (_isLoading)
				return ;
			
			if (_isZoom)
			{
				_viewDrag.removeEventListener(MouseEvent.MOUSE_DOWN, onStartDragHandler);
			}
			else
			{
				_viewDrag.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragHandler);
			}
			willChangeScale();
			
			var param: Object = new Object();
			param.isZoom = _isZoom;
			if (dispatcher)
				dispatcher.dispatchEvent(new ParamEvent(ParamEvent.PARAM, param));
		}
		
		private function onStartDragHandler(e: MouseEvent):void
		{
			if (_isLoading)
				return ;
			
			_viewDrag.startDrag();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragUpHandler);
			e.updateAfterEvent();
		}
		
		private function onEnterFrameHandler(e: Event):void
		{
			if (_viewDrag.x >= _imgMain.halfWidth - 1)
			{
				_viewDrag.x = _imgMain.halfWidth;
			}
			else if (_viewDrag.x <= -(_imgMain.halfWidth - StageManager.width) - 1)
			{
				_viewDrag.x = -(_imgMain.halfWidth - StageManager.width);
			}
			
			if (_viewDrag.y >= _imgMain.halfHeight - 1)
			{
				_viewDrag.y = _imgMain.halfHeight;
			}
			else if (_viewDrag.y <= -(_imgMain.halfHeight - StageManager.height) - 1)
			{
				_viewDrag.y = -(_imgMain.halfHeight - StageManager.height);
			}
			
			if (callback is Function)
			{
				var param: Object = new Object();
				param.name = NAME;
				//因为图片注册点处于中心所以需要减去(大图)图片的一半
				var temScaleX: Number = Math.abs(_viewDrag.x - _imgMain.halfWidth) / _imgMain.width;
				var temScaleY: Number = Math.abs(_viewDrag.y - _imgMain.halfHeight) / _imgMain.height;
				param.point = [temScaleX, temScaleY];
				callback(param);
			}
		}
		
		private function onDragUpHandler(e: MouseEvent):void
		{
			_viewDrag.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragUpHandler);
		}
		
		public function set originMapUrl(value: String): void
		{
			_isLoading = true;
			_imgMain.alpha = 0;
			ResourceManager.getBitmap(_imgMain.bitmap, value,
				function():void
				{
					_imgMain.smoothing = true;
					if (completion is Function)
					{
						completion();
					}
					var func: Function = function (now: int, param: Object = null): void
					{
						_imgMain.alpha += 0.15;
						if (_imgMain.alpha >= 1)
						{
							_imgMain.alpha = 1;
							_isLoading = false;
							willChangeScale();
							TimerUtil.remove(func);
						}
					};
					TimerUtil.add(func);
				}
			);
		}
		
		private function willChangeScale():void
		{
			_isZoom = false;
			_zoomType = 0;
			_viewDrag.x = _targetW * 0.5 + (StageManager.halfWidth - _targetW * 0.5);
			_viewDrag.y = _targetH * 0.5 + (StageManager.halfHeight - _targetH * 0.5);
			if (_imgMain.width > _imgMain.height && _imgMain.width > StageManager.width)
			{
				_zoomScale = StageManager.width / _imgMain.width;
				_targetW = StageManager.width;
				_targetH = _imgMain.height * _zoomScale;
			}
			else if (_imgMain.width < _imgMain.height && _imgMain.height > StageManager.height)
			{
				_zoomScale = StageManager.height / _imgMain.height;
				_targetW = _imgMain.width * _zoomScale;
				_targetH = StageManager.height;
			}
			else if (_zoomScale != 0)
			{
				_targetW = _imgMain.width / _zoomScale;
				_targetH = _imgMain.height / _zoomScale;
				_isZoom = true;
				_zoomType = 1;
				_imgMain.x = -_imgMain.halfWidth;
				_imgMain.y = -_imgMain.halfHeight;
			}
			
			if (_isInit)
			{
				_imgMain.width = _targetW;
				_imgMain.height = _targetH;
				_imgMain.x = -_imgMain.halfWidth;
				_imgMain.y = -_imgMain.halfHeight;
				_viewDrag.x = _imgMain.halfWidth + (StageManager.halfWidth - _imgMain.halfWidth);
				_viewDrag.y = _imgMain.halfHeight + (StageManager.halfHeight - _imgMain.halfHeight);
				_isInit = false;
				return ;
			}
			
			_isLoading = true;
			TimerUtil.add(toZoom);
		}
		
		private function toZoom(now: int, param: Object = null):void
		{
			if (_zoomType == 1)
			{
				_imgMain.width += _imgMain.width * 0.15;
				_imgMain.height += _imgMain.height * 0.2;
				_imgMain.x = -_imgMain.width >> 1;
				_imgMain.y = -_imgMain.height >> 1;
				if (_imgMain.width > _targetW || _imgMain.height > _targetH)
				{
					_imgMain.width = _targetW;
					_imgMain.height = _targetH;
					_imgMain.x = -_imgMain.width >> 1;
					_imgMain.y = -_imgMain.height >> 1;
					TimerUtil.remove(toZoom);
					_isLoading = false;
				}
			}
			else
			{
				_imgMain.width -= _imgMain.width * 0.15;
				_imgMain.height -= _imgMain.height * 0.2;
				_imgMain.x = -_imgMain.width >> 1;
				_imgMain.y = -_imgMain.height >> 1;
				if (_imgMain.width < _targetW || _imgMain.height < _targetH)
				{
					_imgMain.width = _targetW;
					_imgMain.height = _targetH;
					_imgMain.x = -_imgMain.width >> 1;
					_imgMain.y = -_imgMain.height >> 1;
					TimerUtil.remove(toZoom);
					_isLoading = false;
				}
			}
		}
		
		public function set point(value: CGPoint): void
		{
			_viewDrag.x = -value.x * (_imgMain.width) + _imgMain.halfWidth;
			_viewDrag.y = -value.y * (_imgMain.height) + _imgMain.halfHeight;
		}
		
		public function get size(): CGSize
		{
			return new CGSize(_imgMain.width, _imgMain.height);
		}
		//
	}
}


