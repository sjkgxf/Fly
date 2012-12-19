package com.jiuji.fly.as3.model
{
	import com.jiuji.fly.as3.model.feature.BaseFeature;
	import com.jiuji.fly.as3.model.feature.ClickFeature;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import flare.basic.Scene3D;
	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;
	
	public class BaseModel3D extends Pivot3D
	{
		private var params:Object;
		private var model:Pivot3D;
		private var labels:Array;
		private var features:Dictionary;
		
		/**
		 * 模型加载类
		 * @param name 模型名字
		 * @param params ex. {
		 * 		name: "xxx",							// 模型名字
		 * 		allowClick: 1,							// 是否允许点击
		 * 		buttonMode: 1,							// 光标是否切换成手型
		 * 		allowRotate: 1,							// 是否允许旋转
		 * 		rotateType: "composite" || "single",	// 旋转类型
		 * 		allowMove: 1,							// 是否允许移动
		 * 		moveType: "drag" || "click",			// 移动类型
		 * 		onlyMesh: 1,							// 是否只有一个Mesh3D生效
		 * 		layerIndex: n,							// 排序层级
		 * 		labels: "name1&xx&xx|name2&xx&xx",		// 动作相关Labels
		 * 		speed: n, (0-1]							// 动作播放速度
		 * 		custom: ""								// 自定义接口
		 * }
		 * 
		 */		
		public function BaseModel3D(url:String = "", params:Object = null)
		{
			if (params && params.name != null)
				super(name);
			
			features = new Dictionary(true);
			
			this.params = params;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onLoadDataComplete);
			urlLoader.load(new URLRequest(url));
		}
		
		private function onLoadDataComplete(event:Event):void
		{
			model = new Flare3DLoader(event.target.data);
			model.addEventListener(Scene3D.COMPLETE_EVENT, loadComplete);
			(model as Flare3DLoader).load();
		}
		
		private function loadComplete(event:Event):void
		{
			model.removeEventListener(Scene3D.COMPLETE_EVENT, loadComplete);
			
			if (params)
			{
				// 是否只有一个 Mesh3D
				if (params.onlyMesh == 1 && model.children)
				{
					for each (var child:Pivot3D in model.children)
					{
						if (child is Mesh3D)
						{
							model = child;
							break;
						}
					}
				}
				
				if (model is Mesh3D)
				{
					// 是否允许点击
					(model as Mesh3D).mouseEnabled = ((params.allowClick == 1) ? true : false);
					// 光标是否切换成手型
					(model as Mesh3D).useHandCursor = ((params.buttonMode == 1) ? true : false);
				}
				
				// 动作相关Labels
				if (params.labels != null)
				{
					labels = [];
					for each (var label:String in (params.labels as String).split("|"))
					{
						var infos:Array = label.split("&");
						this.addLabel(new Label3D(infos[0], infos[1], infos[2]));
						
						labels.push(infos[0]);
					}
					
					if (params.speed != null && params.speed > 0 && params.speed <= 1)
					{
						model.frameSpeed = params.speed;
					}
				}
			}
			
			this.addChild(model);
		}
		
		public function addFeature(...args):void
		{
			for each (var type:String in args)
			{
				if (!features[type])
				{
					switch (type)
					{
						case BaseFeature.FEATURE_CLICK:
							features[type] = new ClickFeature(this);
							break;
					}
				}
			}
		}
		
		public function enableFeature(...args):void
		{
			for each (var type:String in args)
			{
				if (features[type])
				{
					switch (type)
					{
						case BaseFeature.FEATURE_CLICK:
							(features[type] as BaseFeature).enable();
							break;
					}
				}
			}
		}
		
		public function disableFeature(...args):void
		{
			for each (var type:String in args)
			{
				if (features[type])
				{
					switch (type)
					{
						case BaseFeature.FEATURE_CLICK:
							(features[type] as BaseFeature).disable();
							break;
					}
				}
			}
		}
		
		/**
		 * 更换排序层级
		 * @param newIndex
		 * 
		 */		
		public function changeLayer(newIndex:int):void
		{
			if (this.layer == newIndex)
				return;
			
			this.setLayer(newIndex);
		}
		
		/**
		 * 获取自定义变量
		 * @return 
		 * 
		 */		
		public function get custom():String
		{
			if (params != null && params.custom != null)
			{
				return params.custom;
			}
			return null;
		}
	}
}