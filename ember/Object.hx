package ember;

import haxe.macro.Expr;
import haxe.macro.Context;

@:autoBuild(ember.GetterSetterBuilder.build())
@:ember @:native("Ember.Object")
extern class Object {
	
	public function new():Void;
	
	public function init():Void;
	
	public function get(field:String):Dynamic;
	public function set(field:String, value:Dynamic):Dynamic;
	
	// TODO: We want a macro that intercepts properties and makes them use get and set
	
}

class GetterSetterBuilder {
	
	@:macro static public function build():Array<Field> {
		var fields = Context.getBuildFields();
		var cls = Context.getLocalClass().get();
		var pos = haxe.macro.Context.currentPos();
		
		var newFields = [];
		
		for (field in fields) {
			var isPublic = false, isStatic = false;
			switch (field.kind) {
				case FVar(t, e):
					
					for (a in field.access) {
						switch (a) {
							case APublic: isPublic = true;
							case AStatic: isStatic = true;
							default:
						}
					}
					
					if (isPublic && !isStatic) {
						// Extract the type
						var type;
						switch (FVar(t)) {
							case FVar(v, _):
								switch(v) {
									case TPath(p):
										type = p.name;
									default:
								}
							default:
						}
						
						if (type != "Class") {
							field.kind = FProp("_get_" + field.name, "_set_" + field.name, TPath({name: type, pack:[], params:[], sub: null}));
							
							var getterExprString = Std.format("function():$type { return get('${field.name}'); }");
							newFields.push({
								name: "_get_" + field.name,
								doc: field.name,
								meta: [ { name: ":externGetter", params: [ ], pos: pos } ],
								access: [APrivate],
								kind: FFun(getFunction(Context.parse(getterExprString, pos))),
								pos: pos
							});
							
							var setterExprString = Std.format("function(value:$type):$type { return set('${field.name}', value); }");
							newFields.push({
								name: "_set_" + field.name,
								doc: field.name,
								meta: [ { name: ":externSetter", params: [ ], pos: pos } ],
								access: [APrivate],
								kind: FFun(getFunction(Context.parse(setterExprString, pos))),
								pos: pos
							});
						}
					}
					
				default:
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