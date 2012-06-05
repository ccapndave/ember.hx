package ember;

@:ember @:native("Ember.View")
extern class View extends Object {
	
	public function new():Void;
	
	public var templateName:String;
	public var tagName:String;
	
}