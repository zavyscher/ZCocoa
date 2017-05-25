package com.core.utils
{
	import com.components.ZView;
	import com.core.manager.StageManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**使用前必须将parentContainer添加到目标容器上
	 * @author leetn-zavyscher
	 */	
	public class Broadcast
	{
		private static var alertDic:Dictionary = new Dictionary;
		private var viewerVec:Vector.<Text>;
		private var dieVec:Vector.<Text>;
		
		public static const UP:int = 1;
		public static const CENTER:int = 2;
		public static const DOWN:int = 3;
		public static const RIGHT_DOWN:int = 4;
		public static const UI:int = 5;
		public static const SYSTEM_UP:int = 6;
		
		private static const MAX_NUMBER:int = 3;//数量
		private static const UPDATEDELAY:int = 15; //更新间隔
		private static const DIEDELAY:int = 4000; //默认死亡时间
		private static const OUTTIME:int = 2500; //死亡淡出时间
		private static const OFFSET:int = 30; //几个文字定位的Y轴间隔
		private static var  POSY:int = 128; //出生的偏移
		private var outSpeed:Number = 6; //淡出时Y轴速度
		private var outAlpha:Number = 0.05; //淡出A时LPHA淡出速度
		private var lastUpdateTime:int = 0; //上次更新
		
		public var isCanDispose:Boolean = true;
		public var key:Object;
		private var pos:int;
		
		/**提示广播的父容器*/
		public static const parentContainer: ZView = new ZView();
		
		private static var pool:Vector.<Broadcast> = new Vector.<Broadcast>();
		public static function getInstance():Broadcast
		{
			return pool.length ? pool.shift() : new Broadcast();
		}
		
		public function Broadcast()
		{
			viewerVec = new Vector.<Text>;
			dieVec = new Vector.<Text>;
		}
		
		public static function show(message:Object, pos:int = UP, container:DisplayObjectContainer = null):void
		{
//			if(message != null)
//				return;
			
			var alert:Broadcast = (!container) ? alertDic[pos] : alertDic[container];
			if(!alert)
			{
				alert = Broadcast.getInstance();
				if(!container)
				{
					alertDic[pos] = alert;
					alert.isCanDispose = false;
				}
				else
				{
					alertDic[container] = alert;
					alert.key = container;
				}
			}
			var text:Text = alert.addMsg(message, pos);
			text.pose = 128;
			if(!container)
			{
				text.x = (StageManager.width - text.textWidth) >> 1;
				if(pos == UP)
				{
					text.offectY = 150;
					text.pose = 28;
				}
				else if(pos == CENTER)
				{
					text.offectY = (StageManager.height >> 1) - 30 - 50;
					text.pose = -80;
				}
				else if(pos == DOWN)
				{
					text.offectY = StageManager.height - 150;
					text.pose = 58;
				}
				else if(pos == RIGHT_DOWN)
				{
					text.x = (StageManager.width >> 2) + ((StageManager.width - text.textWidth) >> 1);
					text.offectY = (StageManager.height >> 1) + 100;
				}
				else if(pos == SYSTEM_UP)
				{
					text.offectY = 120;
					text.pose = 58;
				}
				
				if (parentContainer.parent)
				{
					parentContainer.addChild(text);
				}
				else
				{
					trace("父容器未初始化");
				}
			}
			else
			{
				text.x = container.width >> 1;
				text.offectY = container.height >> 2;
				container.addChild(text);
			}
			text.y = text.pose;
			
		}
		
		private function addMsg(message: Object, pos: int): Text
		{
			var text:Text = Text.getInstance();
			text.updateTime = getTimer();
			if(pos == SYSTEM_UP)
			{
				text.size = 16;
			}
			else
			{
				text.size = 13;
			}
			if (message is String == false)
			{
				text.htmlText = message.toString();
			}
			else
			{
				text.htmlText = message + "";
			}
			text.width = text.textWidth + 5;
			if((pos == UP || pos == DOWN || pos == CENTER || pos == RIGHT_DOWN) && message != "")
			{
				text.addBg();
			}
			viewerVec.unshift(text);
			start();
			return text;
		}
		
		private function run(now:uint, param: Object = null):void
		{
			var text:Text;
			//超出特定数量时，将前面强制淡出
			if(viewerVec.length > MAX_NUMBER)
			{
				for(var i:int = viewerVec.length - 1; i >= MAX_NUMBER; i--)
				{
					viewerVec[i].updateTime = now;
					dieVec.push(viewerVec[i]);
					viewerVec.splice(i, 1);
				}
			}
			//计时器到期,更新位置
			if(now - lastUpdateTime >= UPDATEDELAY) 
			{
				lastUpdateTime = now;
				for(var index:int = viewerVec.length - 1; index >= 0; index--) 
				{
					if(now - viewerVec[index].updateTime >= DIEDELAY) 
					{
						viewerVec[index].updateTime = now;
						dieVec.push(viewerVec[index]);
						viewerVec.splice(index, 1);
						continue;
					}
					text = viewerVec[index];
					var dis:Number = -OFFSET * index - text.pose;
					if(text.y <= dis) 
					{
						continue;
					} 
					else 
					{
						var temp:Number = dis - text.y;
						var speed:Number = int(temp / 10) + 1;
						text.y += speed;
					}
				}
				for each(text in dieVec) 
				{
					text.alpha -= outAlpha;
					if(text.offectY != 150 &&text.offectY != 120){//上面的直接透明淡出，不用y轴移动
						text.y -= outSpeed;
					}
					if(text.alpha <= 0) 
					{
						dieVec.splice(dieVec.indexOf(text), 1);
						if(text.parent)
						{
							text.parent.removeChild(text);
						}
						text.dispose();
					}
				}
				if(viewerVec.length == 0 && dieVec.length == 0) 
				{
					stop();
				}
			}
		}
	
		private var isStart:Boolean = false;
		public function start():void
		{
			if(isStart == false){
				isStart = true;
				TimerUtil.add(run);
			}
			
		}
		public function stop():void 
		{
			isStart = false;
			TimerUtil.remove(run);
			if(isCanDispose == true)
			{
				dispose();
			}
		}
		
		public function dispose():void
		{
			pool.push(this);
			delete alertDic[key];
		}
	}
}
import com.components.ZImageView;
import com.core.utils.Broadcast;

