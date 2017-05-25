package com.core.utils
{
	import com.core.coreGraphics.CGRect;
	import com.core.coreGraphics.CGSize;
	import com.core.manager.StageManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class Methods
	{
		/**公式: limitedA / originA * targetB
		 * @param limitedA A的限制值(最大值)
		 * @param originA A的原始值
		 * @param originB B的最大值(和A的缩放比例值相同)
		 * @return
		 */
		public static function getScaleValue(limitedA: Number, originA: Number, originB: Number): Number
		{
			return limitedA / originA * originB;
		}
		
		/**根据传入的尺寸获取现屏幕中的尺寸, 可传单个参数maxW对应Width, maxH对应Height
		 * @param maxW
		 * @param maxH
		 * @return 
		 */		
		public static function getSizeWithStageScale(maxW: Number, maxH: Number): CGSize
		{
			var scaleW: Number = getScaleValue(maxW, StageManager.MAX_SIZE.width, StageManager.width);
			var scaleH: Number = getScaleValue(maxH, StageManager.MAX_SIZE.height, StageManager.height);
			return new CGSize(scaleW, scaleH);
		}
		
		/**目前只适应比限制范围大的处理
		 * @param limitedSize 限制尺寸
		 * @param originSize 原始尺寸
		 * @param isFixed 是否固定尺寸
		 * @return 
		 */		
		public static function getScaleRect(limitedSize: CGSize, originSize: CGSize, isFixed: Boolean = false): CGRect
		{
			var targetW: Number = limitedSize.width;
			var targetH: Number = limitedSize.height;
			var targetX: Number = 0;
			var targetY: Number = 0;
			var zoomScale: Number = 0;
			if (originSize.width < limitedSize.width && originSize.height < limitedSize.height)//原始尺寸比限制尺寸要小
			{
				if (isFixed)
				{
					var temRect: CGRect = getMaxSize(limitedSize, originSize);
					targetW = temRect.size.width;
					targetH = temRect.size.height;
				}
				else
				{
					targetW = originSize.width;
					targetH = originSize.height;
				}
			}
			else//图片宽和高都比限制范围要大
			{
				if (originSize.width > originSize.height)//图片宽比图片高大
				{
					targetH = getScaleValue(limitedSize.width, originSize.width, originSize.height);
					if (targetH > limitedSize.height)
					{
						targetW = getScaleValue(limitedSize.height, targetH, targetW);
						targetH = limitedSize.height;
					}
				}
				else
				{
					targetW = getScaleValue(limitedSize.height, originSize.height, originSize.width);
					if (targetW > limitedSize.width)
					{
						targetH = getScaleValue(limitedSize.width, targetW, targetH);
						targetW = limitedSize.width;
					}
				}
			}
			
			targetX = (limitedSize.width - targetW) >> 1;
			targetY = (limitedSize.height - targetH) >> 1;
			return new CGRect(targetX, targetY, targetW, targetH);
		}
		
		/**计算图片在限制范围内最大缩放比例
		 * @param limitedSize 限制尺寸
		 * @param originSize 原始尺寸
		 * @return 
		 */		
		public static function getMaxSize(limitedSize: CGSize, originSize: CGSize): CGRect
		{
			var targetW: Number = limitedSize.width;
			var targetH: Number = limitedSize.height;
			var targetX: Number = 0;
			var targetY: Number = 0;
			var zoomScale: Number = 0;
			if (originSize.width < limitedSize.width && originSize.height < limitedSize.height)//原始尺寸比限制尺寸要小
			{
				if (originSize.width > originSize.height)//图片宽比图片高大
				{
					zoomScale = originSize.width / limitedSize.width;//先计算原始宽(当前尺寸)占目标尺寸的宽的百分比
					targetH = originSize.height + (limitedSize.height * (1 - zoomScale));//后计算出原始高(当前尺寸)需要增加的数值
				}
				else
				{
					zoomScale = originSize.height / limitedSize.height;//先计算原始高(当前尺寸)占目标尺寸的高的百分比
					targetW = originSize.width + (limitedSize.width * (1 - zoomScale));//后计算出原始宽(当前尺寸)需要增加的数值
				}
			}
			targetX = (limitedSize.width - targetW) >> 1;
			targetY = (limitedSize.height - targetH) >> 1;
			return new CGRect(targetX, targetY, targetW, targetH);
		}
		
		public static function getBitmapDataWithCopy(bmd: BitmapData, isSelf: Boolean = true): BitmapData
		{
			if (bmd)
				return null;
			
			var rect: Rectangle = bmd.getColorBoundsRect(0xff000000, 0x00000000, false);
			if (isSelf)
			{
				bmd.copyPixels(bmd, rect, new Point());
				return bmd;
			}
			else
			{
				var newBmd: BitmapData = new BitmapData(bmd.width, bmd.height);//未测试过
				newBmd.copyPixels(bmd, rect, new Point());
				return newBmd;
			}
		}
		
		public static function getBitmapDataWithDraw(target: BitmapData, source: IBitmapDrawable, rect: Rectangle, point: Point, colorTransform: ColorTransform = null, scale: Number = 1):void
		{
			var clipRect: Rectangle = new Rectangle();
			clipRect.x = point.x;
			clipRect.y = point.y;
			clipRect.width = rect.width * scale;
			clipRect.height = rect.height * scale;
			var matrix: Matrix = new Matrix();
			matrix.tx = point.x - rect.x;
			matrix.ty = point.y - rect.y;
			matrix.a = matrix.d = scale;
			target.draw(source, matrix, colorTransform, null, clipRect, false);
		}
		
		/**结构:[闪烁对象, 是否透明, 计时器方法]*/
		private static var flickDic: Dictionary = new Dictionary();
		public static function addFlickerTarget(target: DisplayObject, flag: String, alphaMin: Number = 0.15, alphaMax: Number = 1.2): void
		{
			if (flickDic[flag] == undefined || flickDic[flag] == null)
			{
				flickDic[flag] = [target, false];
			}
			
			var toShow: Function = function (now: int, param: Object = null): void
			{
				flickDic[flag][0].alpha += 0.035;
				flickDic[flag][2] = toShow;
				if (flickDic[flag][0].alpha >= alphaMax)
				{
					flickDic[flag][1] = false;
					TimerUtil.remove(arguments.callee);
					addFlickerTarget(flickDic[flag][0], flag);
				}
			};
			var toHide: Function = function (now: int, param: Object = null): void
			{
				if (flickDic[flag] == undefined)
				{
					TimerUtil.remove(toHide);
					return;
				}
				if(flickDic[flag][1] == true)
					return;
				
				flickDic[flag][0].alpha -= 0.05;
				flickDic[flag][2] = toHide;
				if (flickDic[flag][0].alpha <= alphaMin)
				{
					flickDic[flag][1] = true;
					TimerUtil.remove(arguments.callee);
					TimerUtil.add(toShow);
				}
			};
			
			TimerUtil.add(toHide, 70);
		}
		
		public static function removeFlickerTarget(flag: String): void
		{
			if (flickDic[flag])
			{
				TimerUtil.remove(flickDic[flag][2]);
				flickDic[flag][0].alpha = 1;
				delete flickDic[flag];
			}
		}
		
		private static var repeatTimer: uint;
		private static var dicSaver: Dictionary = new Dictionary();
		
		/**定时一定时间后执行方法
		 * @param func
		 * @param delay 默认5分钟
		 */		
		public static function repeatFuncTimer(func: Function, key: String, delay: Number = 5 * 60 * 1000): void
		{
			if (dicSaver[key])
			{
				TimerUtil.remove(dicSaver[key]);
			}
			
			repeatTimer = getTimer();
			var callback: Function = function (now: int, param: Object = null): void{
				if (now - repeatTimer > delay)
				{
					if (func is Function)
					{
						func();
					}
					TimerUtil.remove(callback);
					dicSaver[key] = null;
					delete dicSaver[key];
				}
			}
			dicSaver[key] = callback;
			TimerUtil.add(callback);
		}
		
		public static function copy(value: Object):Object
		{
			var buffer: ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result: Object = buffer.readObject();
			return result;
		}
		
		/**清除子视图
		 * @param parantView
		 * @param exceptViews 多个子视图除外
		 */		
		public static function clearSubviews(parentView: DisplayObjectContainer, canDispose: Boolean = true, exceptViews: Array = null): void
		{
			var len: int = exceptViews ? exceptViews.length : 0;
			var temLen: int = len;
			var sub: DisplayObject;
			if (len <= 0)
			{
				while (parentView.numChildren > 0)
				{
					sub = parentView.getChildAt(0);
					parentView.removeChild(sub);
					if (canDispose) sub = null ;
				}
			}
			else
			{
				var startIndex: int = 0;
				var len2: int = parentView.numChildren;
				mainLoop : for (var j: int = 0; j < len2; j++)
				{
					sub = parentView.getChildAt(startIndex);
					subLoop : for (var i: int = 0; i < len; i++)
					{
						var temView: DisplayObject = exceptViews[i];
						if (temView.parent == parentView && temView == sub)//必须是该父容器下的子视图
						{
							startIndex = j + 1;
							continue mainLoop;
						}
					}
					parentView.removeChild(sub);
					if (canDispose) sub = null ;
				}
			}
		}
		
		public static function randomArr(arr: Array):Array
		{
			if (!arr) return null ;
			
			var outputArr: Array = arr.slice();
			var i: int = outputArr.length;
			var temp: *;
			var indexA: int;
			var indexB: int;
			
			while (i)
			{
				indexA = i - 1;
				indexB = Math.floor(Math.random() * i);
				i--;
				
				if (indexA == indexB) continue;
				temp = outputArr[indexA];
				outputArr[indexA] = outputArr[indexB];
				outputArr[indexB] = temp;
			}
			
			return outputArr;
		}
		//
	}
}


