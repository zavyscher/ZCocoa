package com.core.event
{
	import flash.events.Event;

	public interface IParamDispatcher
	{
		function dispatchEvent(event: Event): Boolean;
	}
}