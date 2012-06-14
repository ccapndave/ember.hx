package ;
import ember.Object;

@:native("Ember")
extern class Ember {
	
	public static function bind(object:Object, from:String, to:String):Void;

	public static function getPath(path:String):Dynamic;
	
}