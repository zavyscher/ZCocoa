package com.components
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ZLabel extends ZView
	{
		protected var tf: TextField = new TextField();
		private var _originText: String;
		private var _htmlText: String;
		
		public function ZLabel(text: String = "", x: Number = 0, y:Number = 0, width: Number = 32, height: Number = 18)
		{
			super();
			this.edit = false;
			this.x = x;
			this.y = y;
			tf.width = width;
			tf.height = height;
			tf.wordWrap = false;
			this.text = text;
			this.addChild(tf);
		}
		
		public function set font(value: TextFormat): void
		{
			if (!value)
			{
				value = new TextFormat("微软雅黑", 18, 0x666666, null, null, null, null, null, TextFormatAlign.CENTER);
			}
			tf.defaultTextFormat = value;
			tf.text = tf.text;
		}
		
		public function get font(): TextFormat
		{
			return tf.defaultTextFormat;
		}
		
		public function set selectable(value: Boolean): void
		{
			tf.mouseEnabled = value;
			tf.selectable = value;
		}
		
		public function get selectable(): Boolean
		{
			return tf.selectable;
		}
		
		public function set text(value:String): void
		{
			_originText = value;
			tf.text = _originText;
		}
		
		public function get text(): String
		{
			return tf.text;
		}
		
		public function set htmlText(value:String): void
		{
			_htmlText = value;
			tf.htmlText = value;
		}
		
		public function get htmlText(): String
		{
			return _htmlText;
		}
		
		public function set edit(value: Boolean): void
		{
			if (value)
			{
				tf.type = TextFieldType.INPUT;
				this.selectable = true;
			}
			else
			{
				tf.type = TextFieldType.DYNAMIC;
				this.selectable = false;
			}
		}
		
		/**指定文本字段是否具有背景填充。如果为 true，则文本字段具有背景填充。如果为 false，则文本字段没有背景填充。
		 * 使用 backgroundColor 属性来设置文本字段的背景颜色。
		 * @param value
		 */
		public function set background(value: Boolean): void
		{
			tf.background = value;
		}
		
		/**文本字段背景的颜色。默认值为 0xFFFFFF（白色）。
		 * 即使当前没有背景，也可检索或设置此属性，但只有当文本字段已将 background 属性设置为 true 时，才可以看到颜色。
		 * @param color
		 */		
		override public function set backgroundColor(color:uint):void
		{
			background = true;
			tf.backgroundColor = color;
		}
		
		/**文本字段中文本的颜色（采用十六进制格式）。十六进制颜色系统使用六位数表示颜色值。每位数有 16 个可能的值或字符。字符范围从 0 到 9，然后从 A 到 F。
		 * 例如，黑色是 0x000000；白色是 0xFFFFFF。
		 * @param value
		 */		
		public function set textColor(value: uint): void
		{
			tf.textColor = value;
		}
		
		public function get textColor(): uint
		{
			return tf.textColor;
		}
		
		/**定义多行文本字段中的文本行数
		 * @return 
		 */		
		public function get numberOfLines(): int
		{
			return tf.numLines;
		}
		
		/**表示字段是否为多行文本字段
		 * @param value
		 */		
		public function set multiline(value: Boolean): void
		{
			tf.multiline = value;
		}
		
		/**表示文本字段是否自动换行
		 * @param value
		 */		
		public function set wordWrap(value: Boolean): void
		{
			tf.wordWrap = value;
		}
		
		public function set leading(value: Object): void
		{
			this.font.leading = value;
			this.font = font;
		}
		
		public function get leading(): Object
		{
			return this.font.leading;
		}
		
		/**表示是否设置边框
		 * @param value
		 */		
		public function set border(value: Boolean): void
		{
			tf.border = value;
		}
		
		/**文本字段边框的颜色。默认值为 0x000000（黑色）。
		 * 即使当前没有边框，也可检索或设置此属性，但只有当文本字段已将 border 属性设置为 true 时，才可以看到颜色。
		 */
		public function set borderColor(value: uint): void
		{
			tf.borderColor = value;
		}
		
		/**TextFieldAutoSize
		 * @param value
		 */		
		public function set autoSize(value: String): void
		{
			tf.autoSize = value;
		}
		
		/**指定是否使用嵌入字体轮廓进行呈现
		 * @param value
		 */		
		public function set embedFonts(value: Boolean): void
		{
			tf.embedFonts = value;
		}
		
		override public function set width(value:Number):void
		{
			tf.width = value;
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			tf.height = value;
			super.height = value;
		}
		
		public function get textWidth(): Number
		{
			return tf.textWidth;
		}
		
		public function get textHeight(): Number
		{
			return tf.textHeight;
		}
		
		/**文本字段中最多可包含的字符数（即用户输入的字符数）。
		 * 脚本可以插入比 maxChars 允许的字符数更多的文本；maxChars 属性仅表示用户可以输入多少文本。
		 * 如果此属性的值为 0，则用户可以输入无限数量的文本。
		 * @param value 
		 */		
		public function set maxChars(value: int): void
		{
			tf.maxChars = value;
		}
		
		/**表示用户可输入到文本字段中的字符集。
		 * 如果 restrict 属性的值为 null，则可以输入任何字符。
		 * 如果 restrict 属性的值为空字符串，则不能输入任何字符。
		 * 如果 restrict 属性的值为一串字符，则只能在文本字段中输入该字符串中的字符。
		 * 从左向右扫描该字符串。可以使用连字符 (-) 指定一个范围。
		 * @param value
		 */		
		public function set restrict(value: String): void
		{
			tf.restrict = value;
		}
		
		/**固定宽度, 动态自动适应高度
		 * @param fixedWidth
		 * @param extraHeight
		 */		
		public function fixedWith(fixedWidth: Number, extraHeight: int = 4): void
		{
			this.multiline = false;
			this.wordWrap = false;
			this.text = this.text;
			this.width = fixedWidth;
			var f: TextFormat = this.font;
			if (this.textWidth > this.width)
			{
				f.align = TextFormatAlign.LEFT;
				this.multiline = true;
				this.wordWrap = true;
			}
			else
			{
				f.align = TextFormatAlign.CENTER;
			}
			this.font = f;
			this.height = this.textHeight + extraHeight;
		}
		
		public static function change(textfield: TextField): ZLabel
		{
			var lb: ZLabel = new ZLabel(textfield.text, textfield.x, textfield.y, textfield.width, textfield.height);
			return lb;
		}
		//
	}
}


