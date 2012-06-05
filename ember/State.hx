package ember;

@:ember @:native("Ember.State")
extern class State extends Object {

	public function new():Void;
	
	public function enter(stateManager:StateManager):Void;
	public function exit(stateManager:StateManager):Void;
	
}