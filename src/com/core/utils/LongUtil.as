package com.core.utils
{
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	
	public class LongUtil
	{
		public static const BIT32NUM:Number = Math.pow(2,32);
		
		private static var converDic:Dictionary;
		
		private static var _isInit:Boolean = false;
		public static function readLong(bytes:IDataInput):Number
		{ 
			if(!_isInit){
				initConverDic();
			}
			var long:String = "";
			for (var i:int = 0; i < 8; i++)
			{
				var numStr:String = bytes.readUnsignedByte().toString(16);
				var hexStr:String;
				hexStr = numStr.length == 1 ? "0" + numStr : numStr;
				long += hexStr;
			}
			
			var isFu:Boolean = parseInt("0x"+long.substr(0,1)) > 7;
			if(isFu)
			{
				var newLong:String = "";
				for(i = 0;i<long.length;i++) {
					newLong += converDic[long.charAt(i)];
				}
				return -1 * (parseInt("0x"+newLong) + 1);
			}else {
				return parseInt("0x"+long);
			}
		}
		
		public static function writeLong(bytes:IDataOutput, value:Number):void
		{
			var isFu:Boolean = value < 0;
			if(value < 0) value += 1;
			
			var str:String = value.toString(16);
			if(isFu) {
				str = str.substr(1);
			}
			
			var lgth:int = 16 - str.length;
			for( var i:int = 0; i < lgth; i++)
			{
				str = "0" + str;
			}
			
			var subStr:String;
			if(isFu) {
				var str2:String = "";
				for(i = 0;i<str.length;i++) {
					str2 += converDic[str.charAt(i)];
				}
				
				subStr = str2.substr( 0, 8);
				bytes.writeInt( parseInt('0x'+subStr));
				subStr = str2.substr( 8, 8);
				bytes.writeInt( parseInt('0x'+subStr));
			}else {
				subStr = str.substr( 0, 8);
				bytes.writeInt( parseInt('0x'+subStr));
				subStr = str.substr( 8, 8);
				bytes.writeInt( parseInt('0x'+subStr));
			}
		}
		
		public static function initConverDic():void {
			converDic = new Dictionary();
			converDic["0"] = "f";
			converDic["1"] = "e";
			converDic["2"] = "d";
			converDic["3"] = "c";
			converDic["4"] = "b";
			converDic["5"] = "a";
			converDic["6"] = "9";
			converDic["7"] = "8";
			converDic["8"] = "7";
			converDic["9"] = "6";
			converDic["a"] = "5";
			converDic["b"] = "4";
			converDic["c"] = "3";
			converDic["d"] = "2";
			converDic["e"] = "1";
			converDic["f"] = "0";
		}
		
	}
}