package ember;

@:native("Ember.ViewState")
extern class ViewState extends State {

	public static function create(?opts:Dynamic):ViewState;
	public static function extend(?opts:Dynamic):Class<ViewState>;

	public function new():Void;
	
	public var rootElement:String;
	public var view:Class<View>;
	
}