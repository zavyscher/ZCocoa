package com.core.manager
{
	
	import com.core.resourse.ZLoader;
	import com.core.utils.TimerUtil;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class ResourceManager
	{
		private static var _referenceDic:Dictionary = new Dictionary();
		private static var _resUrlDic:Dictionary = new Dictionary();
		private static var _imageUrlDic:Dictionary = new Dictionary();
		private static var _recycleImageUrlDic:Dictionary = new Dictionary();
		
		public static const RECYCLE_INTERVAL:int = 2 * 60 * 1000;
		public static const RECYCLE_TIME_SPAN:int = 3 * 60 * 1000;
		
		initialize();
		
		private static function initialize():void
		{
			TimerUtil.add(recycleResource, RECYCLE_INTERVAL);
		}
		
		private static function recycleResource(now:int, param: Object = null):void
		{
			dispose();
		}
		
		public static function getResource(url:String, action:String, way:int, rate:Number, priority:int = 10):Object
		{
			var resObj:ResObj = _resUrlDic[url];
			if (resObj == null)
			{
				resObj = new ResObj(url, priority);
				_resUrlDic[url] = resObj;
			}
			return resObj.getResource(action, way, rate, priority);
		}
		
		public static function getFrameEvent(url:String, action:String, startTime:Number):Array
		{
			var resObj:ResObj = _resUrlDic[url];
			if (resObj != null)
			{
				return resObj.getFrameEvent(action, startTime);
			}
			return null;
		}
		
		public static function increaseResourceReference(url:String):void
		{
			var reference:Reference = _referenceDic[url];
			if(reference == null)
			{
				reference = Reference.getInstance();
				reference.url = url;
				reference.count = 1;
				_referenceDic[url] = reference;
			}
			else
			{
				reference.count = reference.count + 1;
			}
		}
		
		public static function decreaseResourceReference(url:String):void
		{
			var reference:Reference = _referenceDic[url];
			if(reference != null)
			{
				reference.count = reference.count - 1;
				if(reference.count == 0)
				{
					reference.releaseTime = getTimer();
				}
			}
			else
			{
				trace("资源： " + url + "可能有泄漏");
			}
		}
		
		public static function dispose(force:Boolean = false):void
		{
			var currentTime:int = getTimer();
			for(var url:String in _referenceDic)
			{
				var reference:Reference = _referenceDic[url];
				var releasable:Boolean = force || (currentTime - reference.releaseTime) >= RECYCLE_TIME_SPAN;
				if(reference.count <= 0 && releasable)
				{
					var resObj:ResObj = _resUrlDic[url] as ResObj;
					if(resObj != null)
					{
						resObj.dispose();
						reference.dispose();
						delete _resUrlDic[url];
						delete _referenceDic[url];
					}
				}
			}
			var time:int = RECYCLE_INTERVAL;
			for(var key:String in _recycleImageUrlDic)
			{
				if(currentTime - _recycleImageUrlDic[key] > time)
				{
					delete _recycleImageUrlDic[key];
					delete _imageUrlDic[key];
				}
			}
		}
		
		public static function getConfig(url:String, action:String, property:String, priority:int = 10):Object
		{
			var resObj:ResObj = _resUrlDic[url];
			if (resObj == null)
			{
				resObj = new ResObj(url, priority);
				_resUrlDic[url] = resObj;
			}
			return resObj.getConfig(url, action, property);
		}
		
		/**
		 * @param bitmap
		 * @param url
		 * @param callback 回调无参数
		 * @param priority
		 */		
		public static function getBitmap(bitmap:Bitmap, url:String, callback:Function = null, priority:int = 10):void
		{
			var key:String = url;
			_recycleImageUrlDic[key] = getTimer();
			if (_imageUrlDic[key] == null)
			{
				ZLoader.addImage(url, function(info:Object):void
				{
					onLoad(info);
					if(callback != null)
					{
						callback();
					}
				}, bitmap, null, null, priority);
			}
			else
			{
				bitmap.bitmapData = _imageUrlDic[key];
				if(callback != null)
				{
					callback();
				}
			}
		}
		
		public static function getImage(bitmap: Bitmap, url:String, callback:Function = null, priority:int = 10): void
		{
			var key:String = url;
			_recycleImageUrlDic[key] = getTimer();
			if (_imageUrlDic[key] == null)
			{
				ZLoader.addImage(url, function(info:Object):void
				{
					onLoad(info);
					if(callback != null)
					{
						callback();
					}
				}, bitmap, null, null, priority);
			}
			else
			{
				bitmap.bitmapData = _imageUrlDic[key];
				if(callback != null)
				{
					callback();
				}
			}
		}
		
		private static function onLoad(info:Object):void
		{
			if (info.content is Bitmap)
			{
				//获取有效像素区域
				/*
				var bmd: BitmapData = (info.content as Bitmap).bitmapData;
				var truthPixelRect: Rectangle = bmd.getColorBoundsRect(0xff000000, 0x00000000, false);
				var truthWidth: Number = truthPixelRect.width;
				var truthHeight: Number = truthPixelRect.height;
				*/
				_imageUrlDic[info.url] = (info.content as Bitmap).bitmapData;
				info.target.bitmapData = _imageUrlDic[info.url];
			}
		}
	}
}

import com.core.pool.ObjectPool;
import com.core.resourse.ZLoader;

import flash.geom.Rectangle;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

class ResObj
{
	private var url:String;
	private var packs:Dictionary = new Dictionary();
	private var config:Object;
	private var other:Other;
	private var _disposed:Boolean = false;
	
