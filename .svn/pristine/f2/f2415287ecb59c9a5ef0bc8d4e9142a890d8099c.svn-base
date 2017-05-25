package com.components.custom
{
	/**注意类中所有角度均为弧度
	 * @author leetn-dmt-04
	 */	
	public class V2D
	{
		public var x: Number;
		public var y: Number;
		
		public function V2D(x: Number = 0, y: Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		public static function plus(v1: V2D, v2: V2D): V2D//向量V1+V2
		{
			return new V2D(v1.x + v2.x, v1.y + v2.y);
		}
		
		public static function minus(v1: V2D, v2: V2D): V2D//向量V1-V2
		{
			return new V2D(v1.x - v2.x, v1.y - v2.y);
		}
		
		public function reset(xx: Number, yy: Number): void//向量重新赋值
		{
			this.x = xx;
			this.y = yy;
		}
		
		public function clone(): V2D//克隆
		{
			return new V2D(x, y);
		}
		
		public function selfPlus(v: V2D): void//向量加法
		{
			x += v.x;
			y += v.y;
		}
		
		public function selfMinus(v: V2D): void//向量减法
		{
			x -= v.x;
			y -= v.y;
		}
		
		public function negate(): void//向量旋转180度
		{
			x = -x;
			y = -y;
		}
		public function scale(s: Number): void//向量缩放s倍，改变向量的大小
		{
			x *= s;
			y *= s;
		}
		
		public function length(): Number//向量的模
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function setLength(len: Number): void//设置向量的长度
		{
			var len0: Number = length(); 
			if(len0)
			{
				scale(len / len0);
			}
			else
			{
				x = len;
			}
		}
		
		public function getTangle(): Number//向量角度
		{
			return Math.atan2(y, x);
		}
		
		public function setAngle(ang: Number): void//改变向量角度，保持向量原有长度
		{
			var len0: Number = this.length();
			x = len0 * Math.cos(ang);
			y = len0 * Math.sin(ang);
		}
		
		public function rotate(ang: Number): void//向里旋转ang弧度
		{
			var ca: Number = Math.cos(ang);
			var sa: Number = Math.sin(ang);
			var rx: Number = x * ca - y * sa;
			var ry: Number = x * sa + y * ca;
			this.x = rx;
			this.y = ry;
		}
		public function dot(v: V2D): Number//向量点乘
		{
			return x * v.x + y * v.y;
		}
		public function getNormalS(): V2D//得到顺时针方向的法向量
		{
			return new V2D(y, -x);
		}
		public function getNormalN(): V2D//逆时针方向的法向量
		{
			return new V2D(-y, x);
		}
		public function angleBetween(v: V2D): Number//计算两个向量之间的夹角
		{
			var dp: Number = dot(v);
			var cosAngle: Number = dp / (this.length() * v.length());
			return Math.acos(cosAngle);
		}
	}
}


