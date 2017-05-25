package com.core.nextstep
{
	/**
	 * @author leetn-zavyscher
	 */
	public class NSRange
	{
		public var location: int;
		public var length: int;
		
		public function NSRange(location: int = 0, length: int = 0)
		{
			this.location = location;
			this.length = length;
		}
	}
}