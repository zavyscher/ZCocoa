package com.core.utils
{
	import com.core.resourse.DefaultResPath;
	import com.core.resourse.ZLoader;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class Checker
	{
		public static const WINDOWS: int = 0;
		public static const ANDROID: int = 1;
		public static const IOS: int = 2;
		
		public static const AUTHOR_NAME: String = "leetn-dmt-zavy";
		public static var validFile: Object;
		
		public function Checker()
		{
		}
		
		public static function get currentOS(): int
		{
			var system: String = Capabilities.os;
			if (system.indexOf("IPHONE") > 0)
			{
				return IOS;
			}
			else if (system.indexOf("ANDROID") > 0)
			{
				return ANDROID;
			}
			else if (system.indexOf("WINDOWS") > 0)
			{
				return WINDOWS;
			}
			return -1;
		}
		
		public static function getValidDate(projectName: String): Boolean
		{
			return false;
		}
		
		public static function getXXXX(completion: Function): void
		{
			var currentDate: String = DateUtil.getCurrentDateStr(false);
			var temFile: File = new File(File.applicationDirectory.resolvePath(DefaultResPath.LOCAL_URL + "data/zzz").nativePath);
			validFile = new Object();
			validFile.date = DateUtil.getCurrentDateStr(true).split("/");
			var fileStream: FileStream = new FileStream();
			fileStream.open(temFile, FileMode.WRITE);
			fileStream.writeInt(validFile.date[0]);
			fileStream.writeInt(validFile.date[1]);
			fileStream.writeInt(validFile.date[2]);
			fileStream.close();
			ZLoader.add(DefaultResPath.LOCAL_URL + "data/zzz",
				function(info:Object):void
				{
					var byte: ByteArray = info.data as ByteArray;
					var isValid: Boolean = DateUtil.isValidDate(byte.readInt() >> 132, byte.readInt() >> 9299, byte.readInt() >> 9929);
				}
			);
		}
		//
	}
}


