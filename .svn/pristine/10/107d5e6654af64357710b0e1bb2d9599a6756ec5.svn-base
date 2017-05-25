package com.components.custom
{
	import com.core.pool.ObjectPool;
	import com.core.utils.Singleton;
	import com.interfaces.IMusic;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**音乐（mp3）
	 * @author leetn-dmt-zavy
	 */
	public class Music extends EventDispatcher implements IMusic
	{
		public static const END_MUSIC: String = "end_music";
		/**前一个URL*/
		protected static var preUrl: String;
		/**前一首音乐*/
		protected static var prevMusic: Sound;
		/**前一个通道*/
		protected static var prevMusicChannel: SoundChannel;
		
		protected var _url: String;
		/**当前操作音乐*/
		protected static var music: Sound;
		/**当前操作通道*/
		protected static var musicChannel: SoundChannel;
		
		protected static var _currentPosition: Number = 0;
		/**是否正在播放*/
		public static var isPlaying: Boolean;
		/**是否循环播放*/
		public static var isLoop: Boolean = true;
		/**加载完成后执行暂停*/
		public static var pauseWhenLoaded: Boolean;
		/**加载完成后立即播放*/
		public static var playWhenLoaded: Boolean;
		
		/**单例模式/唯一
		 * @return 
		 */		
		public static function get singleton(): Music {
			return Singleton.getInstance(Music);
		}
		
		/**循环利用模式
		 * @return 
		 */		
		public static function get instance(): Music {
			return ObjectPool.getObjectByClass(Music);
		}
		
		public function Music()
		{
		}
		
		/**暂时缓存地址（不加载音乐文件）
		 * @param value
		 */		
		public function set cacheURL(value: String): void
		{
			_url = value;
		}
		
		/**设置资源URL并加载
		 * @param value
		 */		
		public function set url(value: String):void
		{
			_url = value;
			this.reset();
		}
		
		public function get url(): String
		{
			return _url;
		}
		
		protected function reset(): void
		{
			if (!_url)
			{
				trace("Music url is null");
				return ;
			}
			
			var req: URLRequest = new URLRequest(_url);
			if (!music)
			{
				music = new Sound();
				music.load(req);
				trace("Load sound >> " + _url);
				music.addEventListener(Event.COMPLETE, onSoundLoadedHandler);
				music.addEventListener(Event.OPEN, onStartHandler);
				music.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				music.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			}
		}
		
		protected function onSoundLoadedHandler(e: Event): void
		{
			if (playWhenLoaded && !pauseWhenLoaded)
			{
				this.play(_url);
			}
			if (pauseWhenLoaded)
			{
				this.pause();
			}
		}
		
		protected function onSoundCompleteHandler(e: Event): void
		{
			if (isLoop)
			{
				isPlaying = false;
				_currentPosition = 0;
				this.play(_url);
			}
			else
			{
				this.stop();
				this.dispatchEvent(new Event(Music.END_MUSIC));
			}
		}
		
		protected function onStartHandler(e: Event): void
		{
		}
		
		protected function onIOErrorHandler(e: Event):void
		{
			trace("Music.instance.onIOErrorHandler >>> " + e);
		}
		
		protected function onProgressHandler(e: Event):void
		{
		}
		
		public function play(playURL: String = ""): void
		{
			if (!music)
			{
				this.reset();
//				if (playURL && playURL != "")
//					this.play(playURL);
				return ;
			}
			
			if (isPlaying && (preUrl == _url))
			{
				return ;
			}
			
			isPlaying = true;
			
			musicChannel = music.play(position);
			if (musicChannel && musicChannel.hasEventListener(Event.SOUND_COMPLETE) == false)
			{
				musicChannel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleteHandler);
			}
			
			if (playURL != _url)
			{
				prevMusic = music;
				prevMusicChannel = musicChannel;
			}
			preUrl = _url;
		}
		
		public function pause(): void
		{
			isPlaying = false;
			
			if (!music && !musicChannel)
			{
				this.reset();
				return ;
			}
			
			if (musicChannel)
			{
				_currentPosition = musicChannel.position;
				musicChannel.stop();
			}
		}
		
		public function stop():void
		{
			this.pause();
			_currentPosition = 0;
		}
		
		public function playPrev(): void
		{
			this.stop();
			music = prevMusic;
			musicChannel = prevMusicChannel;
			if (_url)
				this.play();
		}
		
		/**当前播放位置*/
		public static function get position():Number
		{
			return protected::_currentPosition;
		}
		
		public function deinit(): void
		{
			this.stop();
			music = null;
		}
		//
	}
}


