package com.core.pool
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class ObjectPool
	{
		private static var _dic:Dictionary = new Dictionary();
		
		public static function getObjectByClass(cl:Class, ...ags):*
		{
			var result:Object;
			var className:String = getQualifiedClassName(cl);
			var pool:Array = _dic[className];
			if(pool == null)
			{
				pool = [];
				_dic[className] = pool;
			}
			if (pool.length > 0) 
			{
				result = pool.pop();
			}
			if (result == null)
			{
				if(ags != null && ags.length > 0)
				{
					result = new cl(ags);
				}
				else
				{
					result = new cl();
				}
			}
			return result;
		}
		
		public static function recycle(obj:Object):void
		{
			var className:String = getQualifiedClassName(obj);
			var pool:Array = _dic[className];
			if(pool == null)
			{
				pool = [];
				_dic[className] = pool;
			}
			if (pool.length < 100 && pool.indexOf(obj) == -1)
			{
				pool.push(obj);
			}
		}
		
		public static function removePool(obj:Object):void
		{
			var className:String = getQualifiedClassName(obj);
			var pool:Array = _dic[className];
			delete _dic[className];
		}
	}
}