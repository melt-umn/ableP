grammar edu:umn:cs:melt:ableP:concretesyntax ;

nonterminal Unit_c with pp, ppi;
----------------------------------------
synthesized attribute ast_Unit::Unit occurs on Unit_c ;
--unit	: proc		/* proctype { }       */
--	| init		/* init { }           */
--	| claim		/* never claim        */
--	| ltl		/* ltl formula        */
--	| events	/* event assertions   */
--	| one_decl	/* variables, chans   */
--	| utype		/* user defined types */
--	| c_fcts	/* c functions etc.   */
--	| ns		/* named sequence     */
--	| SEMI		/* optional separator */
--	| error

concrete production unit_proc_c
u::Unit_c ::= p::Proc_c
{ u.pp = p.pp ;
--  u.ast_Unit = p.ast_Unit; 
}
action
{
  usedProcess = 0;
}

concrete production unit_init_c
u::Unit_c ::= i::Init_c
{ u.pp = i.pp;
--  u.ast_Unit = i.ast_Unit;  
}

concrete production unit_claim_c
u::Unit_c ::= c::Claim_c
{ u.pp = c.pp ;
--  u.ast_Unit = c.ast_Unit;  
}

{- v6
concrete production unit_ltl_c
u::Unit_c ::= l::LTL_c
{ u.pp = l.pp ;
  u.ast_Unit = l.ast_Unit;  }
-}

concrete production unit_events_c
u::Unit_c ::= e::Events_c
{ u.pp = e.pp;
--  u.ast_Unit = e.ast_Unit;  
}

concrete production unit_one_decl_c
u::Unit_c ::= dec::OneDecl_c
{ u.pp = dec.pp ;
--  u.ast_Unit = dec.ast_Unit;  
}

concrete production unit_utype_c
u::Unit_c ::= ut::Utype_c
{ u.pp = ut.pp ;
--  u.ast_Unit = ut.ast_Unit;  
}

{- v6
concrete production unit_c_fcts_c
u::Unit_c ::= c::Cfcts_c
{ u.pp = c.pp ;
  u.ast_Unit = c.ast_Unit;  }
-}

concrete production unit_ns_c
u::Unit_c ::= ns::NS_c
{ u.pp = ns.pp ;
--  u.ast_Unit = ns.ast_Unit;  
}
action
{   usedInline = 1;   }

concrete production unit_semi_c
u::Unit_c ::= se::SEMI
{ u.pp = ";\n";
--  u.ast_Unit = unit_semi();   
}

concrete production unit_error_c
u::Unit_c ::= er::Error_c
{ u.pp = er.pp ;    }


--Claim

nonterminal Claim_c with pp;

--synthesized attribute ast_Body::Body occurs on Body_c;
--synthesized attribute ast_OptPriority::OptPriority occurs on OptPriority_c;
--synthesized attribute ast_Args::Args occurs on Args_c;
--attribute ast_Stmt occurs on Statement_c;

concrete production claim_c
c::Claim_c ::= ck::CLAIM body::Body_c
{ c.pp = "never " ++ body.ppi ++ body.pp ;
  body.ppi = "  ";
--  c.ast_Unit = claim(body.ast_Body);
}

--Events

nonterminal Events_c with pp;

concrete production events_c
e::Events_c ::= tr::TRACE body::Body_c
{ e.pp = "\n trace " ++ body.pp;
  body.ppi = "  ";
-- e.ast_Unit = events(body.ast_Body);
}

--Init

nonterminal Init_c with pp;

concrete production init_c
i::Init_c ::= it::INIT op::OptPriority_c body::Body_c
{ i.pp = "\n init" ++ op.pp ++ body.ppi ++ body.pp;
  body.ppi = "  ";
-- i.ast_Unit = init(op.ast_OptPriority,body.ast_Body);
}


--Utype

nonterminal Utype_c with pp;

concrete production utype_dcllist_c
u::Utype_c ::= td::TYPEDEF id::ID '{' dl::DeclList_c '}'
{ u.pp = " typedef " ++ id.lexeme ++ " \n{ " ++ dl.pp ++ " \n} ";
  dl.ppi = "  ";
-- u.ast_Unit = utype_dcllist(id,dl.ast_Decls);
}
action
{
  local attribute getUname::String;
  getUname = id.lexeme;
  unames = if (!listContains(getUname,unames))
           then [getUname] ++ unames
           else unames;
}


--Error
nonterminal Error_c with pp;

concrete production error_type_c
er::Error_c ::= ty::Type_c ':' ct::CONST
{ er.pp = ty.pp ++ ":" ++ ct.lexeme;
}

-- NS
nonterminal NS_c with pp;

-- inline declarations --
-------------------------

concrete production inline_dcl_iname_c
ns::NS_c ::= il::INLINE ina::INAME '(' args::Inline_Args_c ')' stmt::Statement_c
{ ns.pp = "\n inline " ++ ina.lexeme ++ "(" ++ args.pp ++ ")\n" ++  stmt.pp;
  stmt.ppi = "  ";

-- ns.ast_Unit = inline_dcl(terminal(ID,ina.lexeme, ina.line, ina.column), 
--                          args.ast_Inline_Args, stmt.ast_Stmt);
}
action
{ -- Add the name of this inline (ina.lexeme) to the list of inline names (inames)
  -- if it is not already in the list.

  local attribute getIname::String;
  getIname = ina.lexeme;
  inames = if(!listContains(getIname,inames))
           then [getIname] ++ inames
           else inames;
}


concrete production inline_dcl_id_c
ns::NS_c ::= il::INLINE id::ID '(' args::Inline_Args_c ')' stmt::Statement_c
{ ns.pp = "\ninline " ++ id.lexeme ++ "(" ++ args.pp ++ ")\n" ++  stmt.pp;
  stmt.ppi = " ";
-- ns.ast_Unit = inline_dcl(id, args.ast_Inline_Args, stmt.ast_Stmt);
}
action
{ -- Add the name of this inline (ina.lexeme) to the list of inline names (inames)
  -- if it is not already in the list.

  local attribute getIname::String;
  getIname = id.lexeme;
  inames = if(!listContains(getIname,inames))
           then [getIname] ++ inames
           else inames;
}


nonterminal Inline_Args_c with pp ;
-- synthesized attribute ast_Inline_Args :: Inline_Args occurs on Inline_Args_c ;

concrete production inline_args_one_c
a::Inline_Args_c ::= id::ID
{ a.pp = id.lexeme ;
-- a.ast_Inline_Args = inline_args_one(id) ;
}

concrete production inline_args_none_c
a::Inline_Args_c ::=
{ a.pp = "" ;
-- a.ast_Inline_Args = inline_args_none() ;
}

concrete production inline_args_cons_c
a::Inline_Args_c ::= id::ID ',' rest::Inline_Args_c
{ a.pp = id.lexeme ++ ", " ++ rest.pp ;
-- a.ast_Inline_Args = inline_args_cons(id, rest.ast_Inline_Args);
}






