// ActionScript file
package com.core.utils
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;
	
	public class ComputerClose
	{
		private var process:NativeProcess = new NativeProcess();
		private var file:File = new File();
		private var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		public function ComputerClose()
		{
			/*使用静态属性 NativeApplication.nativeApplication 
			　　　　　　　　　*获取应用程序的 NativeApplication 实例          
			*指定在关闭所有窗口后是否应自动终止应用程序。           
			*当 autoExit 为 true（默认值）时，如果关闭了所有窗口，
			　　　　　　　　　*则应用程序将终止。调度 exiting 和 exit 事件。
			　　　　　　　　　*如果 autoExit 为 false，则必须调用 NativeApplication.nativeApplication.exit() 
			　　　　　　　　　*才能终止应用程序。
			　*/
			NativeApplication.nativeApplication.autoExit = true;
		}
		
		public static function get instance(): ComputerClose {
			return Singleton.getInstance(ComputerClose);
		}
		
		public function ExitEXE():void
		{
			NativeApplication.nativeApplication.exit(-1);
		}
		
		public function CallEXE(path:String = ""):void
		{
			file = file.resolvePath("C:/Windows/System32/cmd.exe");
			//file = file.resolvePath("C:/Users/ken/Desktop/北京握奇数据智能交通沙盘.flv");
			var processArg:Vector.<String> = new Vector.<String>;
			processArg[0] = "/c";  //加上/c ,表示是cmd的参数
			//processArg[1] = "C:/Users/ken/Desktop/北京握奇数据智能交通沙盘.flv";
			processArg[1] = path;
			nativeProcessStartupInfo.executable = file;
			nativeProcessStartupInfo.arguments = processArg;
			process.start(nativeProcessStartupInfo);
		}
		public function ComClose(deleyTime:String = "2"):void
		{
			file = file.resolvePath("C:/Windows/System32/cmd.exe");
			var processArg:Vector.<String> = new Vector.<String>;
			processArg[0] = "/c"  //加上/c ,表示是cmd的参数
			processArg[1] = "shutdown -s -t "+deleyTime;
			nativeProcessStartupInfo.executable = file;
			nativeProcessStartupInfo.arguments = processArg;
			process.start(nativeProcessStartupInfo);
			trace("关机");
		}
		public function ChanceComClose():void
		{
			file = file.resolvePath("C:/Windows/System32/cmd.exe");
			var processArg:Vector.<String> = new Vector.<String>;
			processArg[0] = "/c"  //加上/c ,表示是cmd的参数
			processArg[1] = "shutdown -a";
			nativeProcessStartupInfo.executable = file;
			nativeProcessStartupInfo.arguments = processArg;
			process.start(nativeProcessStartupInfo);
			trace("取消关机");
		}
		public function ComCloseTime(deleyTime:String = "2",TimeStr:String = "12:00"):void
		{
			file = file.resolvePath("C:/Windows/System32/cmd.exe");
			var processArg:Vector.<String> = new Vector.<String>;
			processArg[0] = "/c"  //加上/c ,表示是cmd的参数
			processArg[1] = "at "+TimeStr+" shutdown -s -t "+deleyTime;
			nativeProcessStartupInfo.executable = file;
			nativeProcessStartupInfo.arguments = processArg;
			process.start(nativeProcessStartupInfo);
			trace("定时关机");
		}
		public function ComRe(deleyTime:String = "2"):void
		{
			file = file.resolvePath("C:/Windows/System32/cmd.exe");
			var processArg:Vector.<String> = new Vector.<String>;
			processArg[0] = "/c"  //加上/c ,表示是cmd的参数
			processArg[1] = "shutdown -r -t "+deleyTime;
			nativeProcessStartupInfo.executable = file;
			nativeProcessStartupInfo.arguments = processArg;
			process.start(nativeProcessStartupInfo);
		}
	}
}