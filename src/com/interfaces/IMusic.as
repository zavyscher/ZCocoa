package com.interfaces
{
	/**@author leetn-dmt-zavy
	 */
	public interface IMusic extends IURL
	{
		function play(playURL: String = ""): void;
		function pause(): void;
		function stop(): void;
	}
}