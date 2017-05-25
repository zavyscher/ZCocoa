package com.components.custom.views
{
	import com.components.ZImageView;
	import com.components.ZView;
	import com.core.resourse.DefaultResPath;
	import com.interfaces.IValueObject;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	/**序列图MovieClip
	 * @author leetn-dmt-zavy
	 */
	public class PicMC extends ZView implements IValueObject
	{
		public static var useDefaultUrl: Boolean = true;
		public static const END_TO_PLAY: String = "end_to_play";
		
		protected var _data: Object;
		protected var _x: Number = 0;
		protected var _y: Number = 0;
		/**播放的帧bmdList.length - 1*/
		protected var _currentFrame: int = -1;
		private var _frameLoaded: int;
		/**存储切出来的位图*/
		protected var _vecBmd: Vector.<ClipVO>;
		/**存储脚本的数组，其结构为二维数组{ frame : [ {script: Function, params: Array}, ...]}*/
		protected var _dicScript: Dictionary;
		protected var _arrFile: Array;
		
		/**管理素材的素材内存池 [<b>key</b> : 暂时缓存MovieClip] : [<b>value</b> : BitmapData类型的Vector];<br>
		 * <b>工作原理：</b>当每次切完素材的时候，将该动画序列存都内存池中，下次切图的时候先检查内存中是否已经存在，如果存在，直接取出
		 */
		protected static var dicSource: Dictionary;
		/**主要显示对象*/
		protected var _img: ZImageView;
		/**暂时缓存MovieClip，初始化完成后会从*/
		protected var _url: String = "";
		
		/**完成加载*/
		public var onLoad: Function;
		/**完成加载后需要传递的参数*/
		protected var _params: Array;

		/**设定是否循环播放 默认=> true : 循环播放; false : 播放完成后暂停*/
		public var isLoop: Boolean = true;
		public var isCompleted: Boolean;
		
		/**序列图MovieClip
		 * @param url 传入需要序列图的文件夹路径
		 * @param loadComplete 回调函数
		 * @param parameters 回调参数，默认第一个参数是VMC自身
		 */		
		public function PicMC(url: String, loadComplete: Function = null, ...parameters)
		{
			_url = url;
			onLoad = loadComplete;
			_params = parameters;
			
			_img = new ZImageView();
			this.addSubView(_img);
			
			initWithURL(url);
		}
		
		/**
		 * @param url
		 */
		public function initWithURL(url: String):void
		{
			if (url)
			{
				var path: String = (useDefaultUrl) ? DefaultResPath.LOCAL_URL + DefaultResPath.RESOURCE + url : url;
				var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
				if (file.exists)
					_arrFile = resortArr(file.getDirectoryListing());
				
				if (this.hasEventListener(Event.ADDED_TO_STAGE) == false)
					this.addEventListener(Event.ADDED_TO_STAGE, willAddToStageHandlder);
				else
					willLoad();
			}
		}
		
		private function resortArr(arr: Array): Array
		{
			var func: Function = function (a: File, b: File): Number {
				if (a.name.indexOf(".png") != -1 && b.name.indexOf(".png") != -1)
				{
					var num1: int = a.name.split(".png")[0];
					var num2: int = b.name.split(".png")[0];
				}
				if (num1 > num2) return 1;
				else if (num1 < num2) return -1;
				else return 0;
			}
			return arr.sort(func);
		}
		
		/**添加至舞台时将执行处理器
		 * @param e
		 */		
		private function willAddToStageHandlder(e: Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, willAddToStageHandlder);
			
			if (_url)
			{
				willLoad();
			}
		}
		
		private function willLoad(): void
		{
			dicSource ||= new Dictionary();
			
			_vecBmd = dicSource[_url];//无论是否有存过，先从内存中提取下
			if(_vecBmd && _vecBmd.length > 0)
			{
				isCompleted = true;
				play();
				return;
			}
			
			_vecBmd = new Vector.<ClipVO>();
			dicSource[_url] = _vecBmd;//生成一个动画数组实例，并且在在内存池中存一份引用
			
			startLoad();
		}
		
		private function startLoad():void
		{
			if (_arrFile.length <= 0)
			{
				isCompleted = true;
				play();//切完图默认播放
				
				if (onLoad is Function)
				{
					if (_params && _params.length > 0)
						onLoad(this, _params);
					else
						onLoad(this);
				}
				return ;
			}
			
			var file: File = _arrFile.shift();
			if (!file.exists)
			{
				startLoad();
				return ;
			}
			
			var url: String = file.url.split(DefaultResPath.LOCAL_URL)[1];
			_img.loadWith(DefaultResPath.LOCAL_URL + url, function (pic: ZImageView): void {
				var cvo: ClipVO = new ClipVO();
				cvo.offsetX = cvo.offsetY = 0;
				cvo.data = pic.bitmap.bitmapData;
				_vecBmd.push(cvo);
				_frameLoaded = _vecBmd.length;
				
				startLoad();
			});
		}
		
		/**在当前帧上进行播放
		 */
		public function play():void
		{
			this.addEventListener(Event.ENTER_FRAME, onLoopHandler);
		}
		
		/**从指定帧开始播放 SWF 文件。这会在帧中的所有剩余动作执行完毕后发生。要指定场景以及帧，请指定 scene 参数的值。
		 * @param frame 表示播放头转到的帧编号的数字，或者表示播放头转到的帧标签的字符串。如果您指定了一个数字，则该数字是相对于您指定的场景的。如果不指定场景，当前场景将确定要播放的全局帧编号。如果指定场景，播放头会跳到指定场景的帧编号。
		 */		
		public function gotoAndPlay(frame: Object):void
		{
			if (frame is Number)
			{
				checkFrame((frame as Number) - 1);
			}
			else if (frame is String)
			{
				
			}
			play();
		}
		
		/**停在当前帧*/		
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onLoopHandler);
			checkFrame(_currentFrame);
			draw();//避免一开始运行就移除
		}
		
		/**将播放头移到影片剪辑的指定帧并停在那里。这会在帧中的所有剩余动作执行完毕后发生。如果除了指定帧以外，您还希望指定场景，那么请指定 scene 参数。
		 * @param frame 表示播放头转到的帧编号的数字，或者表示播放头转到的帧标签的字符串。如果您指定了一个数字，则该数字是相对于您指定的场景的。如果不指定场景，当前场景将确定转到其中并停止的全局帧编号。如果指定了场景，播放头会转到指定场景中的帧编号并停止。
		 */		
		public function gotoAndStop(frame: Object):void
		{
			if (frame is Number)
			{
				checkFrame((frame as Number) - 1);
			}
			else if (frame is String)
			{
				
			}
			stop();
		}
		
		/**将播放头转到前一帧并停止。*/
		public function prevFrame():void
		{
			gotoAndStop(--_currentFrame);
		}
		
		/**将播放头转到下一帧并停止。*/
		public function nextFrame():void
		{
			gotoAndStop(++_currentFrame);
		}
		
		//检测目标帧是否不规矩
		private function checkFrame(frame:int):void
		{
			_currentFrame = frame;
			if(_currentFrame < 0) _currentFrame = 0;
			if(_currentFrame > _vecBmd.length - 1)
			{
				if (isLoop)
					_currentFrame = 0;
				else
					_currentFrame = _vecBmd.length - 1;
			}
		}
		
		/**对每帧进行渲染，改变数组的索引值对下一张进行渲染 超过最大值归零
		 * @param e
		 */
		private function onLoopHandler(e:Event):void
		{
			_currentFrame++;
			checkFrame(_currentFrame);
			draw();
			willCheckScript();
		}
		
		/**检查是否存在帧脚本，如有则执行脚本*/
		private function willCheckScript():void
		{
			if (_dicScript && _dicScript[_currentFrame])
			{
				var len: int = _dicScript[_currentFrame].length;
				for (var i: int = 0; i < len; i++)
				{
					var obj: Object = _dicScript[_currentFrame][i];
					if (obj.script is Function)
					{
						if (obj.params != null)
						{
							obj.script(obj.params);
						}
						else
						{
							obj.script();
						}
					}
				}
			}
		}
		
		/**对目标索引位置的位图进行绘制*/
		private function draw():void
		{
			if (!isCompleted)
				return ;
			
			var cvo: ClipVO = _vecBmd[_currentFrame];
			if(cvo)
			{
				_img.bitmap.bitmapData = cvo.data;
				super.x = _x + cvo.offsetX;
				super.y = _y + cvo.offsetY;
			}
			else
			{
				_img.bitmap.bitmapData  = null;
			}
		}
		
		public function addFrame(): void
		{
			//
		}
		
		/**添加帧脚本
		 * @param parameters 所在帧数，执行函数，参数传递，。。。
		 */		
		public function addFrameScript(...parameters):void
		{
			if (parameters)
			{
				var len: int = parameters.length;
				if (len < 3)
				{
					throw new ArgumentError("参数个数不能少于3");
					return ;
				}
				if (len % 3 != 0)
				{
					throw new ArgumentError("参数个数必须是3的倍数");
					return ;
				}
				
				_dicScript ||= new Dictionary();
				for (var i: int = 0; i < len; i+=3)
				{
					var f: String = parameters[i];//帧
					var s: Function = parameters[i + 1];//脚本
					if (s == null)
					{
						if (_dicScript[f])
						{
							_dicScript[f] = null ;
							delete _dicScript[f];
						}
					}
					else
					{
						var p: Array = parameters[i + 2];//参数
						_dicScript[f] ||= [];
						var obj: Object = new Object();
						obj.script = s;
						obj.params = p;
						_dicScript[f].push(obj);
					}
				}
			}
			//end
		}
		
		public function setDownUpStyle(): void
		{
			this.gotoAndStop(1);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onUpAndDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, onUpAndDownHandler);
		}
		
		public function onUpAndDownHandler(e: MouseEvent): void
		{
			if (e.type == MouseEvent.MOUSE_UP)
			{
				this.gotoAndStop(1);
			}
			else
			{
				this.gotoAndStop(2);
			}
		}
		
		/**从 MovieClip 文件加载的帧数。
		 * 可以使用 framesLoaded 属性来确定特定帧及其前面所有帧的内容是否已经加载。可以使用它监视大 MovieClip 文件的加载。
		 * 例如，可能需要向用户显示一条消息以表明在完成 MovieClip 文件中指定帧的加载前，MovieClip 文件将会一直进行加载绘制。 
		 * <br><br>如果影片剪辑包含多个场景，framesLoaded 属性会返回为影片剪辑中所有 场景加载的帧数。*/
		public function get frameLoaded():int
		{
			return _frameLoaded;
		}
		
		public function get totalFrames(): int
		{
			return _vecBmd.length;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function get bitmapData(): BitmapData
		{
			return _img.bitmap.bitmapData;
		}
		
		public function get params():Array
		{
			return _params;
		}
		
		override public function get x(): Number
		{
			return _x;
		}
		
		override public function get y(): Number
		{
			return _y;
		}
		
		override public function set x(value: Number):void
		{
			_x = value;
			if (!isCompleted)
			{
				super.x = value;
				return ;
			}
			checkFrame(_currentFrame);
			draw();
		}
		
		override public function set y(value: Number):void
		{
			_y = value;
			if (!isCompleted)
			{
				super.y = value;
				return ;
			}
			checkFrame(_currentFrame);
			draw();
		}
		
		override public function set buttonMode(value:Boolean):void
		{
			super.buttonMode = value;
			this.mouseEnabled = value;
			this.mouseChildren = value;
		}
		
		public function set data(value: Object):void
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



import flash.display.BitmapData;

/**帧位图数据*/	
class ClipVO
{
	public var data: BitmapData;
	public var offsetX: Number;
	public var offsetY: Number;
	
	public function ClipVO()
	{
		super();
	}
}