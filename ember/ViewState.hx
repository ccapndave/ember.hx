package ember;

@:native("Ember.ViewState")
extern class ViewState extends State {

	public function new():Void;
	
	public var rootElement:String;
	public var view:Class<View>;
	
}