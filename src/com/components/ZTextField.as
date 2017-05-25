package com.components
{
	import com.components.delegate.ZTextFieldDelegate;
	import com.core.nextstep.NSRange;
	import com.core.utils.HtmlUtil;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author leetn-zavyscher
	 */
	public class ZTextField extends ZLabel
	{
		public var leftGap: int;
		public var upGap: int;
		private var _placeHolder: String = "";
		
		/**左边视图*/
		private var _leftView: ZView;
		/**上部视图*/
		private var _upView: ZView;
		
		public var focusInCallback: Function
		public var focusOutCallback: Function;
		
		public var delegate: ZTextFieldDelegate;

		public function ZTextField(text:String="", x:Number=0, y:Number=0, width:Number=32, height:Number=18)
		{
			super(text, x, y, width, height);
			this.selectable = true;
			tf.type = TextFieldType.INPUT;
			tf.addEventListener(FocusEvent.FOCUS_IN, onFocusHandler);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusHandler);
//			this.addEventListener(Event.CHANGE, onTextChangeHandler);
//			tf.addEventListener(TextEvent.TEXT_INPUT, onTextInputHandler);
		}
		
		/**设置左边视图(设置时必须确认宽高都不为0)
		 * @param value
		 */		
		public function set leftView(value:ZView):void
		{
			if (value)
			{
				if (value.width != 0 && value.height != 0)
				{
					tf.x = value.rightBottomPoint.x + leftGap;
				}
				this.addSubView(value);
			}
			else if (_leftView)
			{
				_leftView.removeFromSuperView();
				tf.x = 0;
			}
			_leftView = value;
		}
		
		public function get leftView():ZView
		{
			return _leftView;
		}
		
		/**设置时必须确认宽高都不为0
		 * @param value
		 */		
		public function set upView(value:ZView):void
		{
			if (value)
			{
				if (value.width != 0 && value.height != 0)
				{
					tf.y = value.rightBottomPoint.y + upGap;
				}
				this.addSubView(value);
			}
			else if (_upView)
			{
				_upView.removeFromSuperView();
				tf.y = 0;
			}
			_upView = value;
		}
		
		public function get upView():ZView
		{
			return _upView;
		}
		
		public function set placeHolder(value:String):void
		{
			_placeHolder = value;
			if (tf.text == "")
			{
				tf.text = HtmlUtil.font(value, "#aaaaaa");
			}
		}
		
		protected function onFocusHandler(e: FocusEvent): void
		{
			if (e.type == FocusEvent.FOCUS_IN)
			{
				if (tf.text == _placeHolder)
				{
					tf.text = "";
				}
				if (focusInCallback is Function)
				{
					focusInCallback(this);
				}
			}
			else if (e.type == FocusEvent.FOCUS_OUT)
			{
				if (tf.text == "")
				{
					tf.htmlText = HtmlUtil.font(_placeHolder, "#aaaaaa");
				}
				if (focusOutCallback is Function)
				{
					focusOutCallback(this);
				}
			}
		}
		
		protected function onTextChangeHandler(e: Event):void
		{
//			var txt: TextField = e.target as TextField;
//			if (delegate)
//			{
				//NSRange还没实现具体参数传递
//				delegate.shouldChangeCharactersInRange(this, new NSRange(0, 0), txt.text);
//			}
		}
		
		protected function onTextInputHandler(e: TextEvent):void
		{
		}
	}
}


