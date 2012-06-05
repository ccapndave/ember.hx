package ;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.ExampleJSGenerator;
import haxe.macro.JSGenApi;
import haxe.macro.Type;
import haxe.macro.Expr;
using Lambda;

class EmberJSGenerator extends ExampleJSGenerator {

	public function new(api) {
		super(api);
	}

	/**
	 * TODO: Instead of checking for ember on this specific class, check the whole anscestor tree for it, and if we find
	 * one then this counts as an ember class.
	 * 
	 * @param	c
	 */
	override function genClass(c:ClassType) {
		if (c.meta.has(":ember")) {
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
				} else if (c.isExtern && c.meta.has(":ember")) {
					for (m in c.fields.get()) {
						if (m.meta.has(":externSetter")) {
							fprint("${getPath(c)}.prototype${field(m.name)} = function(value) { this.set('${m.doc}', value); }");
							newline();
						}
						
						if (m.meta.has(":externGetter")) {
							fprint("${getPath(c)}.prototype${field(m.name)} = function() { return this.get('${m.doc}'); }");
							newline();
						}
					}
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
		if ( c.constructor != null ) {
			var superClassType = c.superClass.t.get();
			
			var jsSuperClass = superClassType.module;
			if (superClassType.meta.has(":native")) {
				for (meta in superClassType.meta.get()) {
					if (meta.name == ":native") {
						jsSuperClass = getStringFromExpr(meta.params[0]);
						break;
					}
				}
			}
			
			print(jsSuperClass + (c.meta.has(":create") ? ".create()" : ".extend()"));
		} else {
			print("function() { }");
		}
		
		newline();
		
		for( f in c.statics.get() )
			genStaticField(c, p, f);
		for ( f in c.fields.get() ) {
			switch( f.kind ) {
			case FVar(r, _):
				if( r == AccResolve ) continue;
			default:
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
	 * Had to copy this from ExampleJSGenerator since it is static
	 * 
	 * @param	e
	 */
	@:macro static function fprint(e:Expr) {
		var pos = haxe.macro.Context.currentPos();
		var ret = haxe.macro.Format.format(e);
		return { expr : ECall({ expr : EConst(CIdent("print")), pos : pos },[ret]), pos : pos };
	}
	
}