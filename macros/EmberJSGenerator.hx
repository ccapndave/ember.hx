package macros;
import ember.Object;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.ExampleJSGenerator;
import haxe.macro.JSGenApi;
import haxe.macro.Type;
import haxe.macro.Expr;
using Lambda;
using StringTools;
using tink.macro.tools.MacroTools;

/**
 * Generate Ember friendly JS.  In fact, this uses the standard JS generator but steps in when a class extends ember.Object or ember.Application to make
 * Ember friendly code.  At the moment this uses *.prototype to add methods, but in the future this could do the more standard Ember style where attributes
 * go as the first parameter of extend or create.  Would need to think about how that would work with static properties.
 */
class EmberJSGenerator extends ExampleJSGenerator {

	public function new(api) {
		super(api);
	}

	/**
	 * TODO: Instead of checking for ember on this specific class, check the whole anscestor tree for it, and if we find
	 * Ember.Object or Ember.Application then this counts as an ember class.
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
			print(getNativeModule(c.superClass.t.get()) + (c.meta.has(":create") ? ".create()" : ".extend()"));
		//} else {
		//	print("function() { }");
		//}
		
		newline();
		
		for( f in c.statics.get() )
			genStaticField(c, p, f);
		for ( f in c.fields.get() ) {
			switch( f.kind ) {
			case FVar(r, _):
				// Generate Ember binding code for a @:binding
				if (f.meta.has(":binding")) {
					var path = getStringFromExpr(f.meta.get().getValues(":binding")[0][0]);
					
					// TODO: check that the target of the binding exists, and throw a compilation error if not
					
					// TODO: don't keep reopening the class
					fprint("${getNativeModule(c)}.reopen({ ${f.name}Binding: '$path' });");
					newline();
				}
				if (r == AccResolve) continue;
			// Don't generate Javascript for inlined methods as there is no point
			case FMethod(f):
				if (f == MethInline) continue;
			}
			genClassField(c, p, f);
		}
		print("/**********************************************************/");
		newline();
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
	
	private function hasSuperClass(c:ClassType, searchForClasses:Array<String>) {
		var currentClassType = c;
		do {
			if (currentClassType.superClass != null) {
				currentClassType = currentClassType.superClass.t.get();
				if (searchForClasses.indexOf(currentClassType.pack.concat([currentClassType.name]).join(".")) >= 0) return true;
			}
		} while (currentClassType.superClass != null);
		
		return false;
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