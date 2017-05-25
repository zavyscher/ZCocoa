package com.interfaces
{
	/**I字母开头的是接口
	 * @author xzm
	 */
	public interface IViewController
	{
		function loadView():void;
		
		function viewDidLoad():void;
		
		function viewWillUnload():void;
		
		function viewDidUnload():void;
		
		function viewWillAppear(animated:Boolean = false):void;
		
		function viewDidAppear(animated:Boolean = false):void;
		
		function viewWillDisappear(animated:Boolean = false):void;
		
		function viewDidDisappear(animated:Boolean = false):void;
		
		function viewWillLayoutSubviews():void;
		
		function viewDidLayoutSubviews():void;
	}
}