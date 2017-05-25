package com.core.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class SocketManager {
		
		public static var socket:Socket;
		private static var _localMode:Boolean;
		private static var recvCache:ByteArray = new ByteArray();
		private static var recvArray:ByteArray = new ByteArray();
		private static var data:ByteArray = new ByteArray();
		private static var recvBuf:ByteArray = new ByteArray();
		
		private static var connectHandler:Function;
		private static var closeHandler:Function;
		private static var errorHandler:Function;
		private static var lastCmd:int = 0;
		private static var lastPkgLen:int = 0;
		
		private static var curCmd:int = 0;
		private static var curPkgLen:int = 0;
		private static var ip:String;
		private static var socketPort:int;
		
		
		public static var send:Function = sendServer;
		public static var receive:Function = onConnectStateHandler;
		public static function init(connect:Function, close:Function, error:Function):void {
			connectHandler = connect;
			closeHandler = close;
			errorHandler = error;
		}
		
		public static function connect(host:String, port:int, isClose:Boolean = true):void {
			ip = host;
			socketPort = port;
			if(_localMode) {
				connectHandler();
			}else {
				socket = new Socket();
				socket.addEventListener(Event.CONNECT, onConnectStateHandler);
				socket.addEventListener(Event.CLOSE, onConnectStateHandler);
				socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				if(socket.connected && isClose)socket.close();
				socket.connect(host, port);
				var data:Date = new Date();
			}
		}
		
		public static function set localMode(value:Boolean):void {
			if(value) {
				send = sendLocal;
			}else {
				send = sendServer;
			}
			_localMode = value;
		}
		
		public static function get localMode():Boolean {
			return _localMode;
		}
		
		private static function sendLocal(cmd:int,body:ByteArray):void {
			
		}
		
		private static var _lastRandValue:int;
		private static function getRamdon():int {
			_lastRandValue = _lastRandValue + 1;
			if(_lastRandValue > 127) _lastRandValue = 0;
			return _lastRandValue;
		}
		
		private static function sendServer(cmd:int,body:ByteArray):void {
			if(socket.connected) {
				socket.writeShort(body.length + 4);
				socket.writeShort(cmd);
				//----------------------
				if(cmd != 215){
					trace("sendServer" + cmd);
				}
				socket.writeBytes(body);
				socket.flush();
			}
		}
		
		public static function onConnectStateHandler(e:Event):void {
			if (e.type == Event.CONNECT)
			{
				trace("连接服务器成功 ip=" + ip + " port=" + socketPort);
				loginLoginServer();
				if(connectHandler != null)
				{
					connectHandler();
				}
			}
			else if (e.type == Event.CLOSE)
			{
				trace("连接服务器失败 ip=" + ip + " port=" + socketPort);
				if(closeHandler != null)
				{
					closeHandler();
				}
			}
		}
		
		private static function loginLoginServer():void {
			var str:String = "tgw_l7_forward\r\nHost:" + ip+":" + socketPort + "\r\n\r\n";
			socket.writeMultiByte(str + "", "GBK");
			socket.flush();
		}
		
		public static function onSocketDataHandler(e:ProgressEvent):void {
			var len:int;
			var cmd:int;
			if (recvBuf.length && recvBuf.length == recvBuf.position)
			{ 
				recvBuf.clear();
			}
			socket.readBytes(recvBuf, recvBuf.length); 
			while (recvBuf.bytesAvailable >= 4)
			{
				len = recvBuf.readShort();
				if (recvBuf.bytesAvailable >= len - 2)
				{
					cmd = recvBuf.readShort(); 
					if(cmd != 216 && cmd != 218 && cmd != 220){
						trace("receive",cmd);
					}
					lastCmd = curCmd;
					curCmd = cmd;
					lastPkgLen = curPkgLen;
					curPkgLen = len;
//					recvBuf.readInt();
					data.length = len - 4;
					data.position = 0;
					if(data.length > 0)
					{
						recvBuf.readBytes(data, 0, len - 4);
					}
					GCManager.read(cmd,data);
				}
				else
				{
					recvBuf.position -= 2;
					break;
				}
			}
		}
		
		private static function doMessage(recv:ByteArray):void {
			// 接收到长度
			if(recv.bytesAvailable > 0 && recv.toString().indexOf("<?xml") == 0)
			{
				recv.length = 0;
			}
			
			while(recv.bytesAvailable >= 4) {
				var len:int = recv.readShort();
				if(recv.bytesAvailable >= (len - 4)) {
					var cmd:int = recv.readShort();
					if(cmd != 216 && cmd != 218 && cmd != 220 && cmd < 4300){
						trace("receive",cmd);
					}
					data.length = 0;
					data.writeBytes(recv, recv.position, len-4);
					recv.position += (len - 4);
					data.position = 0;
					GCManager.read(cmd,data);
				}else {
					recv.position -= 4;
					break;
				}
			}
		}
		
		public static function close():void {
			socket.close();
		}
		
		public static function onErrorHandler(e:IOErrorEvent):void {
			trace("连接服务器出错 ip=" + ip + " port=" + socketPort);
			socket.close();
			if(errorHandler != null)
			{
				errorHandler();
			}
		}
		
		public static function onSecurityErrorHandler(e:SecurityErrorEvent):void {
			trace("安全沙箱连接出错");
			socket.close();
		}
		
	}
}


