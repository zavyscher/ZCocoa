package com.core.utils
{
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class TimerUtil
	{
		public static var tasks:Dictionary = new Dictionary();
		
		/**{key, func, exec, resetTime, delay}*/
		private static var dicTimer: Dictionary = new Dictionary();
		
		/**添加(帧)循环执行函数
		 * @param fun 回调函数(now:int):void
		 * @param delayTime 执行时间间隔
		 * @param startTime 开始时间(如:getTimer)
		 * @param params （附件）Object，如传递了该参数，在执行循环处理器时，需在参数增加该参数，如：fname(now: int, param: Object)
		 */
		public static function add(fun:Function, delayTime:int = 0, startTime:int = 0, params: Object = null):void
		{
			var dic: Dictionary = tasks;
			var obj: * = fun;
			tasks[obj] = [fun, startTime, delayTime, params];
		}
		
		public static function run(e:Event):void
		{
			var now:int = getTimer();
			for each (var task:Array in tasks)
			{
				if ((now - task[1]) < task[2])
					continue;
				if (task[3] == null)
				{
					task[0](now);
				}
				else
				{
					task[0](now, task[3]);
				}
				task[1] = now;
			}
		}
		
		/**移除循环函数
		 * @param func
		 */
		public static function remove(func:Function):void
		{
			var dic: Dictionary = tasks;
			delete tasks[func];
		}
		
		/**检测是否已存在该func
		 * @param func
		 * @return 
		 */
		public static function has(func:Function):Boolean
		{
			return tasks[func] ? true : false;
		}
		
		/**设置计时器(自带销毁)
		 * @param exec 执行器
		 * @param key 计时器键名
		 * @param delay 执行延迟（毫秒）
		 * @param allowRepeat 允许重复添加计时器
		 */		
		public static function setTimer(exec: Function, key: String, delay: Number = 5 * 60 * 1000, allowRepeat: Boolean = false): void
		{
			var func: Function = function (now: int, param: Object = null): void{
				if (!param.key)
				{
					remove(arguments.callee);
					return ;
				}
				
				if (!dicTimer[param.key])
				{
					remove(arguments.callee);
					return ;
				}
				
				if (now - param.resetTime > param.delay)
				{
					if (param.exec is Function)
					{
						param.exec(param);
					}
					remove(param.func);
					delete dicTimer[param.key];
				}
			};
			if (!allowRepeat && dicTimer[key])
			{
				remove(dicTimer[key].func);
				delete dicTimer[key];
			}
			dicTimer[key] = {key: key, func : func, exec : exec, resetTime : getTimer(), delay : delay};
			add(func, 0, 0, dicTimer[key]);
		}
		//
	}
}


