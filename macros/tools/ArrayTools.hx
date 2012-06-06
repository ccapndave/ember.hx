package macros.tools;

/**
 * ...
 * @author 
 */

class ArrayTools {
	
	public static function contains(array:Iterable<Dynamic>, obj:Dynamic):Bool {
		for (el in array)
			if (el == obj)
				return true;
		
		return false;
	}
	
}