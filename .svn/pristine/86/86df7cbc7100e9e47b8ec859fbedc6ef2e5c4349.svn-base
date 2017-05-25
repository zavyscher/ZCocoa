package com.components.template
{
	import com.components.ZView;
	import com.components.controller.ZViewController;
	import com.interfaces.IValueObject;
	import com.core.coreGraphics.CGPoint;
	import com.core.coreGraphics.CGRect;
	import com.core.coreGraphics.CGSize;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**<b>视频, 使用方法:</b><br>
	 * 1.设置streamUrl;<br>
	 * 2.调用initLocalVideo设置视频尺寸(可先预设(0,0),在VideoConnected时根据_video的尺寸自适应);<br>
	 * 3.设置videoOffset视频位置(_ctnVideo的位置)
	 * @author leetnzavy
	 */	
	public class ZVideoViewController extends ZViewController implements IValueObject
	{
		public static const VIDEO_CONNECTED: String = "video_connected";
		public static const VIDEO_ENDS: String = "video_ends";
		
		/**列表循环模式*/
		public static const MODE_ALL_CYCLE: int = 0;
		/**单曲循环模式*/
		public static const MODE_SINGLE_CYCLE: int = 1;
		/**单曲播放模式*/
		public static const MODE_ONCE: int = 2;
		
		protected var _duration: Object;
		protected var _data: Object;
		
		private var _imgBg: ZView;
		protected var _ctnVideo: ZView;
		
		protected var _netConnection: NetConnection;
		protected var _video: Video;
		protected var _streamUrl: String;
		protected var _stream: NetStream;
		
		public var playMode: int = MODE_SINGLE_CYCLE;
		private var _isMute: Boolean;
		
		protected var _volume: Number = 0;
		protected var _isPlaying: Boolean;
		
		public function ZVideoViewController()
		{
			super();
		}
		
		override public function viewDidLoad():void
		{
			super.viewDidLoad();
			
			_ctnVideo = new ZView();
			this.view.addSubView(_ctnVideo);
		}
		
		override public function viewDidAppear(animated:Boolean = false):void
		{
			if (_stream && (_streamUrl && _streamUrl != ""))
			{
				_isPlaying = true;
				_stream.resume();
			}
		}
		
		override public function viewDidDisappear(animated:Boolean = false):void
		{
			if (_stream)
			{
				_isPlaying = false;
				_stream.pause();
			}
		}
		
		/**设置背景
		 * @param value
		 */		
		public function set backgroundView(value: ZView): void
		{
			if (_imgBg)
			{
				_imgBg.removeFromSuperView();
				_imgBg = null;
			}
			_imgBg = value;
			this.view.insertView(_imgBg, 0);
		}
		
		/**初始化播放本地视频
		 * @param videoSize 视频可视尺寸
		 */		
		public function initLocalVideo(videoSize: CGSize = null): void
		{
			//利用屏幕实际像素硬编码算出的比例
			if (_video && _video.parent)
			{
				_video.parent.removeChild(_video);
				_video = null;
			}
			_video = new Video();
			_video.smoothing = true;
			if (videoSize)
			{
				videoScreenSize = videoSize;
			}
			_ctnVideo.addChild(_video);
			
			if (_netConnection)
			{
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				_netConnection.close();
				_netConnection = null;
			}
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_netConnection.connect(null);
		}
		
		public function initNetVideo(videoSize: CGSize = null): void
		{
			
		}
		
		protected function onNetStatusHandler(e: NetStatusEvent): void
		{
			switch (e.info.code)
			{
				case "NetStream.Play.Start":
					this.dispatchEvent(new Event(VIDEO_CONNECTED));
					trace(e.type + " dispatchEvent >> " + e.info.code);
					break ;
				
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video");
					break;
				
				case "NetStream.Buffer.Full":
					break;
				
				case "NetStream.Play.Stop":
					trace("播放结束");
					if (playMode == MODE_SINGLE_CYCLE)
					{
						toPause();
						toReplay();
					}
					else if (playMode == MODE_ALL_CYCLE)
					{
						connectStream();
					}
					else if (playMode == MODE_ONCE)
					{
						
					}
					this.dispatchEvent(new Event(VIDEO_ENDS));
					trace(e.type + " dispatchEvent >> " + e.info.code);
					break;
			}
		}
		
		protected function connectStream(): void
		{
			if (!_stream)
			{
				_stream = new NetStream(_netConnection);
				_stream.client = this;
				_stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorHandler);
				_video.attachNetStream(_stream);
			}
			if (!_streamUrl)
			{
				trace("流媒体URL不明");
				return;
			}
			_stream.play(_streamUrl);
			trace("streamUrl >> " + _streamUrl);
		}
		
		protected function onSecurityErrorHandler(e: SecurityErrorEvent): void
		{
			trace("securityErrorHandler: " + e);
		}
		
		protected function onAsyncErrorHandler(e: AsyncErrorEvent):void
		{
			trace(e);
		}
		
		public function onMetaData(infoObject: Object):void 
		{
			duration = infoObject.duration;
		}
		
		public function onXMPData(infoObject: Object = null): void
		{
			
		}
		
		public function onPlayStatus(infoObject: Object):void
		{
			trace("playstatus start>>");
			if (!infoObject)
			{
				return ;
			}
//			for (var key: String in infoObject)
//			{
//				trace("[" + key + " = " + infoObject[key] + "]");
//			}
//			trace("playstatus end>>");
		}
		
		override public function popViewControllerAnimated(animated: Boolean): ZViewController
		{
			toStop();
			
			if (_video)
				_video.clear();
			
			if (_netConnection)
			{
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				_netConnection.close();
				_netConnection = null;
			}
			
			if (_stream)
			{
				_stream.dispose();
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncErrorHandler);
				_stream = null ;
			}
			
			return super.popViewControllerAnimated(animated);
		}
		
		public function set videoFrame(value: CGRect): void
		{
			if (_video)
			{
				_video.x = value.origin.x;
				_video.y = value.origin.y;
				_video.width = value.size.width;
				_video.height = value.size.height;
			}
		}
		
		public function set videoOffset(value: CGPoint): void
		{
			if (_video)
			{
				_ctnVideo.x = value.x;
				_ctnVideo.y = value.y;
			}
		}
		
		public function set videoScreenSize(value: CGSize): void
		{
			if (_video)
			{
				_video.width = value.width;
				_video.height = value.height;
			}
		}
		
		public function get streamUrl():String
		{
			return _streamUrl;
		}
		
		public function set streamUrl(value:String):void
		{
			_streamUrl = value;
			connectStream();
		}
		
		public function set volume(value: Number): void
		{
			if (_stream)
			{
				_stream.soundTransform = new SoundTransform(value);
			}
		}
		
		public function set isMute(value:Boolean):void
		{
			_isMute = value;
			if (value)
			{
				_volume = _stream.soundTransform.volume;
				volume = 0;
			}
			else
			{
				volume = _volume;
			}
		}
		
		public function get isMute(): Boolean
		{
			return _isMute;
		}
		
		public function set currentTime(value: Number): void
		{
			_stream.seek(value);
		}
		
		/**获得播放时间(播放头)
		 * @return 单位为秒
		 */		
		public function get currentTime(): Number
		{
			if (_stream)
			{
				return _stream.time;
			}
			return 0;
		}
		
		/**缓冲区大小。可设置(单位为秒)，默认为0.1秒*/		
		public function get bufferTime(): Number
		{
			if (_stream)
			{
				return _stream.bufferTime;
			}
			return 0.1;
		}
		
		/**已进入缓冲区的秒数*/
		public function get bufferLength(): Number
		{
			if (_stream)
			{
				return _stream.bufferLength;
			}
			return 0;
		}
		
		/**已缓冲的百分比*/
		public function get bufferPercent(): Number
		{
			return bufferLength / bufferTime;
		}
		
		/**已下载的字节数*/
		public function get bytesLoaded(): uint
		{
			if (_stream)
			{
				return _stream.bytesLoaded;
			}
			return 0;
		}
		
		/**总字节数*/
		public function get bytesTotal(): uint
		{
			if (_stream)
			{
				return _stream.bytesTotal;
			}
			return 0;
		}
		
		/**已下载的百分比*/
		public function get bytesPercent(): Number
		{
			return bytesLoaded / bytesTotal;
		}
		
		public function get duration():Object
		{
			return _duration;
		}
		
		public function set duration(value:Object):void
		{
			_duration = value;
		}
		
		public function set data(value: Object):void
		{
			_data = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		/**暂停播放*/
		public function toPause(): void
		{
			if (_stream)
			{
				_isPlaying = false;
				_stream.pause();
			}
		}
		
		/**继续播放*/
		public function toResume(): void
		{
			if (_stream)
			{
				_isPlaying = true;
				_stream.resume();
			}
		}
		
		/**停止播放*/
		public function toStop(): void
		{
			if (_stream)
			{
				_isPlaying = false;
				_stream.pause();
				_stream.seek(0);
			}
		}
		
		public function toReplay():void
		{
			_stream.seek(0);
			toResume();
		}
		
		public function dispose(): void
		{
			if (_stream)
			{
				toStop();
				_stream.dispose();
				_stream = null;
				_streamUrl = null;
			}
		}
		//
	}
}


