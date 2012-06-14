package ember;

@:native("Ember.ArrayProxy")
extern class ArrayProxy<T> extends Object {

	public static function create(?opts:Dynamic):ArrayProxy<Dynamic>;
	public static function extend(?opts:Dynamic):Class<ArrayProxy<Dynamic>>;

	public function new():Void;
	
	public var content:Array<T>;

	public function pushObject(obj:T):Void;

	public function removeObject(obj:T):Bool;

	public function contentDidChange():Void;
	
}