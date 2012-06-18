# Ember.hx

Ember.hx is a library for the [Haxe](http://www.haxejs.org/) programming language that allows you to write HTML5 web applications using a modern, statically typed language with full code completion and compile time error checking.  It does this by integrating the fantastic [ember.js](http://emberjs.com/) framework with Haxe.

If you want to dive straight into you can find the code for the obligatory Todo example at https://github.com/ccapndave/ember.hx-todos with a [live demo](http://ccapndave.github.com/ember.hx-todos/bin/) here.

#### Quick links
 - [What does Ember.hx do anyway](#what-does-emberhx-do-anyway)
 - [Installation](#installation)
 - [Getting started](#getting-started)

## Why not just write Javascript like everyone else?

##### Some people don't like Javascript

Its true!  Its a fact that a lot of people actively dislike or merely tolerate Javascript because its the only option for web development.  Javascript's object model and dynamic scoping can be particularly confusing for developers coming from classical languages like Java, C# and AS3.  Full compile-time error checking is (probably) impossible due to Javascript's dynamic nature which means that a whole class of errors that a statically typed language can find in advance won't be found until the code actually executes.  This also makes it harder to work on a single code base with larger teams.  

A full unit testing suite mitigates some of these problems, but in real-life programming projects with deadlines there isn't always time to write and maintain them.

##### How about Coffeescript then?

Personally I find Coffeescript to be a vast improvement on Javascript, but it suffers from the same issues with regard to compile-time type checking.

##### Haxe solves these issues

Haxe is a very powerful statically typed language which is syntactically similar to Javascript and AS3.  It has been around since 2005 and has strong community and tooling support, and like Coffeescript it compiles down to Javascript that runs in a browser or in node.js.  Because Haxe has strong typing it means that the compiler can inform you about certain classes or errors before you run a line of code, and furthermore it means that an IDE can give you accurate code completion.  It also means that its much easier to refactor your codebase.  Haxe even supports source mapping (before Coffeescript!) so that you can debug Haxe code directly in Chrome rather than the underlying Javascript.

> Note that although source mapping works for normal Javascript written in Haxe, it doesn't yet work with Ember.hx.  Follow the issue at http://code.google.com/p/haxe/issues/detail?id=930

One other feature that makes Haxe an excellent choice as an alternative to Javascript development is the fact that if you choose you can turn type checking off for arbitrary sections of code using the `untyped` command, and even drop down to hand-coding Javascript directly from within a Haxe application with the `__js__` command.  This gives the developer the best of every world.

## What does Ember.hx do anyway?

Ember.hx is a Haxe library allowing you to use the Haxe language to leverage Ember.js - a powerful JavaScript framework that does all of the heavy lifting that you'd normally have to do by hand. There are tasks that are common to every web app; Ember.js does those things for you, so you can focus on building killer features and UI.

These are the features that make Ember.js a joy to use:

1. Bindings
2. Computed properties
3. Auto-updating templates

These are the features that Ember.hx adds to Ember.js, making it even more of a joy to use:

1. Strict typing
2. Code completion

## Bindings

Use bindings to keep properties between two different objects in sync. You just declare a binding once, and Ember.hx will make sure changes get propagated in either direction.

Here's how you create a binding between two objects:
```as3
class MyApp extends Ember.Application {
  public static var president:Person;
  public static var country:Country;
  
  public static function main() {
    usPresident = new Person();
    usPresident.name = "Barack Obama";
    
    usa = new Country();
  }
}

class Person extends Ember.Object {
  public var name:String;
}

class Country extends Ember.Object {
  @:binding("MyApp.usPresident.name")
  public var presidentName:String;
}

// Later, after Ember has resolved bindings...
MyApp.usa.presidentName;
// "Barack Obama"
```

Bindings allow you to architect your application using the MVC (Model-View-Controller) pattern, then rest easy knowing that data will always flow correctly from layer to layer.

## Computed Properties

Computed properties allow you to treat a function like a property:

```as3
class Person extends Ember.Object {
  public var firstName:String;
  public var lastName:String;

  @:property
  private function fullName() {
    return firstName + ' ' + lastName;
  }
}

MyApp.president.get("fullName"); // See caveats section; when getting methods that have @:property outside of a template you need to use get()
// "Barack Obama"
```

Treating a function like a property is useful because they can work with bindings, just like any other property.

Many computed properties have dependencies on other properties. For example, in the above example, the `fullName` property depends on `firstName` and `lastName` to determine its value. You can tell Ember.hx about these dependencies like this:

```as3
class Person extends Ember.Object {
  public var firstName:String;
  public var lastName:String;
  
  @:property('firstName', 'lastName')
  private function fullName() {
    return firstName + ' ' + lastName;
  }
}

MyApp.president.get("fullName"); // See caveats section; when getting methods that have @:property outside of a template you need to use get()
// "Barack Obama"
```

Make sure you list these dependencies so Ember.hx knows when to update bindings that connect to a computed property.

## Auto-updating Templates

Ember.hx uses Handlebars, a semantic templating library. To take data from your Haxe application and put it into the DOM, create a `<script>` tag and put it into your HTML, wherever you'd like the value to appear:

```html
<script type="text/x-handlebars">
  The President of the United States is {{MyApp.president.fullName}}.
</script>
```

Here's the best part: templates are bindings-aware. That means that if you ever change the value of the property that you told us to display, we'll update it for you automatically. And because you've specified dependencies, changes to *those* properties are reflected as well.

Hopefully you can see how all three of these powerful tools work together: start with some primitive properties, then start building up more sophisticated properties and their dependencies using computed properties. Once you've described the data, you only have to say how it gets displayed once, and Ember.hx takes care of the rest. It doesn't matter how the underlying data changes, whether from an XHR request or the user performing an action; your user interface always stays up-to-date. This eliminates entire categories of edge cases that developers struggle with every day.

## Strict typing

Unlike JavaScript which can take hours to debug, Haxe has a very strict compile-time type checking feature that allows you to catch errors before testing your program in the browser, and automatically offers helpful instruction on how to debug the issue.

Haxe also supports packages, modules, enums, getters and setters, anonymous functions, closures, dynamic types and many other modern language features.  It also has a sophisticated type inference system which means that it is often possible to leave types out altogether, and still get the benefits of code completion and type checking.

Finally Haxe allows the type system to be completely disabled for blocks of code using `untyped { }`, and hand-coded Javascript to be output using `__js__`.

These features make Haxe ideal as an alternative to Javascript.

## Code completion

Since Haxe is strictly typed it means that IDEs can offer complete and accurate code completion.  Most popular IDEs support Haxe, including Textmate, Sublime Text 2, IntelliJ IDEA, FlashDevelop and MonoDevelop.  For a list of IDEs with Haxe support see [http://haxe.org/com/ide].

## Installation

Ember.hx can be installed via Haxe's package manager: `haxelib install ember.hx`

To enable Ember.hx in a project you need to tell the Haxe compiler to use the Ember.hx classes and Javascript generator.  Do this by adding the following two lines to your project's compile.hxml file:

```
-lib ember.hx
--macro macros.EmberJSGenerator.use()
```

If you want to clone the Ember.hx repository directly you need to manually include its dependencies in compile.hxml.

First ensure the dependencies are installed by running:

```
haxelib install tink_core
haxelib install tink_macros
```

Then add the following to compile.hxml:

```
-lib tink_core
-lib tink_macros
-cp <path_to_cloned_ember.hx_repository>
--macro macros.EmberJSGenerator.use()
```

> Since Ember is under active development it is recommended to install via the cloned repository in order to get easy access to the latest bug fixes and features.

## Getting started

Ember.hx applications start with a [Namespace](http://emberjs.com/documentation/#toc_creating-a-namespace).  This is done on your entry class with controllers declared as static properties on the namespace.  This class should be at the top level, and not within a package.

```haxe
package ;
import ember.Application;
import todos.controller.TodosController;

class Todos extends Application {
 
	public static var todosController:TodosController;
	
	public static function main() {
		todosController = new TodosController();
	}
	
}
```

Finally you need an `index.html` which (at a minimum) loads jQuery, ember.js and your generated Javascript file.

See https://github.com/ccapndave/ember.hx-todos for a working example.

## Metadata

Ember.hx implements some special metadata tags for working with bindings, properties and observers:

##### @:binding

The @:binding tag is applied to an instance variable, and creates a two-way binding between the variable and the target.  For example, to make sure that a `user` variable always remains in sync with a `loggedInUser` variable in a controller you might use:

```as3
@:binding("MyApp.userController.loggedInUser")
public var user:User;
```

In the generated Javascript this would be translated to:

```js
userBinding: "MyApp.userController.loggedInUser"
```

See http://emberjs.com/documentation/#toc_bindings for more details.

##### @:property

The @:property tag is applied to a function, and converts it into a computed property so that it can be used as a source for binding in templates or code via the @:binding tag.  A list of dependant properties can be specified to tell Ember that if they change then any bindings linked to this computed property need to update.

```as3
@:property("speakers", "staff", "visitors")
public function totalAttendees() {
  return speakers + staff + visitors;
}
```

In the generated Javascript this would be translated to:

```js
totalAttendees: function() {
	return this.get("speakers") + this.get("staff") + this.get("visitors");
}.property("speakers", "staff", "visitors")
```

See http://emberjs.com/documentation/#toc_computed-properties-getters for more details.

##### @:observes

The @:observes tag is applied to a function, and causes the function to be rerun if any of the listed properties changes.

```as3
@:observes("totalAttendees")
public function runWhenTotalAttendeesChanges() {
	// do something
}
```

Since totalAttendees updates when speaker, staff or visitors changes, this means that the `runWhenTotalAttendeesChanges` function will execute when any of these change too!

In the generated Javascript this would be translated to:

```js
runWhenTotalAttendeesChanges: function() {
	// do something
}.observes("totalAttendees")
```

See http://emberjs.com/documentation/#toc_observers for more details.

## Caveats

- Object-oriented constructors don't really translate over to Ember.  Therefore **never** use the `new` constructor in Ember classes.  Instead override the `init` function, which performs the same job in Ember.  Always be sure to call `super.init()` at the end of the function otherwise your app will not function correctly.                                                                                      

```as3
class MyView extends View {
	override public function init() {
		// My initialisation code goes here
		super.init();
	}
}
```
- All Ember classes you create must be in a package named with the lowercase version of the application namespace.  So in the example above the namespace is `Todos`, so all controllers, views, etc must be in a package named `todos`.  It is ok to nest these deeper in arbitrary sub-packages as long as the top level package is `todos`.

- Views in Ember are often created by the template: `{{view Todos.views.MainView}}`.  In order to make sure that Haxe knows to compile this class into the Javascript you need to have an `import Todos.views.MainView` statement in your application namespace class, otherwise you will get a `Unable to find view at path 'Todos.view.MainView'` error at runtime.

- When you make a function into a computed property using @:property, you are actually changing the function into a property within the generated Javascript.  Therefore you cannot access it from another class using, for example, `Todos.todoController.remaining()` as this will generate a `Property 'remaining' of object is not a function`.  As a workaround for this access the property using `Todos.todoController.get("remaining")`.  It is not necessary to use Ember's `get` and `set` methods for normal properties, and you can use computed properties normally in template bindings: `Items remaining: {{Todos.todoController.remaining}}`.

## Contributing

Ember.hx currently includes only a small subset of available Ember classes, functions and properties (basically enough to make a working Todo example, plus the StateMachine).  However, if you look at the code in the `ember` package you will see that it is extremely easy to include new features so as you use Ember.hx please add what you need and make pull requests back to the main repository.

When adding a new property or method please copy and paste the documentation from the matching Ember.js source code so that it gets shown in code completion.