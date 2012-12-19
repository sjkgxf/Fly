package com.jiuji.fly.as3.model.feature
{
	import com.jiuji.fly.as3.model.BaseModel3D;
	
	import flash.events.Event;
	
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	import flare.system.Device3D;
	import flare.system.Input3D;
	
	public class RotateFeature extends BaseFeature
	{
		private var rotationPivot:Pivot3D = new Pivot3D();
		
		public function RotateFeature(model:BaseModel3D)
		{
			super(model);
		}
		
		override public function enable():void
		{
			rotationPivot.copyTransformFrom(model);
			
			Device3D.scene.addEventListener(Scene3D.UPDATE_EVENT, updateEventHandler);
		}
		
		protected function updateEventHandler(event:Event):void
		{
			rotationPivot.rotateY(-Input3D.mouseXSpeed);
			
			if (Math.abs(rotationPivot.getRotation().y - 90) <= 10)
				model.setRotation(model.getRotation().x, 90, model.getRotation().z);
			else if (Math.abs(rotationPivot.getRotation().y + 90) <= 10)
				model.setRotation(model.getRotation().x, -90, model.getRotation().z);
			else if (Math.abs(rotationPivot.getRotation().y - 180) <= 10)
				model.setRotation(model.getRotation().x, 180, model.getRotation().z);
			else if (Math.abs(rotationPivot.getRotation().y) <= 10)
				model.setRotation(model.getRotation().x, 0, model.getRotation().z);
			else
				model.rotateY(-Input3D.mouseXSpeed);
		}
		
		override public function disable():void
		{
			Device3D.scene.removeEventListener(Scene3D.UPDATE_EVENT, updateEventHandler);
			super.disable();
		}
	}
}