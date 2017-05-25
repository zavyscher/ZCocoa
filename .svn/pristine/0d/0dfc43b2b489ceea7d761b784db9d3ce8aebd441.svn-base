package com.core.net
{
	import com.core.utils.LongUtil;
	
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	
	public class GCManager
	{
		
		public static var index:Dictionary = new Dictionary();
		public static var protocol:Dictionary = new Dictionary();
		
		public static function init(pro:Dictionary):void{
			for(var key:* in pro){
				protocol[key] = pro[key];
			}
		}
		
		public static function registerMessage(cl:Class):void {
			new cl(index);
		}
		
		public static function read(cmd:int,data:IDataInput):void {
			var flag:Array;
			if(cmd==555){// 广播特殊处理
				flag = protocol[cmd];
				var id:int = data.readShort();
//				BroadCastData.broadCastId = id;
				var ss:String="";
				var ssArr:Array = ss.split("-");
				var len:int = ssArr.length;
				flag = [];
				if(ss=="N"){
					index[cmd](flag);
					return;
				}
				for(var i:int=0;i<len;i+=1){
					flag.push(ssArr[i]);
				}
			}
			else{
				flag = protocol[cmd];
			}
//			trace("cmd ", cmd)
			if(!flag)return;
			var result:Array = dealData(flag,data);
			var fun:Function = index[cmd];
			if(index[cmd]) {
//				if(Utils.addWPF != null)
//				{
//					Utils.addWPF(cmd,result,2);
//				}
				index[cmd](result);	
			}
		}
		
		private static var readDic:Dictionary = function():Dictionary {
			var dic:Dictionary = new Dictionary();
			dic["I"] = "readInt";
			dic["S"] = "readShort";
			dic["B"] = "readByte";
			dic["U"] = "readUTF";
			return dic;
		}();
		private static function invoke(fl:String):String {
			return readDic[fl];
		}
		
		private static function dealData(flag:Array, info:IDataInput):Array {
			var result:Array = [];
			var len:int = flag.length;
			for(var i:int = 0;i<len;i++) {
				if(flag[i] is Array) {
					result.push(explainData(flag[i],info));	
				}else {
					if(flag[i] == "")continue;
					if(flag[i] =="L"){
						result.push(LongUtil.readLong(info));
					}else if(flag[i] =="N"){
						var bit:int = info.readByte();
						if(bit == 4){
							result.push(LongUtil.readLong(info));
						}else if(bit == 3){
							result.push(info.readInt());
						}else if(bit == 2){
							result.push(info.readShort());
						}else if(bit == 1){
							result.push(info.readByte());
						}
					}
					else{
						result.push(info[invoke(flag[i])]());
					}
				}
			}
			return result;
		}
		
		private static function explainData(flag:Array,info:IDataInput):Array {
			var arr:Array = [];
			var len:int = flag.length;
			var arrLen:int = info.readShort();
			for(var j:int = 0;j<arrLen;j++) {
				var itemArr:Array = [];
				for(var i:int = 0;i < len; i++) {
					if(flag[i] is Array) {
						itemArr.push(explainData(flag[i],info));
					}else {
						if(flag[i] =="L"){
							itemArr.push(LongUtil.readLong(info));
						}else if(flag[i] =="N"){
							var bit:int = info.readByte();
							if(bit == 4){
								itemArr.push(LongUtil.readLong(info));
							}else if(bit == 3){
								itemArr.push(info.readInt());
							}else if(bit == 2){
								itemArr.push(info.readShort());
							}else if(bit == 1){
								itemArr.push(info.readByte());
							}
						}else{
							itemArr.push(info[invoke(flag[i])]());
						}
					}
				}
				arr.push(itemArr);
			}
			return arr;
		}
		
	}
}