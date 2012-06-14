package ember;
import macros.EmberObjectBuilder;

@:autoBuild(macros.EmberObjectBuilder.build())
@:native("Ember.Object")
extern class Object {

	public static function create(?opts:Dynamic):Object;
	public static function extend(?opts:Dynamic):Class<Object>;
	
	public function new():Void;
	
	public function init():Void;
	
	public function get(field:String):Dynamic;
	public function set(field:String, value:Dynamic):Dynamic;
	
}
