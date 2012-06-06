package ember;
import macros.EmberObjectBuilder;

@:autoBuild(macros.EmberObjectBuilder.build())
@:ember @:native("Ember.Object")
extern class Object {
	
	public function new():Void;
	
	public function init():Void;
	
	public function get(field:String):Dynamic;
	public function set(field:String, value:Dynamic):Dynamic;
	
}
