package com.core.manager
{	import com.components.ZView;
	import com.components.custom.views.TipBase;
	import com.core.utils.Singleton;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**悬停提示管理器
	 * @author leetn-zavyscher
	 */	
	public class TipManager
	{
		private static var _curTip: TipBase;
		private static var _oldTarget: DisplayObject;
		private static var _tipSource: Object;
		private static var equipTipPool: Array = [];
		private static var _compareEquipTip: *; //EquipTip对比装备tips
		private static var _targetMap: Dictionary = new Dictionary;
		
		private static var staticStage: Stage;
		private static var parentContainer: ZView = new ZView();
		
		public static function registContainer(stage: Stage, parent: ZView): void
		{
			staticStage = stage;
			parentContainer = parent;
		}
		
		public static function bind(tipClass:Class, target:DisplayObject, source:Object):void
		{
			target.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_targetMap[target] = [tipClass, target, source];
		}
		
		public static function unBind(target:DisplayObject):void
		{
			if(target)
			{
				if(!_targetMap[target])
					return;
				
				target.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				target.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				target.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				delete _targetMap[target];
			}
		}
		
		private static function onRollOver(e:MouseEvent):void
		{
			var item:Array = _targetMap[e.target];
			if(item)
				show(item[0], item[1], item[2]);
		}
		
		private static function show(tipClass:Class, target:DisplayObject, source:Object):void
		{
			if(_curTip)
				clearTip();
			
			if(!source)
				return;
			_tipSource = source;
			_curTip = Singleton.getInstance(tipClass);
			
			target.addEventListener(MouseEvent.MOUSE_MOVE, onMove, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
		}
		
		private static function onMove(e:MouseEvent):void
		{
			var curTarget:DisplayObject = e.target as DisplayObject;
			if(!curTarget.stage)
				return;
			
			if(_curTip && _oldTarget != curTarget)
			{
				parentContainer.addSubView(_curTip);
				_curTip.show(_tipSource);
				_oldTarget = curTarget;
			}
			setPosition(curTarget.stage.mouseX, curTarget.stage.mouseY);
			
			var item: Array = _targetMap[curTarget];
			if(item && item[2] != _tipSource)
			{
				show(item[0], item[1], item[2]);
			}
			
			var clipBounds: Rectangle = curTarget.getBounds(curTarget.root);
			var isClean: Boolean = true;
			if (staticStage.mouseX > clipBounds.x && staticStage.mouseX < (clipBounds.x + clipBounds.width))
			{
				if (staticStage.mouseY > clipBounds.y && staticStage.mouseY < (clipBounds.y + clipBounds.height))
				{
					isClean = false;
				}
			}
			if (isClean == true)
			{
				clearTip();
			}
		}
		
		private static function onOut(e:MouseEvent):void
		{
			clearTip();
		}
		
		private static function setPosition(lx:int, ly:int):void
		{
			if(!_curTip || !_curTip.stage)
			{
				clearTip();
				return;
			}
			//较正Y轴
			if(ly + _curTip.height + 10 > _curTip.stage.stageHeight)
			{
				_curTip.y = Math.max(ly - _curTip.height - 10, 0);
			}
			else
			{
				_curTip.y = ly + 10;
			}
			
			//较正X轴
			if(lx + _curTip.width + 10 > _curTip.stage.stageWidth) 
			{
				_curTip.x = Math.max(lx - _curTip.width - 10, 0);
			} 
			else 
			{
				_curTip.x = lx + 10;
			}
		}
		
		public static function updateTip(target:DisplayObject, tipClass:Class, tip:Object):void
		{
			clearTip();
			if(!target.stage)
				return;
			
			_curTip = Singleton.getInstance(tipClass);
			parentContainer.addChild(_curTip);
			_curTip.show(tip);
			if(target.stage)
				setPosition(target.stage.mouseX,target.stage.mouseY);
		}
		
		public static function hide():void
		{
			clearTip();
		}
		
		public static function hideTip():void
		{
			if(_oldTarget && _oldTarget.stage == null)
			{
				clearTip();
			}
		}
		
		private static function clearTip():void
		{
			if(_curTip)
			{
				_curTip.clean();
				_curTip = null;
			}
			if(_oldTarget != null)
			{
				_oldTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				_oldTarget.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				_oldTarget = null;
			}
		}
		
	}
}
