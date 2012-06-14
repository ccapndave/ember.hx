package ;

@:native("Handlebars")
extern class Handlebars {

	public static function compile(s:String):String;

	public static function registerHelper(name:String, func:Dynamic -> Dynamic -> String):Void;
	
}