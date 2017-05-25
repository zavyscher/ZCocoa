package com.core.event
{
	import com.core.utils.Singleton;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ParamTransferStation extends EventDispatcher
	{
		private static var _dicParam: Array = [];
		
		public static function get instance(): ParamTransferStation {
			return Singleton.getInstance(ParamTransferStation);
		}
		
		public function ParamTransferStation()
		{
			super();
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			_dicParam[event.type] ||= [];
			return super.dispatchEvent(event);
		}
		//
	}
}


