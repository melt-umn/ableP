grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

-- inline declarations --
-------------------------
abstract production inline_dcl
u::Unit ::= n::ID args::Inline_Args stmt::Stmt
{
 u.pp = "\n" ++ "inline " ++ n.lexeme ++ "(" ++ args.pp ++ ")\n" ++ stmt.pp;
 stmt.ppi = "   ";

  u.defs = valueBinding(n.lexeme, inline_type(n, args, stmt));

 -- We cannot, and should not do error checking here as the body of the inline may
 -- contain identifiers that are declared just above the point of inlining and are 
 -- thus not in scope (that is, not in u.env) here.
 --    u.errors = args.errors ++ stmt.errors;
 --    stmt.env = mergeDefs(args.defs, u.env);

 forwards to commented_unit("/* inline \"" ++ n.lexeme ++ "\" was defined here. */\n", unit_empty());

 u.inlined_Unit = unit_semi() ;
}

nonterminal Inline_Args with pp, basepp, errors, defs ;
synthesized attribute id_list :: [ ID ] occurs on Inline_Args ;

abstract production inline_args_one
a::Inline_Args ::= id::ID
{
 a.pp = id.lexeme ;
 a.basepp = id.lexeme ;
 a.errors = [ ] ;
 a.defs = valueBinding(id.lexeme, inline_arg_type()) ;
 a.id_list = [ id ] ;
}

abstract production inline_args_none
a::Inline_Args ::= 
{
 a.pp = "" ;
 a.basepp = "" ;
 a.errors = [ ] ;
 a.defs = emptyDefs();
 a.id_list = [ ] ;
}

abstract production inline_args_cons
a::Inline_Args ::= id::ID rest::Inline_Args
{
 a.pp = id.lexeme ;
 a.basepp = id.lexeme ;
 a.errors = [ ] ;
 a.defs = mergeDefs( valueBinding(id.lexeme, inline_arg_type()), rest.defs ) ;
 a.id_list = id ::: rest.id_list ;
}


-- inline statement - instantiate the inline construct --
---------------------------------------------------------
abstract production inline_stmt
st::Stmt ::= n_ref::INAME actuals::Args 
{
 st.pp = n_ref.lexeme ++ "(" ++ actuals.pp ++ ") ;\n";

 local attribute res :: EnvResult ;
 res = lookup_name(n_ref.lexeme, st.env) ;
  
 forwards to ft'' ;

 local attribute ft::Stmt ;
 ft = case res.typerep of
        inline_type(n_dcl, formals, in_stmt) 
        => commented_stmt("/* inlined \"" ++ n_dcl.lexeme ++ "\" here. */ \n", substitute(n_dcl,n_ref,in_stmt,formals,actuals) )

       | _   
         => commented_stmt("/* use of undefined inline " ++ n_ref.lexeme ++ " was here. */\n", 
                            error_stmt( "Error use of undefined inline name " ++ n_ref.lexeme ))
      end ;
}


abstract production substitute
st::Stmt ::= n_dcl::ID n_ref::INAME orig::Stmt  formals::Inline_Args  actuals::Args

{
 st.pp = orig.pp ;
 orig.ppi = st.ppi ;

 forwards to if   length(formals.id_list) != length(actuals.arg_list)
             then error_stmt ("Error: (line " ++ toString(n_ref.line) ++ " col " ++ toString(n_ref.column) ++
                              ": incorrect number of arguments for " ++ n_ref.lexeme)
             else orig'' with { env = mergeDefs(new_defs, st.env) ; }  ; 

 local attribute new_defs :: Env ;
 new_defs = mk_new_defs(formals.id_list, actuals.arg_list);
}


function mk_new_defs
Env ::= formal_ids::[ID]  actual_args::[Expr]
{
 return if   null(formal_ids) && null(actual_args) -- both formal_ids or actual_args are empty
        then emptyDefs()
        else
        if null(formal_ids) || null(actual_args)   -- one of formal_ids or actuals_args are empty        
        then emptyDefs() -- this is an error
        else mergeDefs ( valueBinding( head(formal_ids).lexeme , substitute_varref_with_expr_type(head(actual_args)) ) ,
                         mk_new_defs ( tail(formal_ids), tail(actual_args) ) ) ;
}

abstract production inline_var_ref
e::Expr ::= id::ID t::TypeRep
{ 
 e.pp = id.lexeme ++ "/*" ++ t.pp ++ "*/" ;
 e.basepp = id.lexeme;
 e.errors = [ ];
 e.typerep = t ;
}

abstract production substitute_var_ref
e::Expr ::= id::ID t::TypeRep
{ 
 e.pp = id.lexeme ++ "/*!" ++ t.pp ++ "*/" ;
 e.errors = [ ];

 forwards to f'' ;

 local attribute f :: Expr ;
 f = case t'' of
       substitute_varref_with_expr_type(new_expr)  =>  new_expr
     | _                                           =>  error("internal error on inlining") 
     end ;
}
