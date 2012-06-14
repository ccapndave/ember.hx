package macros;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.ExampleJSGenerator;
import haxe.macro.JSGenApi;
import haxe.macro.Type;
import haxe.macro.Expr;
import tink.macro.tools.AST;
using Lambda;
using StringTools;
using tink.macro.tools.MacroTools;

/**
 * Generate Ember JS.  In fact, this uses the standard JS generator but steps in when a class extends ember.Object or ember.Application to make
 * Ember friendly code.
 */
class EmberJSGenerator extends ExampleJSGenerator {
	
	public function new(api) {
		super(api);
	}

	/**
	 * If this class subclasses Ember.Object or Ember.Application then run our special JS generator code, otherwise default to the standard one.
	 * 
	 * @param	c
	 */
	override function genClass(c:ClassType) {
		if (hasSuperClass(c, [ "Ember.Object", "Ember.Application" ])) {
			genEmberClass(c);
		} else {
			super.genClass(c);
		}
	}
	
	override function genType(t:Type) {
		switch(t) {
			case TInst(c, _):
				var c = c.get();
				if(c.init != null)
					inits.add(c.init);
				if (!c.isExtern) {
					genClass(c);
				}
			case TEnum(r, _):
				var e = r.get();
				if( !e.isExtern ) genEnum(e);
			default:
		}
	}
	
	#if macro
	public static function use() {
		// This runs just before compilation
		Context.onGenerate(function(types) {
			var namespaces = new Hash<String>();
			
			// Go through the types finding anything that is an Ember application and storing it in a map
			for (type in types) {
				switch (type) {
					case TInst(t, _):
						var c = t.get();
						if (hasSuperClass(c, [ "ember.Application" ]))
							namespaces.set(c.name.toLowerCase(), c.name);
					default:
				}
			}
			
			// Now we have the application go through the types again finding anything that is an Ember object and add native metadata to it
			for (type in types) {
				switch (type) {
					case TInst(t, _):
						var c = t.get();
						if (c.pack.length > 0 && hasSuperClass(c, [ "ember.Object" ])) {
							if (namespaces.exists(c.pack[0])) {
								var native = c.pack.copy();
								native[0] = namespaces.get(native[0]);
								c.meta.add(":native", [ Context.makeExpr(native.concat([c.name]).join("."), c.pos) ], c.pos);
							}
						}
					default:
				}
			}
		});
		
		Compiler.setCustomJSGenerator(function(api) new EmberJSGenerator(api).generate());
	}
	#end
	
	private function genEmberClass(c:ClassType) {
		print("/**********************************************************/");
		newline();
		
		genPackage(c.pack);
		api.setCurrentClass(c);
		var p = getPath(c);
		fprint("$p = $$hxClasses['$p'] = ");
		
		// Commented out the constructor temporarily; it stops the root app from initializing
		//if ( c.constructor != null ) {
		print(getNativeModule(c.superClass.t.get()));
		if (hasSuperClass(c, [ "Ember.Application" ])) {
			print(".create()");
		} else {
			print(".extend({");
		}
		//} else {
		//	print("function() { }");
		//}
		
		newlineNoSemicolon();
		
		for (f in c.fields.get()) {
			switch(f.kind) {
			case FVar(r, _):
				// Generate Ember binding code for a @:binding
				if (f.meta.has(":binding")) {
					var path = getStringFromExpr(f.meta.get().getValues(":binding")[0][0]);
					fprint("${f.name}Binding: '$path',");
					newlineNoSemicolon();
				}
				if (r == AccResolve) continue;
			// Don't generate Javascript for inlined methods as there is no point
			case FMethod(f):
				if (f == MethInline) continue;
			}
			genEmberClassField(c, p, f);
		}
		
		if (!hasSuperClass(c, [ "Ember.Application" ])) print("})");
		
		newline();

		// Generate statics after the Ember block
		for(f in c.statics.get())
			genStaticField(c, p, f);
			
		newline();
		
		print("/**********************************************************/");
		newline();
	}
	
	function genEmberClassField(c:ClassType, p:String, f:ClassField ) {
		checkFieldName(c, f);
		fprint("${f.name}: ");
		var e = f.expr();
		if(e == null)
			print("null");
		else {
			genExpr(e);
			
			// If this is a computed property then add .property to the expression
			if (f.meta.has(":property")) {
				if (f.meta.get().getValues(":property")[0].length > 0) {
					var property = getStringFromExpr(f.meta.get().getValues(":property")[0][0]);
					fprint(".property('$property')");
				} else {
					fprint(".property()");
				}
			}

			// If this is an observed function then add .observers to the expression
			if (f.meta.has(":observes")) {
				if (f.meta.get().getValues(":observes")[0].length > 0) {
					var property = getStringFromExpr(f.meta.get().getValues(":observes")[0][0]);
					fprint(".observes('$property')");
				} else {
					fprint(".observes()");
				}
			}
		}
		print(",");
		newlineNoSemicolon();
	}
	
	/**
	 * Get a CString out a an Expr (used for getting macros)
	 */
	private function getStringFromExpr(expr:Expr) {
		return
			switch (expr.expr) {
				case EConst(c):
					switch (c) {
						case CString(s): return s;
						default:
					}
					default:
			}
	}
	
	/**
	 * Get the native path of a module (this respects @:native if it exists)
	 * 
	 * @param	c
	 */
	private function getNativeModule(c:ClassType) {
		return if (c.meta.has(":native")) {
			getStringFromExpr(c.meta.get().getValues(":native")[0][0]);
		} else {
			c.module;
		}
	}
	
	private static function hasSuperClass(c:ClassType, searchForClasses:Array<String>) {
		var currentClassType = c;
		do {
			if (currentClassType.superClass != null) {
				currentClassType = currentClassType.superClass.t.get();
				if (searchForClasses.indexOf(currentClassType.pack.concat([currentClassType.name]).join(".")) >= 0) return true;
			}
		} while (currentClassType.superClass != null);
		
		return false;
	}
	
	inline function newlineNoSemicolon() {
		buf.add("\n");
	}
	
	/**
	 * Had to copy this from ExampleJSGenerator since it is static
	 * 
	 * @param	e
	 */
	@:macro static function fprint(e:Expr) {
		var pos = haxe.macro.Context.currentPos();
		var ret = haxe.macro.Format.format(e);
		return { expr : ECall({ expr : EConst(CIdent("print")), pos : pos }, [ret]), pos : pos };
	}
	
}