package com.core.manager
{
	import com.core.coreGraphics.CGSize;
	import com.core.utils.TimerUtil;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public final class StageManager
	{
		/**[1920, 1080]自适应缩放比例计算的尺寸*/
		public static var MAX_SIZE: CGSize;
		private static var _stage:Stage;
		
		private static var startTime:int;
		private static var framesNumber:Number = 0;
		private static var sound:Sound = new Sound();
		private static var soundChannel:SoundChannel;
		public static var isModifyMode: Boolean = false;
		public static var openScreenSaverMode: Boolean = false;
		private static var onActivations: Dictionary;
		private static var onDeactivations: Dictionary;
		private static var onMouseMoves: Dictionary;
		
		public function StageManager()
		{
		}

		public static function get stage():Stage
		{
			return _stage;
		}

		public static function init(originStage:Stage, urlVersionDic:Dictionary):void
		{
			_stage = originStage;
			_stage.frameRate = 30;
			_stage.tabChildren = false;
			_stage.stageFocusRect = false;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.SHOW_ALL;
			_stage.addEventListener(Event.RESIZE, resize);
			_stage.addEventListener(Event.ENTER_FRAME, TimerUtil.run);
//			KeyBoardManager.init(stage);
			
			sound = new Sound(new URLRequest(""));
			sound.play();
			sound.close();
			
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler, false, 0, true);
			_stage.addEventListener(Event.ACTIVATE, onActivate);
			_stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private static function fps(now:int, param: Object = null):void
		{
			var currentTime:Number = (now - startTime) / 1000;
			framesNumber++;
			if (currentTime > 1)
			{
				startTime = now;
				var frame:int = (Math.floor((framesNumber / currentTime) * 10.0) / 10.0);
				framesNumber = 0;
				if(frame > 7)
				{
					deactivate();
				}
				else
				{
					activate();
				}
			}
		}
		
		private static function onSampleDataHandler(e: SampleDataEvent):void
		{
			e.data.position = e.data.length = 4096 * 4;
		}
		
		private static function onActivate(e:Event):void
		{
			TimerUtil.remove(fps);
			deactivate();
			
			onActivations ||= new Dictionary();
			
			for (var flag: String in onActivations)
			{
				if (onActivations[flag] && onActivations[flag].func is Function)
				{
					onActivations[flag].func();
					if (onActivations[flag].isDisposable)
						onActivations[flag] = null;
				}
			}
		}
		
		private static function onDeactivate(e:Event):void
		{
			if(isModifyMode)
			{
				deactivate();
				var current:int = getTimer();
				startTime = current + 3000;
				framesNumber = 0;
				TimerUtil.add(fps, 0, current + 3000);
				
				onDeactivations ||= new Dictionary();
				
				for (var flag: String in onDeactivations)
				{
					if (onDeactivations[flag] && onDeactivations[flag].func is Function)
					{
						onDeactivations[flag].func();
						if (onDeactivations[flag].isDisposable)
							onDeactivations[flag] = null;
					}
				}
			}
		}
		
		private static function onMouseMove(e: MouseEvent): void
		{
			if (openScreenSaverMode)
			{
				onMouseMoves ||= new Dictionary();
				
				for (var flag: String in onMouseMoves)
				{
					if (onMouseMoves[flag] && onMouseMoves[flag].func is Function)
					{
						onMouseMoves[flag].func();
						if (onMouseMoves[flag].isDisposable)
							onMouseMoves[flag] = null;
					}
				}
			}
		}
		
		private static function activate():void
		{
			if (soundChannel || isModifyMode == false) return;
			soundChannel = sound.play();
		}
		
		private static function deactivate():void
		{
			if (!soundChannel) return;
			soundChannel.stop();
			soundChannel = null;
		}
		
		private static function resize(... args):void
		{
		}
		
		/**
		 * @param func 执行方法
		 * @param isDisposable 是否一次性
		 */		
		public static function addActivation(flag: String, func: Function, isDisposable: Boolean):void
		{
			var obj: Object = new Object();
			obj.func = func;
			obj.isDisposable = isDisposable;
			onActivations[flag] = obj;
		}
		
		public static function removeActivation(flag: String): void
		{
			if (!onActivations || onActivations[flag] == undefined)
				return;
			
			onActivations[flag] = null;
			delete onActivations[flag];
		}
		
		/**
		 * @param func 执行方法
		 * @param isDisposable 是否一次性
		 */		
		public static function addDeactivation(flag: String, func: Function, isDisposable: Boolean):void
		{
			var obj: Object = new Object();
			obj.func = func;
			obj.isDisposable = isDisposable;
			onDeactivations[flag] = obj;
		}
		
		public static function removeDeactivation(flag: String): void
		{
			if (!onDeactivations || onDeactivations[flag] == undefined)
				return;
			
			onDeactivations[flag] = null;
			delete onDeactivations[flag];
		}
		
		/**
		 * @param func 执行方法
		 * @param isDisposable 是否一次性
		 */		
		public static function addMouseMove(flag: String, func: Function, isDisposable: Boolean):void
		{
			var obj: Object = new Object();
			obj.func = func;
			obj.isDisposable = isDisposable;
			onMouseMoves[flag] = obj;
		}
		
		public static function removeMouseMove(flag: String): void
		{
			if (!onMouseMoves || onMouseMoves[flag] == undefined)
				return;
			
			onMouseMoves[flag] = null;
			delete onMouseMoves[flag];
		}
		
		public static function get width(): Number
		{
			if (_stage)
			{
				return _stage.stageWidth;
			}
			return 0;
		}
		
		public static function get height(): Number
		{
			if (_stage)
			{
				return _stage.stageHeight;
			}
			return 0;
		}
		
		public static function get halfWidth(): Number
		{
			if (_stage)
			{
				return _stage.stageWidth >> 1;
			}
			return 0;
		}
		
		public static function get halfHeight(): Number
		{
			if (_stage)
			{
				return _stage.stageHeight >> 1;
			}
			return 0;
		}
	}
}