	public function ResObj(url:String, priority:int)
	{
		this.url = url;
		ZLoader.add(this.url + "/config.gif", onLoaded, this, null, null, null, priority);
	}
	
	private function onLoaded(info:Object):void
	{
		if(_disposed == false)
		{
			try
			{
				info.data.uncompress();
				config = info.data.readObject();
				other = new Other(config);
			}
			catch(error:Error)
			{
				throw new Error(info.url);
			}
		}
	}
	
	public function getResource(action:String, way:int, rate:Number, priority:int):Object
	{
		if (config == null)
		{
			return null;
		}
		var actionObj:Object = config[action];
		if (actionObj == null && (action == "ready") && config["stand"])
		{
			action = "stand";
			actionObj = config[action];
		}
		if (actionObj == null)
		{
			return null;
		}
		var pack:String = actionObj.pack;
		var packObj:Object = packs[pack]; 
		if (packObj == null)
		{
			packObj = new Pack(url, pack, priority);
			packs[pack] = packObj;
		}
		var count:int = actionObj.count;
		if(rate >= 1)
		{
			rate = 0.9999;
		}
		way = 0;//单方向
		var frame:int = 0;
		if(other)
		{
			if(this.url.indexOf("role") != -1)
			{
			}
			var startTime:int = actionObj.totalTime * rate;
			var frameItem:Object = other.getFrameData(action, startTime);
			if(frameItem)
			{
				frame = frameItem.index;
			}
			else
			{
				frame = rate * count;
			}
		}
		else
		{
			frame = rate * count;
		}
		var index:int = actionObj.start + way * count + frame;
		var result:Object = packObj.getResource(index, actionObj.rect[index]);
		if(result != null)
		{
			result.frame = frame;
		}
		return result;
	}
	
	public function getConfig(url:String, action:String, property:String):Object
	{
		if(config != null)
		{
			if(action != null && action.length > 0 && config[action] != null)
			{
				if(property != null && property.length > 0 && config[action][property] != null)
				{
					return config[action][property];
				}
				return null;
			}
			return config;
		}
		return null;
//		if (!config || !config[action])
//			return null;
//		return config[action][property];
	}
	
	public function getFrameEvent(action:String, startTime:Number):Array
	{
		if(other != null)
		{
			var frameItem:Object = other.getFrameData(action, startTime);
			if(frameItem)
			{
				return frameItem.frameEvent;
			}
		}
		return null;
	}
	
	public function dispose():void
	{
		_disposed = true;
		config = null;
		for(var key:String in packs)
		{
			var pack:Pack = packs[key];
			pack.dispose();
		}
		packs = null;
	}
}

class Pack
{
	private var imageArr:Array = [];
	private var domain:ApplicationDomain;
	private var url:String;
	private var pack:String;
	public function Pack(url:String, pack:String, priority:int)
	{
		this.url = url;
		this.pack = pack;
		ZLoader.add(url + "/" + pack + ".swf", onLoad, url, null, null, null, priority);
	}
	
	private function onLoad(info:Object):void
	{
		domain = info.applicationDomain;
	}
	
	public function getResource(index:int, point:Array):Object
	{
		var imageObj:Object = imageArr[index];
		if (domain == null && imageObj == null)
		{
			return null;
		}
		if (imageObj == null)
		{
			try
			{
				imageObj = {index: index, bitmapData: new (domain.getDefinition("_" + index) as Class)(0, 0), x: point[0], y: point[1]};
				imageObj.rect = new Rectangle(point[0], point[1], imageObj.bitmapData.width, imageObj.bitmapData.height);
				imageArr[index] = imageObj;
			}
			catch (e:Error)
			{
				e.message += "url= " +  url + " pack= " + pack + " 序号 =" + index;
				//throw(e);
			}
		}
		return imageObj;
	}
	
	public function dispose():void
	{
		for each(var imageObj:Object in imageArr)
		{
			imageObj.bitmapData = null;
		}
		imageArr = null;
	}
}

class Reference
{
	public var url:String = "";
	public var count:int;
	public var releaseTime:int; //引用计数为零的时刻
	
	public static function getInstance():Reference
	{
		return ObjectPool.getObjectByClass(Reference) as Reference;
	}
	
	public function Reference()
	{
		
	}
	
	public function dispose():void
	{
		url = "";
		count = 0;
		releaseTime = 0;
		ObjectPool.recycle(this);
	}
}

class Other
{
	private var config:Object;
	private var totalTime:int = 100;
	private var frame:Dictionary = new Dictionary;
	
	public static function getInstance():Other
	{
		return ObjectPool.getObjectByClass(Other) as Other;
	}
	
	public function Other(config:Object)
	{
		this.config = config;
	}
	
	public function getDepth(action:String, way:int, frame:int):Object
	{
		if(config && config.other && config.other.depth)
		{
			var key:String = action + "_" + way + "_" + frame;
			return config.depth[key];
		}
		return null;
	}
	
	public function getFrameData(action:String, startTime:int):Object
	{
		var result:Object = null;
		if(config && config.other && config.other.frame)
		{
			var actionObj:Object = config.other.frame[action];
			if(actionObj != null)
			{
				result = frame[action + "_" + startTime];
				if(result != null)
				{
					return result;
				}
				for each(var item:Object in actionObj)
				{
					if(startTime >= item.startTime && startTime < item.frameTime + item.startTime)
					{
						result = item;
						for(var i:int = item.startTime; i<item.frameTime + item.startTime; i++)
						{
							frame[action + "_" + i] = item;
						}
						break;
					}
				}
			}
		}
		return result;
	}
	
	public function dispose():void
	{
		config = null;
		frame = new Dictionary;
		ObjectPool.recycle(this);
	}
}

