package com.core.net
{
	import com.core.utils.LongUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class CGManager
	{
		public static var protocol:Dictionary = new Dictionary();
		
		public static function init(pro:Dictionary):void{
			for(var key:* in pro){
				protocol[key] = pro[key];
			}
		}
		
		public static function socketSend(cmd:int, data:Array):void {
//			if(Utils.addWPF != null)
//			{
//				Utils.addWPF(cmd,data,1);
//			}
			var flag:Array = protocol[cmd];
			var by:ByteArray = write(flag,data);
			SocketManager.send(cmd, by);
		}
		
		private static var writeDic:Dictionary = function():Dictionary {
			var dic:Dictionary = new Dictionary();
			dic["I"] = "writeInt";
			dic["S"] = "writeShort";
			dic["B"] = "writeByte";
			dic["U"] = "writeUTF";
			return dic;
		}();
		private static function writeInvoke(fl:String):String {
			return writeDic[fl];
		}
		
		public static function write(flag:Array,data:Array):ByteArray {
			var bytearray:ByteArray = new ByteArray();
			var len:int = 0;
			if(flag)len = flag.length;
			if(data){
				for(var i:int = 0;i<len;i++) {
					if(flag[i] is Array) {
						bytearray.writeBytes(writeData(flag[i],data[i]));
					}else {
						if(flag[i] =="L"){
							LongUtil.writeLong(bytearray,data[i]);
						}
						else if(flag[i] =="N"){
							var value:Number = data[i];
							if(value > int.MAX_VALUE || value < int.MAX_VALUE*-1){
								bytearray.writeByte(4);
//								bytearray.writeDouble(value);
								LongUtil.writeLong(bytearray,data[i]);
							}else if(value>32767 ||value<-32768){
								bytearray.writeByte(3);
								bytearray.writeInt(value);
							}else if(value>127||value<-128){
								bytearray.writeByte(2);
								bytearray.writeShort(value);
							}else{
								bytearray.writeByte(1);
								bytearray.writeByte(value);
							}
						}
						else{
							bytearray[writeInvoke(flag[i])](data[i]);
						}
					}
				}
			}
			return bytearray;
		}
		private static function writeData(flag:Array,data:Array):ByteArray {
			var bytearray:ByteArray = new ByteArray();
			var len:int = data.length;
			bytearray.writeShort(len);
			
			var flagLen:int = flag.length;
			for(var j:int = 0;j<len;j++) {
				for(var i:int = 0;i < flagLen; i++) {
					if(flag[i] is Array) {
						bytearray.writeBytes(writeData(flag[i],data[j][i]));
					}else {
						if(flag[i] =="L"){
							LongUtil.writeLong(bytearray,data[j][i]);
						}else if(flag[i] =="N"){
							var value:Number = data[i];
							if(value > int.MAX_VALUE || value < int.MAX_VALUE*-1){
								bytearray.writeByte(4);
								bytearray.writeDouble(value);
							}else if(value>32767 ||value<-32768){
								bytearray.writeByte(3);
								bytearray.writeInt(value);
							}else if(value>127||value<-128){
								bytearray.writeByte(2);
								bytearray.writeShort(value);
							}else{
								bytearray.writeByte(1);
								bytearray.writeByte(value);
							}
						}
						else{
							bytearray[writeInvoke(flag[i])](data[j][i]);
						}
					}
				}
			}
			return bytearray;
		}
		
	}
}