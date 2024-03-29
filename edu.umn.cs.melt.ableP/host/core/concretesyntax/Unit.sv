grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

attribute pp, ppi, ast<PUnit> occurs on Unit_c ;
propagate ppi on Unit_c;


aspect production unit_proc_c
u::Unit_c ::= p::Proc_c
{ u.pp = p.pp ;    u.ast = unitDecls(p.ast) ;  }

aspect production unit_init_c
u::Unit_c ::= i::Init_c
{ u.pp = i.pp;    u.ast = i.ast;   }

aspect production unit_claim_c
u::Unit_c ::= c::Claim_c
{ u.pp = c.pp ;   u.ast = c.ast;   }

aspect production unit_events_c
u::Unit_c ::= e::Events_c
{ u.pp = e.pp;  u.ast = e.ast;  }

aspect production unit_one_decl_c
u::Unit_c ::= dec::OneDecl_c
{ u.pp = dec.pp ;  u.ast = unitDecls(dec.ast) ;   }

aspect production unit_utype_c
u::Unit_c ::= ut::Utype_c
{ u.pp = ut.pp ;  u.ast = ut.ast;  }

aspect production unit_ns_c
u::Unit_c ::= ns::NS_c
{ u.pp = ns.pp ; u.ast = ns.ast;   }

aspect production unit_semi_c
u::Unit_c ::= se::SEMI
{ u.pp = ";\n";      u.ast = emptyUnit() ;  }



--Init 
attribute pp, ppi, ast<PUnit> occurs on Init_c ;
synthesized attribute cst_Init_c :: Init_c occurs on PUnit ;

aspect production init_c
i::Init_c ::= it::INIT op::OptPriority_c body::Body_c
{ i.pp = i.ppi ++ "init" ++ op.pp ++ body.pp;
  body.ppi = "  " ++ i.ppi ;
  i.ast = initConstruct(op.ast, body.ast);
}

--Claim  
attribute pp, ppi, ast<PUnit> occurs on Claim_c ;

aspect production claim_c
c::Claim_c ::= ck::CLAIM body::Body_c
{ c.pp = c.ppi ++ "never " ++ body.pp ;
  body.ppi = "  " ++ c.ppi ;
  c.ast = claim(body.ast);
}

--Events 
attribute pp, ppi, ast<PUnit> occurs on Events_c ;

aspect production events_c
e::Events_c ::= tr::TRACE body::Body_c
{ e.pp = e.ppi ++ "trace " ++ body.pp;
  body.ppi = "  " ++ e.ppi ;
  e.ast = events(body.ast);
}

--Utype
attribute pp, ppi, ast<PUnit> occurs on Utype_c ;
synthesized attribute cst_Utype_c :: Utype_c occurs on PUnit ;

aspect production utype_dcllist_c
u::Utype_c ::= td::TYPEDEF id::ID '{' dl::DeclList_c '}'
{ u.pp = u.ppi ++ "typedef " ++ id.lexeme ++ " { " ++ dl.pp ++ " }";
  dl.ppi = "  " ++ u.ppi ;
  dl.ppsep = " " ;
  u.ast = unitDecls(typedefDecls( id, dl.ast )) ;
}


-- NM
attribute pp, ppi occurs on NM_c ;
propagate ppi on NM_c;
aspect production nameNM_c
nm::NM_c ::= n::ID     { nm.pp = n.lexeme ; }
aspect production unameNM_c
nm::NM_c ::= n::UNAME  { nm.pp = n.lexeme ; }

-- NS
attribute pp, ppi, ast<PUnit> occurs on NS_c ;
synthesized attribute cst_NS_c::NS_c occurs on PUnit ;

aspect production inline_dcl_iname_c
ns::NS_c ::= il::INLINE ina::NM_c '(' args::InlineArgs_c ')' stmt::Statement_c
{ ns.pp = ns.ppi ++ "inline " ++ ina.pp ++ "(" ++ args.pp ++ ")\n" ++ 
          ns.ppi ++ stmt.pp;
  stmt.ppi = "  " ++ ns.ppi ;

  ns.ast = unitDecls( inlineDecl( terminal(ID, ina.pp, il.location), 
                                  args.ast, stmt.ast ) );
}


attribute pp, ast<InlineArgs> occurs on InlineArgs_c;

aspect production inline_args_none_c
a::InlineArgs_c ::=
{ a.pp = "" ;
  a.ast = noneInlineArgs() ;
}

aspect production inline_args_one_c
a::InlineArgs_c ::= id::ID
{ a.pp = id.lexeme ;
  a.ast = consInlineArgs(id, noneInlineArgs()) ;
}

aspect production inline_args_cons_c
a::InlineArgs_c ::= id::ID ',' rest::InlineArgs_c
{ a.pp = id.lexeme ++ ", " ++ rest.pp ;
 a.ast = consInlineArgs(id, rest.ast);
}






