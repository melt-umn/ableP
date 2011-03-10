grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

abstract production expr_name
e::Expr ::= id::ID
{
 e.is_var_ref = true; 
 local attribute res :: EnvResult ;
 res = lookup_name(id.lexeme, e.env) ;

 forwards to if res.found
             then (res.typerep.var_ref_p) (id,res.typerep)
             else undeclared_var_ref(id) ;
}

abstract production promela_bound_var_ref
e::Expr ::= id::ID  t::TypeRep
{ 
 -- Used for most basic promela types

 e.pp = id.lexeme ++ "/*" ++ t.pp ++ "*/"  ;
 e.basepp = id.lexeme;
 e.typerep = t ;
 e.errors = [ ::String ];
}


abstract production undeclared_var_ref
e::Expr ::= id::ID 
{ 
 e.basepp = id.lexeme ; 
 e.is_var_ref = true;

-- _pid ,_last,_nr_pr and _ are global variables in Promela
-- _last is a predefined global read-only variable of type pid
-- _pid is a predefined local read-only variable of type pid and stores the instantiation number of executing process
-- _ is a predefined global write-only variable of type integer. Channels used them to store scratch values.
 e.pp = id.lexeme ++ "/* " ++ envDisplay(e.env.bindings) ++ " */" ;
 e.errors = if id.lexeme == "_pid" || id.lexeme == "_last" || id.lexeme == "_nr_pr" || id.lexeme == "_"
            then []
            else ["Error (line " ++ toString(id.line) ++ ", col " ++ toString(id.column) ++ "): " ++ 
                    id.lexeme ++ " is not declared"];  
 e.typerep = if id.lexeme == "_pid" || id.lexeme == "_last" || id.lexeme == "_nr_pr"
             then pid_type()
             else error_type();

 
}



abstract production error_var_ref
e::Expr ::= id::ID t::TypeRep
{ 
 e.basepp = id.lexeme;
 e.pp = id.lexeme ;
 e.errors = ["Error (line " ++ toString(id.line) ++ ", col " ++ toString(id.column) ++ "): error on " ++ id.lexeme ] ;
 e.typerep = error_type();
}

function envDisplay
String ::= e::[Binding]
{
 return   if null(e)
          then ""
          else head(e).name ++ " " ++ envDisplay(tail(e));
}
