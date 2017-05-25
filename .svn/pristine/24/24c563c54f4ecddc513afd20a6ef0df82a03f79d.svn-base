package
{
	import com.core.utils.Debug;
	
	public function print(...argArr): void
	{
		if (Debug.printDisabled)
			return;
		
		var result: String = "";
		var len: int = argArr.length;
		for (var i: int = 0; i < len; i++)
		{
			result += argArr[i];
		}
		trace("Print : <" + result + ">");
	}
}