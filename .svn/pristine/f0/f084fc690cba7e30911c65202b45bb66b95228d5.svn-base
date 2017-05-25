package com.components.delegate
{
	import com.components.ZAlertView;
	
	/**方法调用的顺序依次是
	 * alertViewShouldEnableFirstOtherButton---->
	 * willPresentAlertView--->
	 * didPresentAlertView---->
	 * clickedButtonAtIndex---->
	 * (如果会触发视图取消,则会调用alertViewCancel)willDismissWithButtonIndex---->
	 * didDismissWithButtonIndex
	 * @author leetn-zavy
	 */	
	public interface ZAlertViewDelegate
	{
		function clickedButtonAtIndex(alertView: ZAlertView, buttonIndex: int): void;
		function alertViewCancel(alertView: ZAlertView): void;
		function willDismissWithButtonIndex(alertView: ZAlertView, buttonIndex: int): void;
		function didDismissWithButtonIndex(alertView: ZAlertView, buttonIndex: int): void;
		function willPresentAlertView(alertView: ZAlertView): void;
		function didPresentAlertView(alertView: ZAlertView): void;
	}
}