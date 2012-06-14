package ember;

class ArrayExtensions {

	public inline static function pushObject(array:Array<Dynamic>, obj:Dynamic) {
		untyped array.pushObject(obj);
	}
	
	public inline static function removeObject(array:Array<Dynamic>, obj:Dynamic):Bool {
		untyped return array.removeObject(obj);
	}
	
}