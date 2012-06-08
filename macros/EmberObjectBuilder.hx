package macros;

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.core.types.Outcome;
import tink.macro.tools.AST;
using tink.macro.tools.MacroTools;
using macros.tools.ArrayTools;

class EmberObjectBuilder {
	
	@:macro static public function build():Array<Field> {
		var fields = Context.getBuildFields();
		var cls = Context.getLocalClass().get();
		
		var newFields = [];
		
		// Go through all the fields in this class
		for (field in fields) {
			// We are only interested in public instance attributes
			if (field.access.contains(APublic) && !field.access.contains(AStatic)) {
				// Get the type out of the FVar
				var readType = switch (field.kind) {
					case FVar(readType, _): readType;
					default: null;
				}
				
				// Only continue if readType was set, otherwise this is a function not a variable
				if (readType != null) {
					// 1. Create getter and setters for each field that delegates to Ember.Object's get() and set() methods
					field.kind = FProp("__$get_" + field.name, "__$set_" + field.name, readType);
					
					var getterExprString = Std.format("function():Dynamic { return get('${field.name}'); }");
					newFields.push({
						name: "__$get_" + field.name,
						doc: null,
						meta: [],
						access: [APrivate, AInline],
						kind: FFun(getFunction(Context.parse(getterExprString, Context.currentPos()))),
						pos: Context.currentPos()
					});
					
					var setterExprString = Std.format("function(value:Dynamic):Dynamic { return set('${field.name}', value); }");
					newFields.push({
						name: "__$set_" + field.name,
						doc: null,
						meta: [],
						access: [APrivate, AInline],
						kind: FFun(getFunction(Context.parse(setterExprString, Context.currentPos()))),
						pos: Context.currentPos()
					});
				}
			}
		}
		
		for (newField in newFields)
			fields.push(newField);
			
		return fields;
	}
	
	private static function getFunction(e:Expr) {
		return
			switch (e.expr) { 
				case EFunction(_, f): f;
				default: throw "Not an EFunction!";
			};
	}
	
}