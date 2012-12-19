package com.jiuji.fly.as3.model.feature
{
	import com.jiuji.fly.as3.model.BaseModel3D;
	
	import flare.events.MouseEvent3D;

	public class ClickFeature extends BaseFeature
	{
		public function ClickFeature(model:BaseModel3D)
		{
			super(model);
		}
		
		override public function enable():void
		{
			model.addEventListener(MouseEvent3D.CLICK, onModelClick);
		}
		
		private function onModelClick(event:MouseEvent3D):void
		{
			model.dispatchEvent(event);
		}
		
		override public function disable():void
		{
			model.removeEventListener(MouseEvent3D.CLICK, onModelClick);
			super.disable();
		}
	}
}