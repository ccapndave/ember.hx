/*
Copyright (C) 2012 Dave Keen http://www.actionscriptdeveloper.co.uk

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package ember;

@:native("Ember.StateManager")
extern class StateManager extends State {

	public static function create(?opts:Dynamic):StateManager;
	public static function extend(?opts:Dynamic):Class<StateManager>;

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