package com.components.custom.views
{
	import com.components.ZImageView;
	import com.components.ZView;
	import com.interfaces.IDraggable;
	import com.core.utils.Singleton;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**拖动物品, PS: 被拖动对象要实现IDraggable
	 * <br>使用之前要先设置initStage*/
	public class DragObject extends ZView
	{
		private static var staticStage: Stage;
		private var _dragData: Object;
		private var _dragGrid: IDraggable;
		
		private var icon: ZImageView;
		private var iconBg: ZImageView;
		
		private var _isDragging:Boolean = false;
		
		public static function get instance(): DragObject{
			return Singleton.getInstance(DragObject);
		}
		
		public function DragObject()
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			icon = new ZImageView();
			iconBg = new ZImageView();
			this.addSubView(icon);
			this.addSubView(iconBg);
		}
		
		public static function initStage(s: Stage):void
		{
			staticStage ||= s;
		}
		
		public function onDown(e: MouseEvent):void
		{
			if (!staticStage)
				return;
			var target: IDraggable = e.currentTarget as IDraggable;
			if (!target)
				return;
			
			staticStage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			staticStage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			_dragGrid = target;
			_dragData = target.data;
			if(_dragData && _dragData && (_dragGrid is IDraggable))
			{
				icon.image = _dragGrid.getIconBitmapData();
				iconBg.image = _dragGrid.getIconBgBitmapdata();
				adjustPosition();
			}
		}
		
		private function onMove(e: MouseEvent):void
		{
			_isDragging = true;
			if (!staticStage)
				return;
			
			if(staticStage.contains(this) == false)
			{
				staticStage.addChild(this);
			}
			
			adjustPosition();
			e.updateAfterEvent();
		}
		
		private function adjustPosition():void
		{
			this.x = staticStage.mouseX - (icon.width >> 1);
			this.y = staticStage.mouseY - (icon.height >> 1);
		}
		
		/**弹起事件需手动自定义数据处理
		 * @param e
		 */		
		private function onUp(e: MouseEvent):void
		{
			_isDragging = false;
			if (!staticStage)
				return;
			
			staticStage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			staticStage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_dragGrid = null;
			_dragData = null;
			if(staticStage.contains(this) == true)
			{
				staticStage.removeChild(this);
			}
		}
		
		public function get dragGrid(): IDraggable
		{
			return _dragGrid;
		}
		
		public function set dragGrid(value: IDraggable): void
		{
			_dragGrid = value;
		}
		
		public function get dragData(): Object
		{
			return _dragData;
		}
		
		public function set dragData(value: Object):void
		{
			_dragData = value;
		}
		
		public function get isDragging(): Boolean
		{
			return _isDragging;
		}
	}
}