import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class Text extends TextField
{
	
	private static const FILTER_BLACK:Array = [new GlowFilter(0x000000, 1, 2, 2, 5)];
	
	public var updateTime:int;
	private var _offectY:int;
	private var textFormat:TextFormat;
	private static var pool:Vector.<Text> = new Vector.<Text>();
	public var pose:int;
	
	private var imgBg: ZImageView;
	
	public static function getInstance():Text
	{
		return pool.length ? pool.shift() : new Text();
	}
	
	public function Text()
	{
		textFormat = new TextFormat;
		textFormat.align = TextFormatAlign.CENTER;
		textFormat.bold = true;
		textFormat.font = "SimSun";
		textFormat.color = 0xffffff;
		textFormat.italic = false;
		textFormat.leading = 0;
		textFormat.bold = false;
		textFormat.size = 13;
		textFormat.underline = false;
		textFormat.letterSpacing = 0;
		defaultTextFormat = textFormat;
		this.wordWrap = false;
		this.mouseEnabled = false;
		this.filters = FILTER_BLACK;
	}
	
	public function addBg():void
	{
		if (Broadcast.parentContainer.parent)
		{
			imgBg = new ZImageView();
			imgBg.graphics.beginFill(0x000000, 0.8);
			imgBg.graphics.drawRoundRect(0, 0, this.width + 10, 25, 5, 5);
			imgBg.graphics.endFill();
			Broadcast.parentContainer.addChild(imgBg);
		}
	}
	
	public function set size(value:int):void
	{
		textFormat.size = value;
		defaultTextFormat = textFormat;
	}
	
	public function set offectY(value:int):void
	{
		_offectY = value;
	}
	
	public function get offectY():int
	{
		return _offectY;
	}
	
	override public function set x(value:Number):void
	{
		super.x = value;
		if(imgBg)
		{
			imgBg.x = value - 6;
		}
	}
	
	override public function get y():Number
	{
		return super.y - offectY;
	}
	
	override public function set y(value:Number):void
	{
		super.y = value + offectY;
		if(imgBg)
		{
			imgBg.y = value + offectY - 3;
		}
	}
	
	public function dispose():void
	{
		updateTime = 0;
		alpha = 1;
		offectY = 0;
		pool.push(this);
		this.text = "";
		if(imgBg)
		{
			imgBg.removeFromSuperView();
			imgBg.image = null;
		}
	}
}