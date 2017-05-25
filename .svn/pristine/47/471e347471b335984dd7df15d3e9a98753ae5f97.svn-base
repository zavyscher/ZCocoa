package com.components.custom.views
{
	import com.components.ZView;
	import com.core.resourse.DefaultResPath;
	import com.interfaces.IValueObject;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	/**@author leetn-dmt-zavy
	 */
	public class ZBrowser extends ZView implements IValueObject
	{
		public var preURL: String = "";
		public var curURL: String = "";
		private var _data: Object;
		
		protected var head: ZView;
		protected var toolbar: ZView;
		protected var body: ZView;
		protected var htmlLoader: HTMLLoader;
		
		protected var urlReq:URLRequest = new URLRequest();
		
		public function ZBrowser(winWidth: Number, winHeight: Number, htmlName: String = "index.html")
		{
			super();
			
			if (HTMLLoader.isSupported)
			{
				body = new ZView();
				body.mouseEnabled = true;
				this.addChild(body);
				
				htmlLoader = new HTMLLoader();
				body.addChild(htmlLoader);
				
				this.setHTML(winWidth, winHeight, htmlName);
			}
		}
		
		public function setHTML(winWidth: Number, winHeight: Number, htmlName: String = "index.html"):void
		{
			if (winWidth > 0 && winHeight > 0 && htmlName != null && htmlName != "")
			{
				var temPath: File = new File(File.applicationDirectory.resolvePath(DefaultResPath.LOCAL_APP_URL + htmlName).nativePath);
				var url: String = (temPath) ? new File(temPath.nativePath).url : "";
				urlReq.url = url;
				
				htmlLoader.width = winWidth; 
				htmlLoader.height = winHeight;
				htmlLoader.navigateInSystemBrowser = true;
				htmlLoader.placeLoadStringContentInApplicationSandbox = true;
				htmlLoader.addEventListener(Event.HTML_DOM_INITIALIZE, willCompleteInitialized);
				htmlLoader.load(urlReq);
			}
		}
		
		/**当前URL路径
		 * @param value
		 */		
		public function set currentURL(value: String): void
		{
			preURL = urlReq.url;
			urlReq.url = value;
			htmlLoader.load(urlReq);
		}
		
		public function get currentURL(): String
		{
			return urlReq.url;
		}
		
		protected function willCompleteInitialized(e: Event):void
		{
			data = e.currentTarget;
			trace("Loaded HTML Successful >> " + data.location);
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		//
	}
}


