package com.jiuji.fly.as3.model.feature
{
	import com.jiuji.fly.as3.model.BaseModel3D;
	
	public class BaseFeature
	{
		public static const FEATURE_CLICK:String = "featureCLick";
		
		protected var model:BaseModel3D;
		
		public function BaseFeature(model:BaseModel3D)
		{
			this.model = model;
		}
		
		public function enable():void
		{
			
		}
		
		public function disable():void
		{
			this.model = null;
		}
	}
}