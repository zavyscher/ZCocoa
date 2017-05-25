package com.core.net
{
	import flash.utils.ByteArray;

	/**
	 *@author leetn-dmt-zavy
	 */
	public class UDPMessageVO
	{
		/**发送数据包的计算机上的端口*/
		public var srcPort: int;
		/**发送数据包的计算机的 IP 地址*/
		public var srcAddress: String;
		/**数据报数据包数据*/
		public var data: ByteArray;
		/**将所有字节以字符串读取*/
		public var UTFBytes: String;
		
		public function UDPMessageVO()
		{
		}
	}
}