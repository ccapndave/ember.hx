package ember;

@:native("Ember.View")
extern class View extends Object {

	public static function create(?opts:Dynamic):View;
	public static function extend(?opts:Dynamic):Class<View>;

	public function new():Void;
	
	/**
	 * The name of a template that this view will render.  This will be defined in the html file with <script type="text/x-handlebars" data-template-name="my-template-name">...<script>
	 */
	public var templateName:String;
	
	/**
	 * The string to render as a template.  This can be handcoded, or it can be a handlebars template from a Haxe resource using:
	 * 
	 * template = ember.Handlebars.compile(haxe.Resource.getString('resource-name'));
	 * 
	 * The resource needs to be including in your hxml compile file with -resource <filename>@<resource-name>
	 */
	public var template:String;
	
	/**
	 * Tag name for the view's outer element. The tag name is only used when an element is first created.
	 */
	public var tagName:String;
	
	/**
	 * The controller managing this view. If this property is set, it will be made available for use by the template.
	 */
	public var controller:Object;

	/**
	 * If the view is currently inserted into the DOM of a parent view, this property will point to the parent of the view.
	 */
	public var parentView:View;

	/**
	 * jQuery events
	 */
	public function doubleClick(event:Dynamic):Void;
	public function focusOut(event:Dynamic):Void;
	public function keyUp(event:Dynamic):Void;

}