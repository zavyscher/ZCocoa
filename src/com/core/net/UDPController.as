package com.core.net
{
	import com.core.net.UDPEvent;
	import com.core.utils.ComputerClose;
	import com.core.utils.Singleton;
	
	import flash.events.DatagramSocketDataEvent;
	import flash.events.EventDispatcher;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	
	public class UDPController extends EventDispatcher
	{
		public static const UDP_CONNECTED: String = "";
		
		public var udp: DatagramSocket = new DatagramSocket();
		public var UDPClientIP: String;
		public var UDPClientPort: int;
		public var serverIP: String;
		public var serverPort: int;
		public var modeMsg: String = "";
		public var data: String;
		
		public var onRecieveKeyHandler: Function;
		
		public static function get instance(): UDPController {
			return Singleton.getInstance(UDPController);
		}
		
		public function UDPController()
		{
		}
		
		public function bind(localIP: String, localPort: int):void
		{
			if(udp.bound)
			{
				udp.close();
				udp = new DatagramSocket();
			}
			
			try
			{
				udp.bind(localPort, localIP);
				udp.addEventListener(DatagramSocketDataEvent.DATA, onUDPReceiveHandler);
				udp.receive();
				this.dispatchEvent(new UDPEvent(UDPController.UDP_CONNECTED));
				trace("Bound to " + udp.localAddress + ":" + udp.localPort);
				serverIP = udp.localAddress;
				serverPort = udp.localPort;
			}
			catch (e: Error)
			{
				trace(e);
			}
		}
		
		public function send(msg: String, address:String="0.0.0.0", port:int=0): void
		{
			var ba: ByteArray = new ByteArray();
			ba.writeUTFBytes(msg);
			udp.send(ba, 0, ba.bytesAvailable, address, port);
			trace("send to " + address + ":" + port + " >> \"" + msg + "\"");
		}
		
		public function sendByte(ba: ByteArray, address: String = "0.0.0.0", port:int = 0): void
		{
			udp.send(ba, 0, ba.bytesAvailable, address, port);
			trace("send to " + address + ":" + port + " >> \"" + "ByteArray" + "\"");
		}
		
		protected function onUDPReceiveHandler(event: DatagramSocketDataEvent):void
		{
			data = event.data.readUTFBytes(event.data.bytesAvailable);
			trace("Received From " + event.srcAddress + ":" + event.srcPort + " >> " + data);
			if(data == "poweroff")
			{
				ComputerClose.instance.ComClose();
			}
			if (onRecieveKeyHandler is Function)
			{
				onRecieveKeyHandler(data);
			}
			UDPClientPort = event.srcPort;
			UDPClientIP = event.srcAddress;
			var obj: UDPMessageVO = new UDPMessageVO();
			obj.srcPort = event.srcPort;
			obj.srcAddress = event.srcAddress;
			obj.data = event.data;
			obj.UTFBytes = data;
			//响应发送端
			this.dispatchEvent(new UDPEvent(UDPEvent.RECIEVED_DATA, obj));
		}
		
		public function sendMultipleMsg(msg: String, address: String = "0.0.0.0", port: int = 0): void
		{
			var arrMode: Array = msg.split(";");
			var modeLen: int = arrMode.length;
			for (var j: int = 0; j < modeLen; j++)
			{
				var str: String = arrMode[i];
				if (str)
				{
					var decodeStr: Array = str.split(":");
					if (decodeStr[0] == modeMsg)
					{
						var arrMsg: Array = decodeStr[1].split("_");
						var msgLen: int = arrMsg.length;
						for (var i: int = 0; i < msgLen; i++)
						{
							var temMsg: String = arrMsg[i];
							if (temMsg && temMsg != "")
							{
								send(temMsg, address, port);
							}
						}
					}
					else if (decodeStr.length == 1)
					{
						send(decodeStr[0], address, port);
					}
					else
					{
						arrMsg = decodeStr[0].split("_");
						msgLen = arrMsg.length;
						for (i = 0; i < msgLen; i++)
						{
							temMsg = arrMsg[i];
							if (temMsg && temMsg != "")
							{
								send(temMsg, address, port);
							}
						}
					}
				}
			}
			
		}
		//
	}
}


