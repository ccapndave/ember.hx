# Ember.hx

Ember.hx is a library for the [Haxe](http://www.haxejs.org/) programming language that, for the first time, allows you to write Ember.js code using a modern statically typed language.

## Why not just write Javascript like everyone else?

##### Some people don't like Javascript

Its true!  Its a fact that a lot of people actively dislike or merely tolerate Javascript because its the only option for web development.  Javascript's object model and dynamic scoping can be particularly confusing for developers coming from classical languages like Java, C# and AS3.  Full compile-time error checking is (probably) impossible due to Javascript's dynamic nature which means that a whole class of errors that a statically typed language can find in advance won't be found until the code actually executes.  This also makes it harder to work on a single code base with larger teams.  

A full unit testing suite mitigates some of these problems, but in the real world there isn't always time for this.

##### How about Coffeescript then?

Personally I find Coffeescript to be a vast improvement on Javascript, but it suffers from the same issues with regard to compile-time type checking.

##### Haxe solves these issues

Haxe is a very powerful statically typed language which is syntactically similar to Javascript and AS3.  It has been around since 2005 and has strong community and tooling support, and like Coffeescript it compiles down to Javascript that can run in a browser or in node.js.  Because Haxe has strong typing it means that the compiler can inform you about certain classes or errors before you run a line of code, and furthermore it means that an IDE can give you accurate code completion.  It also means that its much easier to refactor your codebase.  Haxe even supports source mapping (before Coffeescript!) so that you can debug Haxe code directly in Chrome rather than the underlying Javascript.

One other feature that makes Haxe an excellent choice as an alternative to Javascript development is the fact that if you choose you can turn type checking off for arbitrary sections of code using the `untyped` command, and even drop down to hand-coding Javascript directly from within a Haxe application.  This gives the developer the best of every world.

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
```haxe
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

```haxe
class Person extends Ember.Object {
  public var firstName:String;
  public var lastName:String;
  public var fullName(getFullName, null):String;
  
  @:property
  private function getFullName() {
    return firstName + ' ' + lastName;
  }
}

MyApp.president.fullName;
// "Barack Obama"
```

Treating a function like a property is useful because they can work with bindings, just like any other property.

Many computed properties have dependencies on other properties. For example, in the above example, the `fullName` property depends on `firstName` and `lastName` to determine its value. You can tell Ember.hx about these dependencies like this:

```haxe
class Person extends Ember.Object {
  public var firstName:String;
  public var lastName:String;
  public var fullName(getFullName, null):String;
  
  @:property('firstName', 'lastName')
  private function getFullName() {
    return firstName + ' ' + lastName;
  }
}

MyApp.president.fullName;
// "Barack Obama"
```

Make sure you list these dependencies so Ember.hx knows when to update bindings that connect to a computed property.

## Auto-updating Templates

Ember.hx uses Handlebars, a semantic templating library. To take data from your Haxe application and put it into the DOM, create a `<script>` tag and put it into your HTML, wherever you'd like the value to appear:

``` html
<script type="text/x-handlebars">
  The President of the United States is {{MyApp.president.fullName}}.
</script>
```

Here's the best part: templates are bindings-aware. That means that if you ever change the value of the property that you told us to display, we'll update it for you automatically. And because you've specified dependencies, changes to *those* properties are reflected as well.

Hopefully you can see how all three of these powerful tools work together: start with some primitive properties, then start building up more sophisticated properties and their dependencies using computed properties. Once you've described the data, you only have to say how it gets displayed once, and Ember.hx takes care of the rest. It doesn't matter how the underlying data changes, whether from an XHR request or the user performing an action; your user interface always stays up-to-date. This eliminates entire categories of edge cases that developers struggle with every day.

## Strict typing

Unlike JavaScript which can take hours to debug, Haxe has a very strict compile-time type checking feature that allows you to catch errors before testing your program in the browser, and automatically offers helpful instruction on how to debug the issue.

Haxe also supports packages, modules, enums, getters and setters, anonymous functions, closures, dynamic types and many other modern language features.  It also has a sophisticated type inference system which means that it is often possible to leave types out altogether, and still get the benefits of code completion and type checking.

Finally Haxe allows the type system to be completely disabled for blocks of code using `untyped { }`.

These features make Haxe ideal as an alternative to Javascript.

## Code completion

Since Haxe is strictly typed it means that IDEs can offer complete and accurate code completion.  Most popular IDEs support Haxe, including Textmate, Sublime Text 2 and IntelliJ.  For a list of IDEs with Haxe support, or plugins see [http://haxe.org/com/ide].

## Differences between Ember.hx and Ember.js

## How does it work?

## Getting Started
