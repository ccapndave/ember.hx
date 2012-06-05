package ember;

@:ember @:native("Ember.StateManager")
extern class StateManager extends State {

	public function new():Void;
	
	public var enableLogging:Bool;
	
	/**
	 * The name of the initial state.  The transition to this state will occur as soon as the state machine is initialized.
	 */
	public var initialState:String;
	
	/**
	 * A hash of state names to States.
	 */
	public var states:Dynamic<State>;
	
	/**
	 * When using ViewStates this gives the jQuery selector of the element to replace.
	 */
	public var rootElement:String;
	
	public function send(action:String, ?context:Dynamic):Void;
	public function goToState(stateName:String):Void;
	
}