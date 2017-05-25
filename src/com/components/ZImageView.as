package com.components
{
	import com.core.coreGraphics.CGPoint;
	import com.core.coreGraphics.CGRect;
	import com.core.coreGraphics.CGSize;
	import com.core.coreGraphics.ZImage;
	import com.core.manager.ResourceManager;
	import com.core.utils.Methods;
	import com.core.utils.TimerUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**未扩展九宫格缩放
	 * @author leetn-zavyscher
	 */	
	public class ZImageView extends ZView
	{
		protected var _originW: Number;
		protected var _originH: Number;
		
		protected var _resUrl: String;
		
		private var _img: Bitmap = new Bitmap();
		/**加载时记录本体用*/
		private var _self:ZImageView;
		
		private var _isLoading: Boolean;
		
		public function ZImageView()
		{
			super();
			this.addChild(_img);
			_originW = 0;
			_originH = 0;
		}
		
		public function set image(value: ZImage):void
		{
			_img.bitmapData = value;
		}
		
		public function get image(): ZImage
		{
			return _img.bitmapData as ZImage;
		}
		
		public function get bitmap(): Bitmap
		{
			return _img;
		}
		
		public function set smoothing(value: Boolean):void
		{
			_img.smoothing = value;
		}
		
		public function get smoothing(): Boolean
		{
			return _img.smoothing;
		}
		
		/**
		 * @param url 图片路径
		 * @param completion 加载完成回调(自身)
		 */		
		public function loadWith(url: String, completion: Function): void
		{
			_self = this;
			_resUrl = url;
			_isLoading = true;
			ResourceManager.getBitmap(_img, url,
				function(): void
				{
					_isLoading = false;
					_img.smoothing = true;
					_originW = _img.width;
					_originH = _img.height;
					_self.width = _img.width;
					_self.height = _img.height;
					if (completion is Function)
					{
						completion(_self);
					}
				}
			);
		}
		/**
		 * @param url
		 * @param completion 加载完成后回调
		 * @param progressing 加载过程中(未定触发节点)
		 * @param min 透明度缓动动画，透明度值默认-1，使用默认值时不会产生任何透明度缓动动画
		 * @param max 透明度缓动动画，透明度值默认1，如果max比min值小，则不会产生任何缓动动画
		 * @param interval 默认-1
		 */		
		public function loadedWithAlpha(url: String, completion: Function, min: Number = -1, max: Number = 1, interval: Number = -1, progressing: Function = null):void
		{
			_self = this;
			_resUrl = url;
			_isLoading = true;
			ResourceManager.getBitmap(_img, url,
				function(): void
				{
					_isLoading = false;
					_img.smoothing = true;
					_originW = _img.width;
					_originH = _img.height;
					_self.width = _img.width;
					_self.height = _img.height;
					if (min < 0 || min >= max)
					{
						if (progressing is Function)
						{
							progressing(_self);
						}
						if (completion is Function)
						{
							completion(_self);
						}
					}
					else
					{
						if (progressing is Function)
						{
							progressing(_self);
						}
						
						var func: Function = function (now: int): void
						{
							_self.alpha += (interval < 0) ? _self.alpha * 0.5 : interval;
							if (_self.alpha >= max)
							{
								_self.alpha = max;
								TimerUtil.remove(func);
								if (completion is Function)
								{
									completion(_self);
								}
							}
						};
						_self.alpha = min;
						TimerUtil.add(func);
					}
				}
			);
		}
		
		/**设置图片位置及限制尺寸
		 * @param maxSize 限制尺寸（最大尺寸）
		 * @param originPos 输入当前原点坐标
		 * @param minSize 最小尺寸
		 */
		public function setMaxRectWith(maxSize: CGSize, originPos: CGPoint, minSize: CGSize = null):void
		{
			var rect: CGRect = Methods.getScaleRect(maxSize, new CGSize(this.width, this.height), true);
			this.width = rect.size.width;
			this.height = rect.size.height;
			if (originPos)
			{
				this.x = originPos.x + rect.origin.x;
				this.y = originPos.y + rect.origin.y;
			}
			
			if (minSize)
			{
//				if (this.width < minSize.width || this.height < minSize.height)
//				{
//					var minRect: CGRect = Methods.getMaxSize(new CGSize(minSize.width, minSize.height), new CGSize(this.width, this.height));
//					this.width = minRect.size.width;
//					this.height = minRect.size.height;
//				}
			}
		}
		
		public function get originW():Number
		{
			return _originW;
		}
		
		public function get originH():Number
		{
			return _originH;
		}
		
		override public function set width(value:Number):void
		{
			_img.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_img.height = value;
		}
		
		public static function makeWithImage(imageData: ZImage): ZImageView
		{
			var imgResult: ZImageView = new ZImageView();
			imgResult.bitmap.bitmapData = imageData as BitmapData;
			return imgResult;
		}
		
		public function get resUrl():String
		{
			return _resUrl;
		}
		
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		//
	}
}


