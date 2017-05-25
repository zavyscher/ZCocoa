package com.components
{
	import com.interfaces.ITarget;
	import com.core.coreGraphics.ZColor;
	import com.core.coreGraphics.ZFont;
	import com.core.manager.ResourceManager;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	public class ZButton extends ZView implements ITarget
	{
		private var _titleLabel: ZLabel;
		private var _img: ZImageView;
		private var _selectedImg: ZImageView;
		private var _enabled: Boolean;
		private var _textColor: uint;
		private var _selectTextColor: uint;
		
		public var isGroup: Boolean;
		private var _selected: Boolean;
		
		public function ZButton()
		{
			super();
			this.mouseEnabled = true;
			this.mouseChildren = false;
			this.buttonMode = true;
			_enabled = true;
		}
		
		public function get titleLabel(): ZLabel
		{
			return _titleLabel;
		}
		
		public function set titleLabel(value: ZLabel): void
		{
			if (_titleLabel)
			{
				this.removeChild(_titleLabel);
				_titleLabel = null;
			}
			_titleLabel = value;
			if (value)
			{
				_textColor = value.textColor;
				this.addSubView(_titleLabel);
			}
		}
		
		public function set image(value: ZImageView):void
		{
			_img = value;
			if (value)
			{
				this.addSubView(value);
			}
		}
		
		public function get image(): ZImageView
		{
			return _img;
		}
		
		public function set selectedImage(value: ZImageView): void
		{
			_selectedImg = value;
			if (value)
			{
				if (_img)
				{
					var index: int = this.getChildIndex(_img);
					this.insertView(value, index + 1);
				}
				else
				{
					this.addSubView(value);
				}
				value.visible = false;
				this.addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			}
			else
			{
				if (_selectedImg)
				{
					_selectedImg.removeFromSuperView();
					this.removeEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
				}
			}
		}
		
		public function get selectedImage(): ZImageView
		{
			return _selectedImg;
		}
		
		public function set selectTextColor(value:uint):void
		{
			_selectTextColor = value;
		}
		
		private function onDownHandler(e: MouseEvent):void
		{
			if (!isGroup)
				selected = !_selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			_selectedImg.visible = value;
			_titleLabel.textColor = (value) ? _selectTextColor : _textColor;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function configCommonLabel(text: String, w: Number, h: Number): void
		{
			_titleLabel ||= new ZLabel();
			this.addSubView(_titleLabel);
			_titleLabel.text = text;
			var font: ZFont = ZFont.fontBySize(12);
			font.align = TextFormatAlign.CENTER;
			_titleLabel.font = font;
			_textColor = _titleLabel.textColor;
			_titleLabel.width = (w > this.width) ? this.width : w;
			_titleLabel.height = (h > this.height) ? this.height : h;
			this.alignLabelWithSize(_titleLabel.width, _titleLabel.height);
		}
		
		/**
		 * @param w 文本框宽度
		 * @param h 文本框高度
		 */		
		public function alignLabelWithSize(w: Number, h: Number): void
		{
			_titleLabel.x = uint(this.width - w) >> 1;
			_titleLabel.y = uint(this.height - h) >> 1;
		}
		
		public function set enabled(value: Boolean): void
		{
			if (_enabled && !value)
			{
				_textColor = _titleLabel.textColor;
			}
			_enabled = value;
			this.mouseEnabled = value;
			this.mouseChildren = value;
			this.filters = (value) ? null : [ZColor.grayFilter];
			if (_titleLabel)
			{
				_titleLabel.textColor = (value) ? _textColor : 0x999999;
			}
		}
		
		public function get enabled(): Boolean
		{
			return _enabled;
		}
		
		public static function makeButton(title: String = "", imgUrl: String = null, x: Number = 0, y: Number = 0, w: Number = 0, h: Number = 0): ZButton
		{
			var btn: ZButton = new ZButton();
			btn.x = x;
			btn.y = y;
			btn.width = w;
			btn.height = h;
			
			if (title && title != "")
			{
				btn.configCommonLabel(title, w, h);
			}
			
			if (imgUrl && imgUrl != "")
			{
				if (!btn.image)
				{
					btn.image = new ZImageView();
					ResourceManager.getBitmap(btn.image.bitmap, imgUrl);
				}
			}
			return btn;
		}
		//
	}
}


