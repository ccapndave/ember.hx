package ember;

@:ember @:native("Ember.View")
extern class View extends Object {
	
	public function new():Void;
	
	/**
	 * The name of a template that this view will render.  This will be defined in the html file with <script type="text/x-handlebars" data-template-name="my-template-name">...<script>
	 */
	public var templateName:String;
	
	/**
	 * The string to render as a template.  This can be handcoded, or can be a handlebars template from a Haxe resource using:
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
	
}