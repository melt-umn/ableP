grammar edu:umn:cs:melt:ableP:concretesyntax ;

nonterminal Unit_c with pp, ppi, ast<Unit> ; -- the same in v4.2.9 and v6
----------------------------------------
-- synthesized attribute ast_Unit::Unit occurs on Unit_c ;
--unit	: proc		/* proctype { }       */
--	| init		/* init { }           */
--	| claim		/* never claim        */
--	| events	/* event assertions   */
--	| one_decl	/* variables, chans   */
--	| utype		/* user defined types */
--	| c_fcts	/* c functions etc.   */
--	| ns		/* named sequence     */
--	| SEMI		/* optional separator */

concrete production unit_proc_c
u::Unit_c ::= p::Proc_c
{ u.pp = p.pp ;
  u.ast = unitDecls(p.ast) ;
}
action { usedProcess = 0; }

concrete production unit_init_c
u::Unit_c ::= i::Init_c
{ u.pp = i.pp;  u.ast = i.ast;   }

concrete production unit_claim_c
u::Unit_c ::= c::Claim_c
{ u.pp = c.pp ;   u.ast = c.ast;   }

--	| ltl		/* ltl formula        */
-- ltl new for v6, in LTL.sv

concrete production unit_events_c
u::Unit_c ::= e::Events_c
{ u.pp = e.pp;  u.ast = e.ast;  }

concrete production unit_one_decl_c
u::Unit_c ::= dec::OneDecl_c
{ u.pp = dec.pp ;  u.ast = unitDecls(dec.ast) ;  
}

concrete production unit_utype_c
u::Unit_c ::= ut::Utype_c
{ u.pp = ut.pp ;  u.ast = ut.ast;  }

concrete production unit_c_fcts_c
u::Unit_c ::= cf::C_Fcts_c
{ u.pp = cf.pp ;  u.ast = cf.ast ;
}

concrete production unit_ns_c
u::Unit_c ::= ns::NS_c
{ u.pp = ns.pp ; u.ast = ns.ast;   }
action { usedInline = 1; }

concrete production unit_semi_c
u::Unit_c ::= se::SEMI
{ u.pp = ";\n"; 
  u.ast = emptyUnit() ;  }



--Init 
nonterminal Init_c with pp, ast<Unit> ;   -- same in v4.2.9 and v6
synthesized attribute cst_Init_c :: Init_c occurs on Unit ;

concrete production init_c
i::Init_c ::= it::INIT op::OptPriority_c body::Body_c
{ i.pp = "\n init" ++ op.pp ++ body.ppi ++ body.pp;
  body.ppi = "  ";
  i.ast = init(op.ast, body.ast);
}

--Claim  
nonterminal Claim_c with pp, ast<Unit> ; -- same in v4.2.9, new prod added to get to v6
synthesized attribute cst_Claim_c :: Claim_c occurs on Unit ;

--synthesized attribute ast_Body::Body occurs on Body_c;
--synthesized attribute ast_OptPriority::OptPriority occurs on OptPriority_c;
--synthesized attribute ast_Args::Args occurs on Args_c;
--attribute ast_Stmt occurs on Statement_c;

-- in v6 this rhs is CLAIM optname body - s v6.sv for the new stuff
concrete production claim_c
c::Claim_c ::= ck::CLAIM body::Body_c
{ c.pp = "never " ++ body.ppi ++ body.pp ;
  body.ppi = "  ";
--  c.ast_Unit = claim(body.ast_Body);
}

--Events 
nonterminal Events_c with pp, ast<Unit> ;  --  same in v4.2.9 and v6
synthesized attribute cst_Events_c :: Events_c occurs on Unit ;

concrete production events_c
e::Events_c ::= tr::TRACE body::Body_c
{ e.pp = "\n trace " ++ body.pp;
  body.ppi = "  ";
-- e.ast_Unit = events(body.ast_Body);
}



--Utype
nonterminal Utype_c with pp, ast<Unit>;  -- same in v4.2.9 and v6
synthesized attribute cst_Utype_c :: Utype_c occurs on Unit ;

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



-- inline declarations --
-------------------------

{- The following two are done differently in v6 and v4.2.9

nm	: NAME			{ $$ = $1; }
	| INAME			{ $$ = $1;
				  if (IArgs)
				  fatal("invalid use of '%s'", $1->sym->name);
				}
	;

ns	: INLINE nm '('		{ NamesNotAdded++; }
	  args ')'		{ prep_inline($2->sym, $5);
				  NamesNotAdded--;
				}
	;

We do things differently because the Spin parser actually reads the
statements in a defined inlined unit using a procedure so that the
Statements aren't seen in the parse rule of the definitin.  This text
is then inserted into the input stream so that they can be parsed by
the Statements nonterminal that is in the inline use.  Quite crazy...
-}

{-
nonterminal NM with pp ;  -- not used by us for inlining
concrete production nameNM_c
nm::NM ::= n::ID 
{ nm.pp = n.lexeme ; }

concrete production unameNM_c
nm::NM ::= un::UNAME
{ nm.pp = un.lexeme ; }
-}

-- NS
nonterminal NS_c with pp, ast<Unit>;  -- different! but equal! can be fixed with new parser attr.
synthesized attribute cst_NS_c::NS_c occurs on Unit ;


concrete production inline_dcl_iname_c
ns::NS_c ::= il::INLINE ina::INAME '(' args::Args_c ')' stmt::Statement_c
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
ns::NS_c ::= il::INLINE id::ID '(' args::Args_c ')' stmt::Statement_c
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

{- ToDo   -- Why did we treat these differently before?
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
-}





