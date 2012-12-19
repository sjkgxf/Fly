package com.jiuji.fly.as3.events
{
	import flash.events.Event;
	
	public class ModelRelatedEvent extends Event
	{
		public static const MODEL_CLICK:String = "modelClick";
		
		public function ModelRelatedEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new ModelRelatedEvent(type);
		}
	}
}