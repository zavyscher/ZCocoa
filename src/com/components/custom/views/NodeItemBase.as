package com.components.custom.views
{
	
	
	public class NodeItemBase extends ItemBase
	{
		protected var _arrItem: Array;
		
		private var _parentNode: NodeItemBase;
		
		public function NodeItemBase()
		{
			super();
			
			_arrItem = [];
		}
		
		/**拼装数组
		 * @param arr 参考数组的splice用法
		 * @return 返回修改后的数组
		 */		
		public function splice(...arr): Array
		{
			var index: int = arr[0];
			var deleteCount: int = arr[1];
			for (var i: int = index; i < index + deleteCount; i++)
			{
				_arrItem[i].removeFromSuperView();
				_arrItem[i].deinit();
				_arrItem[i] = null;
			}
			var newElem: Array = arr.slice(2);
			_arrItem.splice(index, deleteCount, newElem);
			return _arrItem;
		}
		
		public function set parentNode(value:NodeItemBase):void
		{
			_parentNode = value;
		}
		
		public function get parentNode():NodeItemBase
		{
			return _parentNode;
		}
		//
	}
}


