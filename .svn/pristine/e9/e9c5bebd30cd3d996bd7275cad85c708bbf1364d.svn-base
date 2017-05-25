package com.components
{
	import com.components.delegate.ZAlertViewDelegate;
	import com.core.coreGraphics.ZFont;
	import com.core.pool.ObjectPool;
	
	import flash.events.MouseEvent;
	
	public class ZAlertView extends ZView
	{
		protected var _viewBg: ZView;
		protected var _lbTitle: ZLabel;
		protected var _lbMsg: ZLabel;
		protected var _btnCancel: ZButton;
		protected var _arrOtherBtns: Array;
		
		public var delegate: ZAlertViewDelegate;
		
		public static function getInstance(): ZAlertView {
			return ObjectPool.getObjectByClass(ZAlertView);
		}
		
		public function ZAlertView()
		{
			super();
			
			_viewBg = new ZView();
			this.addSubView(_viewBg);
		}
		
		public function set title(value: String): void
		{
			if (!_lbTitle)
			{
				var font: ZFont = ZFont.fontBySize(14);
				_lbTitle = new ZLabel();
				_lbTitle.font = font;
				this.addSubView(_lbTitle);
			}
			_lbTitle.text = value;
		}
		
		public function set message(value: String):void
		{
			if (!_lbMsg)
			{
				var font: ZFont = ZFont.fontBySize(14);
				_lbMsg = new ZLabel();
				_lbMsg.font = font;
				this.addSubView(_lbMsg);
			}
			_lbMsg.text = value;
		}
		
		protected function set cancelButtonTitle(value: String): void
		{
			if (!_btnCancel)
			{
				var font: ZFont = ZFont.fontBySize(14);
				_btnCancel = new ZButton();
				_btnCancel.titleLabel = new ZLabel();
				_btnCancel.titleLabel.font = font;
				_btnCancel.addEventListener(MouseEvent.CLICK, onCancelHandler);
				this.addSubView(_btnCancel);
			}
			_btnCancel.titleLabel.text = value;
		}
		
		private function onCancelHandler(e: MouseEvent):void
		{
			if (delegate)
			{
				delegate.alertViewCancel(this);
			}
		}
		
//		protected function get cancelButtonIndex(): int
//		{
//			return -1;
//		}
		
		protected function set otherButtonTitles(value: *): void
		{
			var font: ZFont = ZFont.fontBySize(14);
			var btn: ZButton;
			if (value is Array)
			{
				if (_arrOtherBtns && _arrOtherBtns.length > 0)
				{
					cleanBtns();
				}
				var len: int = value.length;
				for (var i: int = 0; i < len; i++)
				{
					btn = new ZButton();
					btn.titleLabel = new ZLabel();
					btn.titleLabel.font = font;
					btn.titleLabel.text = value[i];
					btn.addEventListener(MouseEvent.CLICK, onClickHandler);
					btn.y = _lbMsg.rightBottomPoint.y + 24 + (i * btn.height);
					this.addSubView(btn);
					_arrOtherBtns.push(btn);
				}
			}
			else if (value is String)
			{
				cleanBtns();
				btn = new ZButton();
				btn.titleLabel = new ZLabel();
				btn.titleLabel.font = font;
				btn.titleLabel.text = value;
				btn.addEventListener(MouseEvent.CLICK, onClickHandler);
				this.addSubView(btn);
				_arrOtherBtns.push(btn);
			}
		}
		
		private function cleanBtns():void
		{
			var len: int = _arrOtherBtns.length;
			for (var i: int = 0; i < len; i++)
			{
				var btn: ZButton = _arrOtherBtns[i];
				btn.removeFromSuperView();
				btn.removeEventListener(MouseEvent.CLICK, onClickHandler);
				btn = null;
			}
			_arrOtherBtns = null;
		}
		
		private function onClickHandler(e: MouseEvent):void
		{
			var btn: ZButton = e.currentTarget as ZButton;
			var index: int = _arrOtherBtns.indexOf(btn);
			if (index == -1)
				return ;
			
			if (delegate)
			{
				delegate.clickedButtonAtIndex(this, index);
			}
		}
		
		public function addButtonWithTitle(addTitle: String):int
		{
			return 0;
		}
		
		public function buttonTitleAtIndex(buttonIndex: int):String
		{
			if (_arrOtherBtns && _arrOtherBtns.length > buttonIndex && _arrOtherBtns[buttonIndex])
			{
				var btn: ZButton = _arrOtherBtns[buttonIndex];
				return btn.titleLabel.text;
			}
			return "";
		}
		
		public function show(): void
		{
			if (delegate)
			{
				delegate.willPresentAlertView(this);
			}
			ZWindow.instance.addToInteract(this);
			if (delegate)
			{
				delegate.didPresentAlertView(this);
			}
		}
		
		protected function hideWithIndex(index: int): void
		{
			if (delegate)
			{
				delegate.willDismissWithButtonIndex(this, index);
			}
			ZWindow.instance.removeFromInteract(this);
			if (delegate)
			{
				delegate.didDismissWithButtonIndex(this, index);
			}
			this.deinit();
		}
		
		override public function deinit():void
		{
			ObjectPool.recycle(this);
		}
		
		public static function initWithTitle(initTitle: String, message: String, delegate: ZAlertViewDelegate, cancelButtonTitle: String, ...otherButtonTitles): ZAlertView
		{
			var alertView: ZAlertView = ZAlertView.getInstance();
			alertView.title = initTitle;
			alertView.message = message;
			alertView.delegate = delegate;
			alertView.cancelButtonTitle = cancelButtonTitle;
			alertView.otherButtonTitles = otherButtonTitles;
			return alertView;
		}
		//
	}
}


