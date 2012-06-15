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