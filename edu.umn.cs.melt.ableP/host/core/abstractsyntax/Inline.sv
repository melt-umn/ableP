grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

synthesized attribute inlined<a> :: a ;

{- Interesting definitions of inlined are placed here, the standard
   ones are on the abstract productions to avoid creating lots of
   uninteresting aspect.
-}

aspect production varRefExpr
e::Expr ::= id::ID eres::EnvResult
{ -- We need to know if 'id' is an argument in an inline declaration
  -- body.  If so, we replace it with the actual argument from the
  -- inline call site. This expressions is part of the declaration,
  -- created for this call site, for the formal parameter.

  e.inlined = case eres.dcl of
                inlineArgDecl(_,ine) -> ine
              | _ -> varRefExpr(id, eres)  end ;
}

aspect production varRefExprAll
e::Expr ::= id::ID
{ overloads <- case eres.dcl of
                 inlineArgDecl(_,ine) -> [ new(ine) ]
               | _ -> [ ]  end ;
}


-- inline declarations --
-------------------------
abstract production inlineDecl
d::Decls ::= n::ID formals::InlineArgs stmt::Stmt
{ d.pp = "inline " ++ n.lexeme ++ "(" ++ formals.pp ++ ")\n" ++ stmt.pp;
  propagate alluses,
            ppsep,
            ppi,
            ppterm,
            env,
            rwrules_ChInit,
            rwrules_Declarator,
            rwrules_Decls,
            rwrules_Enabler,
            rwrules_Expr,
            rwrules_Exprs,
            rwrules_IDList,
            rwrules_Inst,
            rwrules_MArgs,
            rwrules_Op,
            rwrules_Options,
            rwrules_Priority,
            rwrules_ProcType,
            rwrules_Program,
            rwrules_RArg,
            rwrules_RArgs,
            rwrules_Stmt,
            rwrules_TypeExpr,
            rwrules_TypeExprs,
            rwrules_Unit,
            rwrules_Vis;

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
  propagate alluses,
            ppsep,
            ppi,
            ppterm,
            env,
            rwrules_ChInit,
            rwrules_Declarator,
            rwrules_Decls,
            rwrules_Enabler,
            rwrules_Expr,
            rwrules_Exprs,
            rwrules_IDList,
            rwrules_Inst,
            rwrules_MArgs,
            rwrules_Op,
            rwrules_Options,
            rwrules_Priority,
            rwrules_ProcType,
            rwrules_Program,
            rwrules_RArg,
            rwrules_RArgs,
            rwrules_Stmt,
            rwrules_TypeExpr,
            rwrules_TypeExprs,
            rwrules_Unit,
            rwrules_Vis;
  -- st.errors := forward.errors ;
  st.defs = emptyDefs() ;
  st.host = inlineStmt(n_ref, actuals.host);

  local res::EnvResult = lookup_name(n_ref.lexeme, st.env) ;
 
  forwards to body with { env =
    mergeDefs(
      (decorate asDecl with
        {ppi = st.ppi;
         ppsep = st.ppsep;
         alluses = st.alluses;
         env = st.env;
         rwrules_Program = st.rwrules_Program;
         rwrules_Unit = st.rwrules_Unit;
         rwrules_Decls = st.rwrules_Decls;
         rwrules_Declarator = st.rwrules_Declarator;
         rwrules_Stmt = st.rwrules_Stmt;
         rwrules_Options = st.rwrules_Options;
         rwrules_Expr = st.rwrules_Expr;
         rwrules_Exprs = st.rwrules_Exprs;
         rwrules_MArgs = st.rwrules_MArgs;
         rwrules_RArgs = st.rwrules_RArgs;
         rwrules_RArg = st.rwrules_RArg;
         rwrules_Vis = st.rwrules_Vis;
         rwrules_TypeExpr = st.rwrules_TypeExpr;
         rwrules_TypeExprs = st.rwrules_TypeExprs;
         rwrules_IDList = st.rwrules_IDList;
         rwrules_Op = st.rwrules_Op;
         rwrules_ChInit = st.rwrules_ChInit;
         rwrules_ProcType = st.rwrules_ProcType;
         rwrules_Inst = st.rwrules_Inst;
         rwrules_Priority = st.rwrules_Priority;
         rwrules_Enabler = st.rwrules_Enabler;
         })
       .defs , st.env); };
   -- we bind a formal to a Decl
   -- this Decl has the actual Expr that is to be inlined.

  local body::Stmt = case res.dcl of
           inlineDecl (_, _, s)  -> new(s)
         | _ -> error ("Should not be asking for body of inline.") end ;
--  body.env = st.env ;
  local formals::InlineArgs = case res.dcl of
           inlineDecl (_, fs, _)  -> new(fs)
         | _ -> error ("Should not be asking for formals.") end ;

  local declList::[Decls] = zipWith ( inlineArgDecl, formals.asList, actuals.asList ) ;
  local asDecl::Decls = foldr1 ( seqDecls, declList ) ;
}

abstract production inlineArgDecl
d::Decls ::= id::String actual::Expr
{
 d.pp = "Internal: " ++ id ++ " " ++ actual.pp ;
 d.defs = valueBinding(id, d) ;
}


