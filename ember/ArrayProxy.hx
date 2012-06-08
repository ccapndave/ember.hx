package ember;

@:native("Ember.ArrayProxy")
extern class ArrayProxy<T> extends Object {
	
	public function new():Void;
	
	public var content:Array<T>;
	
}