package com.core.event
{
	import flash.events.Event;
	
	public class ParamEvent extends Event
	{
		public static const PARAM: String = "param";
		
		public var data: Object;
		
		public function ParamEvent(type:String, param: Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = param;
		}
		
		override public function clone():Event
		{
			return new ParamEvent(type, data);
		}
		//
	}
}


