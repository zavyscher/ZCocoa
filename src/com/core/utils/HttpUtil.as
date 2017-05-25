package com.core.utils
{
	import com.adobe.serialization.json.JSON;
	import com.dynamicflash.util.Base64;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**http POST（硬编版）
	 * @author leetn-dmt-zavy
	 */	
	public class HttpUtil
	{
		public static const CREATE_RESULT_CODE: String = "createResultCode";
		public static const CHECK_RESULT_CODE_STATUS: String = "checkResultCodeStatus";
		public static const DEFAULT_PREFIX: String = "https://www.indoorlink.com/exstudio/gamemanager/";
		
		public static var createResultCodeCallback: Function;
		public static var checkResultCodeStatusCallback: Function;
		
		public function HttpUtil()
		{
		}
		
		/**获取一个二维码
		 * @param gameUID String(gameuid:游戏唯一标示符)
		 * @param result result:int(result:游戏得分)
		 * @param prefix 默认为空，如果不为空，则引用该接口前缀
		 */
		public static function createResultCode(gameuid: String, result: int, prefix: String = null):void
		{
			if (result == 0)
			{
				trace("零分无法获取二维码");
				return ;
			}
			var variables: Object = new Object();
			variables.gameuid = String(gameuid);
			variables.result = int(result);
			variables.catg = int(7);
			var json: String = JSONDict.encode(variables);
			
			var request: URLRequest = new URLRequest((prefix == null ? DEFAULT_PREFIX : prefix) + CREATE_RESULT_CODE);
			request.method = URLRequestMethod.POST;
			request.data = json;
			
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onCreateResultCodeCompleteHandler);
			urlLoader.load(request);
		}
		
		private static function onCreateResultCodeCompleteHandler(event: Event):void
		{
			var urlLoader: URLLoader = URLLoader(event.target);
			var data: Object = com.adobe.serialization.json.JSON.decode(urlLoader.data);
			switch (data.ret)
			{
				case 0:
					var baseStr: String = String(data.datas.qrcode).split("base64,")[1];
					var decoded: ByteArray = Base64.decodeToByteArray(baseStr);
					
					var loader: Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteCreateResultCodeHandler);
					loader.loadBytes(decoded);
					return ;
			}
			trace(data.datas);
		}
		
		private static function onCompleteCreateResultCodeHandler(e: Event):void
		{
			var bmd: BitmapData = Bitmap(e.target.content).bitmapData;
			if (createResultCodeCallback is Function)
			{
				createResultCodeCallback(bmd);
			}
		}
		
		/**检查二维码状态
		 * @param qrcodeid 二维码的唯一凭证, 用于查询该二维码是否被使用了
		 * @param prefix 默认为空，如果不为空，则引用该接口前缀
		 */
		public static function checkResultCodeStatus(qrcodeid: String, prefix: String = null):void
		{
			var variables: URLVariables = new URLVariables();
			variables.qrcodeid = qrcodeid;
			variables.catg = int(7);
			
			var request: URLRequest = new URLRequest((prefix == null ? DEFAULT_PREFIX : prefix) + CHECK_RESULT_CODE_STATUS);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onCheckResultCodeStatusCompleteHandler);
			urlLoader.load(request);
		}
		
		private static function onCheckResultCodeStatusCompleteHandler(event: Event):void
		{
			var urlLoader: URLLoader = URLLoader(event.target);
			var data: Object = com.adobe.serialization.json.JSON.decode(urlLoader.data);
			switch (data.ret)
			{
				case 0:
					var baseStr: String = String(data.datas.qrcode).split("base64,")[1];
					var decoded: ByteArray = Base64.decodeToByteArray(baseStr);
					
					var loader: Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteCheckResultCodeStatusHandler);
					loader.loadBytes(decoded);
					break ;
			}
			trace(data.datas);
		}
		
		private static function onCompleteCheckResultCodeStatusHandler(e: Event):void
		{
			var bmd: BitmapData = Bitmap(e.target.content).bitmapData;
			if (createResultCodeCallback is Function)
			{
				createResultCodeCallback(bmd);
			}
		}
		//
	}
}


