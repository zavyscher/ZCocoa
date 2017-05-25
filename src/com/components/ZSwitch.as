package com.components
{
	import com.core.coreGraphics.CGRect;
	import com.core.manager.ResourceManager;
	import com.core.utils.TimerUtil;
	
	import flash.events.MouseEvent;

	public class ZSwitch extends ZButton
	{
		private var _icon: ZImageView;
		private var _bgOn: ZImageView;
		private var _bgOff: ZImageView;
		
		private var _isOn: Boolean;
		private var _isRun: Boolean;
		
		public var switchAction: Function;
		
		public function ZSwitch()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
			this.addEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		private function onClickHandler(e: MouseEvent):void
		{
			if (switchAction is Function)
			{
				switchAction(e);
			}
		}
		
		public function get isOn(): Boolean
		{
			return _isOn;
		}
		
		public function set icon(value: ZImageView): void
		{
			if (value)
			{
				this.insertView(value, this.numChildren);
				value.x = 0;
			}
			else
			{
				_icon.removeFromSuperView();
			}
			_icon = value;
		}
		
		public function get icon(): ZImageView
		{
			return _icon;
		}
		
		public function set skinOn(value: ZImageView): void
		{
			if (value)
			{
				if (_icon && this.contains(_icon))
				{
					var index: int = this.getChildIndex(_icon);
				}
				this.insertView(value, index);
			}
			else
			{
				_bgOn.removeFromSuperView();
			}
			_bgOn = value;
		}
		
		public function get skinOn(): ZImageView
		{
			return _bgOn;
		}
		
		public function set skinOff(value: ZImageView): void
		{
			if (value)
			{
				if (_icon && this.contains(_icon))
				{
					var index: int = this.getChildIndex(_icon);
				}
				this.insertView(value, index);
			}
			else
			{
				_bgOff.removeFromSuperView();
			}
			_bgOff = value;
		}
		
		public function get skinOff(): ZImageView
		{
			return _bgOff;
		}
		
		public function set on(value: Boolean): void
		{
			if (!_icon)
				return;
			
			if (_isRun)
				return;
			
			_isOn = value;
			_isRun = true;
			if (value)
			{
				TimerUtil.add(runToOn);
			}
			else
			{
				TimerUtil.add(runToOff);
			}
		}
		
		private function runToOn(now: int, param: Object = null): void
		{
			if (_bgOn)
			{
				_bgOn.visible = true;
				_icon.x += _icon.x * 1.1 + 0.05;
				if (_icon.x >= _bgOn.width - _icon.width)
				{
					_icon.x = _bgOn.width - _icon.width;
					if (_bgOff)
						_bgOff.visible = false;
					_isRun = false;
					TimerUtil.remove(arguments.callee);
				}
			}
			else
			{
				_isRun = false;
				TimerUtil.remove(arguments.callee);
			}
		}
		
		private function runToOff(now: int, param: Object = null): void
		{
			if (_bgOff)
			{
				_bgOff.visible = true;
				_icon.x -= _icon.x * 0.5;
				if (_icon.x <= _bgOff.x)
				{
					_icon.x = _bgOff.x;
					_isRun = false;
					if (_bgOn)
						_bgOn.visible = false;
					TimerUtil.remove(arguments.callee);
				}
			}
			else
			{
				_isRun = false;
				TimerUtil.remove(arguments.callee);
			}
		}
		
		/**一键初始化各皮肤部分
		 * @param iconURL (不变)图标URL
		 * @param skinOnURL 开启状态URL
		 * @param skinOffURL 关闭状态URL
		 * @param rect 设置整个组件的frame
		 * @param completion 开启状态的皮肤加载成功的回调
		 */		
		public function initSkins(iconURL: String, skinOnURL: String, skinOffURL: String, rect: CGRect = null, completion: Function = null): void
		{
			this.mouseChildren = this.mouseEnabled = true;
			
			icon = new ZImageView();
			
			var initOnOff: Function = function (): void
			{
				ResourceManager.getBitmap(skinOn.bitmap, skinOnURL,
					function():void
					{
						skinOn.smoothing = true;
						frame = rect;
						on = true;
						if (completion is Function)
						{
							completion();
						}
					}
				);
				skinOff = new ZImageView();
				ResourceManager.getBitmap(skinOff.bitmap, skinOffURL,
					function():void
					{
						skinOff.smoothing = true;
					}
				);
			};
			if (!iconURL)
			{
				//空icon处理
				initOnOff();
				return ;
			}
				
			ResourceManager.getBitmap(icon.bitmap, iconURL,
				function():void
				{
					icon.smoothing = true;
					skinOn = new ZImageView();
					initOnOff();
				}
			);
		}
		//
	}
}


