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
  stmt.env = d.env;
  stmt.ppi = "   ";
  stmt.ppsep = "; \n";
  stmt.alluses = d.alluses;
  stmt.rwrules_Program = d.rwrules_Program;
  stmt.rwrules_Unit = d.rwrules_Unit;
  stmt.rwrules_Decls = d.rwrules_Decls;
  stmt.rwrules_Declarator = d.rwrules_Declarator;
  stmt.rwrules_Stmt = d.rwrules_Stmt;
  stmt.rwrules_Options = d.rwrules_Options;
  stmt.rwrules_Expr = d.rwrules_Expr;
  stmt.rwrules_Exprs = d.rwrules_Exprs;
  stmt.rwrules_MArgs = d.rwrules_MArgs;
  stmt.rwrules_RArgs = d.rwrules_RArgs;
  stmt.rwrules_RArg = d.rwrules_RArg;
  stmt.rwrules_Vis = d.rwrules_Vis;
  stmt.rwrules_TypeExpr = d.rwrules_TypeExpr;
  stmt.rwrules_TypeExprs = d.rwrules_TypeExprs;
  stmt.rwrules_IDList = d.rwrules_IDList;
  stmt.rwrules_Op = d.rwrules_Op;
  stmt.rwrules_ChInit = d.rwrules_ChInit;
  stmt.rwrules_ProcType = d.rwrules_ProcType;
  stmt.rwrules_Inst = d.rwrules_Inst;
  stmt.rwrules_Priority = d.rwrules_Priority;
  stmt.rwrules_Enabler = d.rwrules_Enabler;

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
  actuals.env = st.env;
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


