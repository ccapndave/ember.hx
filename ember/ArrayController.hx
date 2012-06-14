package ember;

@:native("Ember.ArrayController")
extern class ArrayController<T> extends ArrayProxy<T> {

	public static function create(?opts:Dynamic):ArrayController<Dynamic>;
	public static function extend(?opts:Dynamic):Class<ArrayController<Dynamic>>;

	public function new():Void;
	
}