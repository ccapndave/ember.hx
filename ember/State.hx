package ember;

@:native("Ember.State")
extern class State extends Object {

	public static function create(?opts:Dynamic):State;
	public static function extend(?opts:Dynamic):Class<State>;

	public function new():Void;
	
	public function enter(stateManager:StateManager):Void;
	public function exit(stateManager:StateManager):Void;
	
}