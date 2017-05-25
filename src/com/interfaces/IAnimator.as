package com.interfaces
{
	import flash.display.DisplayObject;

	/**动画器接口
	 * @author leetn-dmt-zavy
	 */
	public interface IAnimator
	{
		function addAnimator(target: DisplayObject): IAnimator;
		/**<b>styles:</b>一组包含作为动画属性和终值的样式属性和及其值的集合（过程数值）<br/>
		 * <b>speed:</b>三种预定速度之一的字符串("slow"600ms,"normal"400ms, or "fast"200ms)或表示动画时长的毫秒数值(如：1000)<br/>
		 * <b>easing:</b>要使用的缓动效果的名称<br/>
		 * <b>callback:</b>在动画完成时执行的函数，每次完成动画后执行一次
		 * */
		function animate(styles: Object, speed: *, easing: * = null, callback: Function = null): IAnimator;
		function stopAnimate(): IAnimator;
	}
}