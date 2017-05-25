// ActionScript file
package com.core.utils
{
	import com.hurlant.crypto.symmetric.CBCMode;
	import com.hurlant.crypto.symmetric.DESKey;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	//import com.demonsters.debugger.MonsterDebugger;

	public class Crypt {
		public static function encrypt(data:String, key:String):String {
			var keyBytes:ByteArray = new ByteArray();
			keyBytes.writeUTFBytes(key);
			var pt:ByteArray = Hex.toArray(Hex.fromString(data));
			var des:DESKey = new DESKey(keyBytes);
			var cbc:CBCMode = new CBCMode(des);
			cbc.IV = keyBytes;
			cbc.encrypt(pt);
			return Hex.fromArray(pt);
		}
		
		public static function decrypt(data:String, key:String):String {
			var keyBytes:ByteArray = new ByteArray();
			keyBytes.writeUTFBytes(key);
			var pt:ByteArray = Hex.toArray(data);
			var des:DESKey = new DESKey(keyBytes);
			var cbc:CBCMode = new CBCMode(des);
			cbc.IV = keyBytes;
			cbc.decrypt(pt);
			return Hex.toString(Hex.fromArray(pt));
		}
	}	
}