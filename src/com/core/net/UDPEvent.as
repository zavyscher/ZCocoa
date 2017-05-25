package com.core.net
{
	import com.core.event.ParamEvent;
	
	import flash.events.Event;
	
	/**
	 *@author leetn-dmt-zavy
	 */
	public class UDPEvent extends ParamEvent
	{
		public static const RECIEVED_DATA: String = "recieved_data";
		
		public function UDPEvent(type:String, param: Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, param, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new UDPEvent(type, data);
		}
		//
	}
}


