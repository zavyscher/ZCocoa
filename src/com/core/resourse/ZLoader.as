package com.core.resourse
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**暂时用于加载根目录文件修改功能
	 */	
	public class ZLoader
	{
		public static const LOW:int 	= 0;
		public static const MEDIUM:int 	= 10;
		public static const HIGH:int 	= 20;
		
		public static const MAX_PARALLEL_NUM:int = 3;
		private static const FILE_REGEXP:RegExp = /\.swf|\.jpg|\.png|\.gif|\.mp3/;
		private static const STORAGE_REGEXP:RegExp = /\.swf|\.jpg|\.png/;
		
		private static var loaderPool:Array = [];
		private static var decoderPool:Array = [];
		private static var infoPool:Array = [];
		
		private static var urlMap:Dictionary = new Dictionary();
		private static var request:URLRequest = new URLRequest();
		private static var loadList:Array = [];
		private static var decodeList:Array = [];
		private static var loadIngMap:Dictionary = new Dictionary;
		private static var waitMap:Dictionary = new Dictionary;
		
		public static var resourceHost:String = "";
		
		public static function init(resHost:String):void
		{
			resourceHost = resHost;
			for (var i:int = 0; i < MAX_PARALLEL_NUM; i++)
			{
				var loader:MyLoader = new MyLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.OPEN, openHandler);
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);	
				loaderPool.push(loader);
				
				var decoder:MyDecode = new MyDecode();
				decoder.contentLoaderInfo.addEventListener(Event.COMPLETE, decoderComplete);
				decoder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, decoderErrorHandler);
				decoder.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, decoderErrorHandler);
				decoderPool.push(decoder);
			}
		}
		
		public static function add(url:String, complete:Function, target:Object = null, progress:Function = null, onStart:Function = null, IOError:Function = null, level:int = MEDIUM, domain:ApplicationDomain = null):void
		{
			var info:Object = infoPool.length ? infoPool.pop() : {};
			info.url = url;
			info.complete = complete;
			info.target = target;
			info.level = level;
			info.progress = progress;
			info.onStart = onStart;
			info.IOError = IOError;
			info.isEmbedFont = false;
			info.isEmbedImage = false;
			info.domain = domain;
			doAdd(url, info);
		}
		
		public static function addImage(url:String, complete:Function, target:Object = null, progress:Function = null, IOError:Function = null, level:int = MEDIUM):void
		{
			var info:Object = infoPool.length ? infoPool.pop() : {};
			info.url = url;
			info.complete = complete;
			info.target = target;
			info.level = level;
			info.progress = progress;
			info.IOError = IOError;
			info.domain = null;
			info.isEmbedFont = false;
			if (url.match(/\.png|\.jpg/) != null)
			{
				info.isEmbedImage = false;
			}
			else
			{
				info.isEmbedImage = true;
			}
			doAdd(url, info);
		}
		
		public static function addFont(url: String, className: String, complete: Function, IOError:Function = null, level:int = MEDIUM, domain:ApplicationDomain = null):void
		{
			var info: Object = infoPool.length ? infoPool.pop() : {};
			info.url = url;
			info.className = className;
			info.complete = complete;
			info.IOError = IOError;
			info.isEmbedFont = true;
			info.isEmbedImage = false;
			info.domain = domain;
			doAdd(url, info);
		}
		
		private static function doAdd(url:String, info:Object):void
		{
			trace("Load resource: " + url);
			if(loadIngMap[url] != undefined)
			{
				var waitList:Array = waitMap[info.url];
				if(waitList == null)
				{
					waitList = [];
					waitMap[info.url] = waitList;
				}
				waitList.push(info);
				return;
			}
			var cookieData:ByteArray = null;
			var time:int = getTimer();
			//			if(url.match(STORAGE_REGEXP))
			//			{
			//				cookieData = FileStorage.getFile(url);
			//			}
			if (cookieData)//如果有缓存的话
			{
				if (needDecode(url))
				{
					info.data = cookieData;
					if (urlMap[info.url])
					{
						urlMap[info.url].push(info);
					}
					else
					{
						urlMap[info.url] = [info];
						decodeList.push(info);
						decode();
					}
				}
				else
				{
					info.data = makeByteArrayCopy(cookieData);
					if(info.complete != null)
					{
						info.complete(info);
					}
				}
			}
			else//没有缓存的话
			{
				if (urlMap[info.url] != null)
				{
					for each(var target:Object in loadList)
					{
						if(target.url == info.url)
						{
							info.level = Math.max(target.level, info.level);
							target.level = Math.max(target.level, info.level);
							if(target.domain == null)
							{
								target.domain = info.domain;
							}
							break;
						}
					}
					urlMap[info.url].push(info);
				}
				else
				{
					urlMap[info.url] = [info];
					loadList.push(info);//加入加载队列
					
					if (info.url.match(/\.png|\.jpg/) != null)
					{
						startResource();
						return ;
					}
				}
			}
			start();
		}
		
		private static function start():void
		{
			if (loaderPool.length == 0)
			{
				return;
			}
			var loader:MyLoader;
			if(loadList.length > 0)
			{
				loadList.sortOn("level", Array.NUMERIC);//下载优先级排序
				var info:Object = loadList.pop();
				if((info.level < -10000 && loaderPool.length < MAX_PARALLEL_NUM) || (info.level < LOW  && info.level > -10000 && loaderPool.length < MAX_PARALLEL_NUM - 1))
				{
					//预留加载器
					loadList.push(info);
					return;
				}
				loader = loaderPool.pop();
				loader.info = info;
				request.url = resourceHost + loader.info.url;
				loader.load(request);
				loadIngMap[info.url] = info.url;
			}
		}
		
		private static function startResource(): void
		{
			if (!decoderPool.length)
				return ;
			
			var info:Object = loadList.pop();
			if (needDecode(info.url))//需要解码
			{
				//在此可以保存已加载对象
				decodeList.push(info);
				decode();
			}
			
//			var decodeLoader:MyDecode;
//			if(decodeList.length > 0)
//			{
//				decodeList.sortOn("level", Array.NUMERIC);
//				var info:Object = decodeList.pop();
//				if((info.level < -10000 && decoderPool.length < MAX_PARALLEL_NUM) || (info.level < LOW  && info.level > -10000 && decoderPool.length < MAX_PARALLEL_NUM - 1))
//				{
//					//预留加载器
//					decodeList.push(info);
//					return;
//				}
//				decodeLoader = decoderPool.pop();
//				decodeLoader.info = info;
//				request.url = resourceHost + decodeLoader.info.url;
//				decodeLoader.load(request);
//				loadIngMap[info.url] = info.url;
//			}
		}
		
		private static function openHandler(e:Event):void
		{
			var loader:MyLoader = e.target as MyLoader;
			var info:Object = loader.info;
			if (info.onStart)
			{
				info.onStart(e);
			}
		}
		
		private static function completeHandler(e:Event):void
		{
			var loader:MyLoader = e.target as MyLoader;
			var info:Object = loader.info;
			info.data = loader.data;
			if (needDecode(info.url))//需要解码
			{
				//在此可以保存已加载对象
				decodeList.push(info);
				decode();
			}
			else
			{
				//在此可以保存已加载对象
				var infoList:Array = urlMap[info.url];
				while (infoList.length)
				{
					var tempInfo:Object = infoList.shift();
					if(tempInfo.complete != null)
					{
						tempInfo.complete(info);
					}
				}
				delete urlMap[info.url];
				infoPool.push(info);
				delete loadIngMap[info.url];
				doWait();
			}
			loaderPool.push(loader);
			start();
		}
		
		private static function needDecode(url:String):Boolean
		{
			var tem:Array = url.split(".");
			var ext:String = tem[tem.length - 1];
			if (ext == "swf" || ext == "png" || ext == "jpg")
			{	
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function progressHandler(e:ProgressEvent):void
		{
			if (e.target.info.progress)
			{
				e.target.info.progress(e);
			}
		}
		
		private static function errorHandler(e:IOErrorEvent):void
		{
			var loader:MyLoader = e.target as MyLoader;
			trace("MassLoader IO_ERROR: " + loader.info.url);
			if (loader.info.IOError)
			{
				loader.info.IOError(loader.info);
			}
			delete loadIngMap[loader.info.url];
			dispose(loader.info);
			loader.close();
			loaderPool.push(loader);
			doWait();
			start();
		}
		
		private static function decode():void
		{
			if (!decoderPool.length || !decodeList.length)
				return;
			
			decodeList.sortOn("level", Array.NUMERIC);
			var decoder:MyDecode = decoderPool.pop();
			decoder.info = decodeList.shift();
			loadIngMap[decoder.info.url] = decoder.info.url;
			var loaderContext: LoaderContext = new LoaderContext(false, decoder.info.domain);
			if(decoder.info.domain != null)
			{
				decoder.loadBytes(decoder.info.data, loaderContext);
			}
			else if (decoder.info.url.match(/\.png|\.jpg/) != null)
			{
				request.url = resourceHost + decoder.info.url;
				decoder.load(request, loaderContext);
			}
			else
			{
				var domain: ApplicationDomain;
				var arrSys: Array = Capabilities.os.split(" ");
				if (arrSys && arrSys[0] != "Windows")
				{
					domain = ApplicationDomain.currentDomain;
				}
				loaderContext = new LoaderContext(false, domain);
				loaderContext.allowCodeImport = true;//air需要此属性(导入swf文件);
				decoder.loadBytes(decoder.info.data, loaderContext);
			}
		}
		
		private static function decoderComplete(e:Event):void
		{
			var decoder:MyDecode = e.target.loader as MyDecode;
			var info:Object = decoder.info;
			var infoList:Array = urlMap[info.url];
			while (infoList.length)
			{
				info = infoList.shift();
				if (info.isEmbedImage == true)
				{
					var clz:Class = decoder.contentLoaderInfo.applicationDomain.getDefinition("Image") as Class;
					info.content = new Bitmap(new clz() as BitmapData);
				}
				else if(info.isEmbedFont == true)
				{
					if (info.className != undefined)
					{
						clz = decoder.contentLoaderInfo.applicationDomain.getDefinition(info.className) as Class;
						info.content = clz;
					}
				}
				else
				{
					info.content = decoder.content;
				}
				info.applicationDomain = decoder.contentLoaderInfo.applicationDomain;
				if(info.complete != null)
				{
					info.complete(info);
				}
				dispose(info);
			}
			delete urlMap[info.url];
			delete loadIngMap[info.url];
			decoderPool.push(decoder);
			decode();
			doWait();
		}
		
		private static function decoderErrorHandler(e:Event):void
		{
			var decoder:MyDecode = e.target.loader as MyDecode;
			delete loadIngMap[decoder.info.url];
			dispose(decoder.info);
			doWait();
		}
		
		private static function doWait():void
		{
			for(var key:String in waitMap)
			{
				if(loadIngMap[key] == undefined)
				{
					var list:Array = waitMap[key];
					var isLoading:Boolean = false;
					for(var i:int=0; i < list.length; i++)
					{
						var info:Object = list[i];
						doAdd(info.url, info);
						if(i == 0 && list.length > 1 && loadIngMap[info.url] != undefined)
						{
							isLoading = true;
						}
						if(isLoading == true)
						{
							delete loadIngMap[info.url];
						}
					}
					if(isLoading == true)
					{
						loadIngMap[key] = key;
					}
					delete waitMap[key];
				}
			}
		}
		
		private static function makeByteArrayCopy(data:ByteArray):ByteArray
		{
			var result:ByteArray = new ByteArray();
			data.readBytes(result);
			data.position = 0;
			return result;
		}
		
		private static function dispose(info:Object):void
		{
			infoPool.push(info);
			info.applicationDomain = null;
			info.content = null;
			info.complete = null;
			info.target = null;
			info.progress = null;
			info.IOError = null;
			info.domain = null;
			info.data = null;
		}
	}
}

import flash.display.Loader;
import flash.net.URLLoader;

class MyLoader extends URLLoader
{
	public var info:Object;
	public function MyLoader(){}
}

class MyDecode extends Loader
{
	public var info:Object;
	public function MyDecode(){}
}


