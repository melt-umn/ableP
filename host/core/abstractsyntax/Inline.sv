grammar edu:umn:cs:melt:ableP:abstractsyntax;

synthesized attribute inlined<a> :: a ;

{- Interesting definitions of inlined are placed here, the standard
   ones are on the abstract productions to avoid creating lots of
   uninteresting aspect.
-}

aspect production varRefExpr
e::Expr ::= id::ID
{ -- We need to know if 'id' is an argument in an inline declaration
  -- body.  If so, we replace it with the actual argument from the
  -- inline call site. This expressions is part of the declaration,
  -- created for this call site, for the formal parameter.

  e.inlined = case eres.dcl of
                inlineArgDecl(_,ine) -> ine
              | _ -> varRefExpr(id)  end ;
}


-- inline declarations --
-------------------------
abstract production inlineDecl
d::Decls ::= n::ID formals::InlineArgs stmt::Stmt
{ d.pp = "inline " ++ n.lexeme ++ "(" ++ formals.pp ++ ")\n" ++ stmt.pp;
  stmt.ppi = "   ";
  -- d.errors := forward.errors ;
  d.defs = valueBinding(n.lexeme, d) ;
  d.host = inlineDecl(n, formals.host, stmt.host) ;

 -- We cannot, and should not do error checking here as the body of the inline may
 -- contain identifiers that are declared just above the point of inlining and are 
 -- thus not in scope (that is, not in u.env) here.
 --    u.errors = formals.errors ++ stmt.errors;
 --    stmt.env = mergeDefs(formals.defs, u.env);

 forwards to -- commented_unit("/* inline \"" ++ n.lexeme ++ "\" was defined here. */\n", 
             emptyDecl();
}
nonterminal InlineArgs with pp, host<InlineArgs>, asList<String> ;

abstract production noneInlineArgs
ia::InlineArgs ::= 
{ ia.pp = "" ;
  ia.asList = [ ] ;
  ia.host = noneInlineArgs();
}
abstract production consInlineArgs
ia::InlineArgs ::= id::ID  rest::InlineArgs
{ ia.pp = id.lexeme ++ case rest of
                         noneInlineArgs() -> ""
                       | consInlineArgs(_,_) -> ", " end  ++ rest.pp ;
  ia.asList = [id.lexeme] ++ rest.asList ;
  ia.host = consInlineArgs(id, rest.host);
}


-- inline statement - instantiate the inline construct --
---------------------------------------------------------
abstract production inlineStmt
st::Stmt ::= n_ref::INAME actuals::Exprs
{ st.pp = n_ref.lexeme ++ "(" ++ actuals.pp ++ ") ;\n";
  -- st.errors := forward.errors ;
  st.defs = emptyDefs() ;
  st.host = inlineStmt(n_ref, actuals.host);

  local res::EnvResult = lookup_name(n_ref.lexeme, st.env) ;
 
  forwards to body with { env = mergeDefs( asDecl.defs, st.env) ; } ;
   -- we bind a formal to a Decl
   -- this Decl has the actual Expr that is to be inlined.

  local body::Stmt = case res.dcl of
           inlineDecl (_, _, s)  -> new(s)
         | _ -> error ("Should not be asking for body of inline.") end ;
  local formals::InlineArgs = case res.dcl of
           inlineDecl (_, fs, _)  -> new(fs)
         | _ -> error ("Should not be asking for formals.") end ;

  local declList::[Decls] = zipWith_p ( formals.asList, actuals.asList , inlineArgDecl) ;
  local asDecl::Decls = foldr1_p ( seqDecls, declList ) ;
}

abstract production inlineArgDecl
d::Decls ::= id::String actual::Expr
{
 d.pp = "Internal: " ++ id ++ " " ++ actual.pp ;
 d.defs = valueBinding(id, d) ;
}


{-


synthesized attribute id_list :: [ ID ] occurs on Inline_Args ;


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
 a.id_list = [ id ] ++ rest.id_list ;
}
abstract production inlineArgs
a::Inline_Args ::= id::ID
{
 a.pp = id.lexeme ;
 a.basepp = id.lexeme ;
 a.errors = [ ] ;
 a.defs = valueBinding(id.lexeme, inline_arg_type()) ;
 a.id_list = [ id ] ;
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
       substitute_varref_with_expr_type(new_expr)  ->  new_expr::Expr
     | _                                           ->  error("internal error on inlining") 
     end ;
}

-}
