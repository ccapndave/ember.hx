package ember;

@:native("Ember.TextField")
extern class TextField extends View {

	public static function create(?opts:Dynamic):TextField;
	public static function extend(?opts:Dynamic):Class<TextField>;

	public var value:String;
	
	function insertNewline():Void;
	
}