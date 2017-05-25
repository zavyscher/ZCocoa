package com.components.custom
{
	import com.core.manager.StageManager;
	import com.core.pool.ObjectPool;
	import com.core.utils.TimerUtil;
	import com.interfaces.IAnimator;
	
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	
	/**<h4 >动画驱动器（单例化单元式）</h4>
	 * <b>使用方法：</b>添加目标addAnimator -> 驱动动画animate（自动停止）<br/>
	 * 支持用点(.)语法无限链，<i>如：Animation.instance.addAnimator(_mainSwc).animate({"x": 20}, "slow").animate({"x": 40}, "fast").animate({"x": 20}, 1000);</i>
	 * @author leetn-dmt-zavy
	 */
	public class Animation implements IAnimator
	{
		/**SLOW:600; NORMAL:400; FAST:200*/
		public static const SLOW: int = 600;
		/**SLOW:600; NORMAL:400; FAST:200*/
		public static const NORMAL: int = 400;
		/**SLOW:600; NORMAL:400; FAST:200*/
		public static const FAST: int = 200;
		/**公共字段*/
		private const EASE: String = "ease";
		private const LOOP: String = "loop";
		private const DELAY: String = "delay";
		private const TARGET: String = "target";
		private const VALUES: String = "values";
		private const START_VALUES: String = "start_values";
		private const ANIMATION: String = "animation";
		private const DURATION: String = "duration";
		private const EACH_DELAY: String = "eachDelay";
		private const START_TIME: String = "startTime";
		private const ON_COMPLETE: String = "onComplete";
		
		/**结构: [ styles :
		 * { ease缓动类型(仍未扩展),
		 * target(目标),
		 * values(渐进值、已渐进总值),
		 * duration(动画时长),
		 * eachDelay(播放间隔),
		 * startTime(动画开始时间),
		 * onComplete(动画完成回调),
		 * ...显示对象属性 } ]*/
		private var _arrAnimation: Array;
		private var _arrLoop: Array;
		
		private var _target: DisplayObject;
		
		private var _isAnimating: Boolean;
		private var _pausing: Boolean;
		
		/**<h4 >动画驱动器（单例化单元式）</h4>
		 * <b>使用方法：</b>添加目标addAnimator -> 驱动动画animate（自动停止）<br/>
		 * 支持用点(.)语法无限链，<i>如：Animation.instance.addAnimator(_mainSwc).animate({"x": 20}, "slow").animate({"x": 40}, "fast").animate({"x": 20}, 1000);</i>
		 */
		public static function get instance(): Animation {
			return ObjectPool.getObjectByClass(Animation);
		}
		
		public function Animation()
		{
			_arrAnimation = [];
		}
		
		public function addAnimator(target:DisplayObject):IAnimator
		{
			_target = target;
			return this;
		}
		
		public function get animationObject(): DisplayObject
		{
			return _target;
		}
		
		/**<b>styles:</b>一组包含作为动画属性和终值的样式属性和及其值的集合<br/>
		 * <b>speed:</b>三种预定速度之一的字符串("slow"600ms,"normal"400ms, or "fast"200ms)或表示动画时长的毫秒数值(如：1000)<br/>
		 * <b>easing:</b>要使用的缓动效果的名称<br/>
		 * <b>callback:</b>在动画完成时执行的函数，每次完成动画后执行一次
		 * */
		public function animate(styles: Object, speed: *, easing: * = null, callback: Function = null):IAnimator
		{
			if (!styles)
			{
				if (callback is Function)
				{
					callback();
				}
				return this;
			}
			
			styles[TARGET] = _target;
			styles[VALUES] = new Object();
			styles[START_VALUES] = new Object();
			
			//动画时长
			if (speed)
			{
				if (speed is Number)
					styles[DURATION] = speed;
				else if (speed is String)
				{
					var numSpeed: int = Animation[String(speed).toUpperCase()];
					if (isNaN(numSpeed))
					{
						numSpeed = NORMAL;
					}
					styles[DURATION] = numSpeed;
				}
				styles[EACH_DELAY] = int(styles[DURATION] / StageManager.stage.frameRate);
			}
			//属性值预备
			for (var key: String in styles)
			{
				if (key == LOOP ||
					key == DELAY ||
					key == TARGET ||
					key == VALUES ||
					key == DURATION ||
					key == EACH_DELAY ||
					key == START_VALUES)
				{
					continue;
				}
				key = (key == "opacity") ? "alpha" : key;
				if (_target.hasOwnProperty(key))//检查是否目标拥有该属性
				{
					var totalVal: Number = styles[key];
					styles[VALUES]["animated_" + key] = 0;
					styles[START_VALUES]["start_" + key] = _target[key];
					if (key != "alpha" && key.indexOf("rotation") < 0 && key.indexOf("scale") < 0)
					{
						styles[VALUES]["each_" + key] = totalVal / styles[DURATION] * StageManager.stage.frameRate;
					}
					else
					{
						styles[VALUES]["each_" + key] = totalVal * 1000 / styles[DURATION] * StageManager.stage.frameRate;
					}
				}
			}
			//缓动效果
			if (easing)
			{
				styles[EASE] = (easing is Array) ? easing : [easing];
			}
			
			styles[START_TIME] = getTimer();
			styles[ON_COMPLETE] = callback;
			_arrAnimation.push(styles);
			
			styles[ANIMATION] = function(now: int, param: Object = null):void
			{
				if (_pausing)
					return ;
				if (now - param[START_TIME] >= uint(param[EACH_DELAY] - param[EACH_DELAY] * 0.1))
				{
					param[START_TIME] = now;
					for (var key: String in param)
					{
						if (key == EASE ||
							key == LOOP ||
							key == DELAY ||
							key == TARGET ||
							key == VALUES ||
							key == START_VALUES ||
							key == DURATION ||
							key == EACH_DELAY ||
							key == START_TIME ||
							key == ON_COMPLETE)
						{
							continue;
						}
						if (param[TARGET].hasOwnProperty(key))//检查是否目标拥有该属性
						{
							var eachVal: Number = param[VALUES]["each_" + key];
							if (key != "alpha" && key.indexOf("rotation") < 0 && key.indexOf("scale") < 0)
							{
								var totalVal: Number = param[key];
								param[TARGET][key] += eachVal;//进行渐进值计算
							}
							else
							{
								totalVal = param[key] * 1000;//如果是透明度，旋转角度，缩放比例的话，乘以1000计算总值
								param[TARGET][key] += eachVal / 1000;//进行渐进值计算
							}
							param[VALUES]["animated_" + key] += eachVal;
							var isComplete: Boolean;
							if ((totalVal <= 0 && param[VALUES]["animated_" + key] <= totalVal) ||
								(totalVal > 0 && param[VALUES]["animated_" + key] >= totalVal) )
							{
								if (param.hasOwnProperty(LOOP) == false)
								{
									if (key != "alpha" && key.indexOf("rotation") < 0 && key.indexOf("scale") < 0)
									{
										param[TARGET][key] = param[START_VALUES]["start_" + key] + totalVal;
									}
									else
									{
										param[TARGET][key] = param[START_VALUES]["start_" + key] + totalVal / 1000;
									}
								}
								
								isComplete = true;
							}
							if (isComplete)
							{
								if (param[ON_COMPLETE] is Function)//此轮动画完成后进行回调
								{
									param[ON_COMPLETE]();
								}
								if (_arrAnimation.length <= 1)
								{
									_isAnimating = false;
									_pausing = false;
									stopAnimate();
									break ;
								}
								if (param[LOOP] != null && param[LOOP] == 0)
								{
									_arrLoop ||= [];
									_arrLoop.push(param);
								}
								TimerUtil.remove(param[ANIMATION]);
								_arrAnimation.shift();
								var newStyle: Object = _arrAnimation[0];
								TimerUtil.add(newStyle[ANIMATION], 0, 0, newStyle);
							}
						}
					}
				}
			};
			
			if (!_isAnimating)
				TimerUtil.add(styles[ANIMATION], 0, 0, styles);
			_isAnimating = true;
			_pausing = false;
			return this;
		}
		
		public function stopAnimate():IAnimator
		{
			if (_isAnimating)
			{
				var len: int = _arrAnimation.length;
				for(var i: int = 1; i < len; i++)//保留正在播放的动画
				{
					_arrAnimation[i] = null ;
				}
			}
			else
			{
				var style: Object = _arrAnimation.shift();
				if (style)
				{
					TimerUtil.remove(style[ANIMATION]);
					
					if (style[LOOP] != null && style[LOOP] == 0)
					{
						_arrLoop ||= [];
						_arrLoop.push(style);
						_arrAnimation = _arrLoop.concat();
						_arrLoop = null ;
						len = _arrAnimation.length;
						for (i = 0; i < len; i++)
						{
							var obj: Object = _arrAnimation[i];
							for (var key: String in obj)
							{
								if (key == EASE ||
									key == LOOP ||
									key == TARGET ||
									key == VALUES ||
									key == DURATION ||
									key == EACH_DELAY ||
									key == START_TIME ||
									key == ON_COMPLETE ||
									key == ANIMATION)
								{
									continue;
								}
								obj[VALUES]["animated_" + key] = 0;
							}
						}
						var nextStyle: Object = _arrAnimation[0];
						TimerUtil.add(nextStyle[ANIMATION], 0, 0, nextStyle);
						_isAnimating = true;
						_pausing = false;
						return this;
					}
					else
					{
						style = null ;
					}
				}
			}
			_arrAnimation = [];
			return this;
		}
		
		public function set pausing(value:Boolean):void
		{
			_pausing = value;
		}
		
		public function get pausing():Boolean
		{
			return _pausing;
		}
		//
	}
}


