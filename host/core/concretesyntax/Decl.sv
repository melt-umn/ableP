grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

--Decl_c
nonterminal Decl_c with pp, ppi, ast<Decls>;   -- same as in v4.2.9 and v6

concrete production empty_Decl_c
dcl::Decl_c ::= 
{ dcl.pp = "";
  dcl.ast = emptyDecl();
}

concrete production decllist_c
dcl::Decl_c ::= dcllist::DeclList_c
{ dcl.pp = dcllist.pp;
  dcllist.ppi = dcl.ppi ;
  dcl.ast = dcllist.ast ;
}

--DeclList_c
nonterminal DeclList_c with pp, ppi, ast<Decls> ;    -- same as in v4.2.9 and v6

concrete production single_Decl_c
dcls::DeclList_c ::= dcl::OneDecl_c
{ dcls.pp = dcl.pp;
  dcl.ppi = dcls.ppi;
  dcls.ast = dcl.ast ;
}

concrete production multi_Decl_c
dcls::DeclList_c ::= dcl::OneDecl_c sc::SEMI rest::DeclList_c
{ dcls.pp = dcl.pp ++ "; \n" ++ rest.pp;
  dcl.ppi = dcls.ppi;
  rest.ppi = dcls.ppi;
  dcls.ast = seqDecls(dcl.ast, rest.ast);
}

--OneDecl_c
nonterminal OneDecl_c with pp, ppi, ast<Decls> ;   -- same as in v4.2.9 and v6

concrete production varDcls_c
d::OneDecl_c ::= v::Vis_c t::Type_c vars::VarList_c
{ d.pp = d.ppi ++ v.pp ++ " " ++ t.pp ++ " " ++ vars.pp;
  d.ast = vars.ast ; -- varDecl (v.ast, t.ast, vars.ast) ;
  vars.inTypeExpr = t.ast ;
  vars.inVis = v.ast ;
}

concrete production typeDclUNAME_c
od::OneDecl_c ::= v::Vis_c u::UNAME vars::VarList_c
{ od.pp = od.ppi ++ v.pp ++ " " ++ u.lexeme ++ " " ++ vars.pp; 
  od.ast = vars.ast ; 
  vars.inTypeExpr = unameTypeExpr(u);
  vars.inVis = v.ast ;
}

concrete production typenameDcl_c
od::OneDecl_c ::= v::Vis_c t::Type_c a::Asgn_c lc::LCURLY names::IDList_c rc::RCURLY
{ od.pp = od.ppi ++ v.pp ++ " " ++ t.pp ++ a.pp ++ "{ " ++ names.pp ++ " }" ;
  od.ast = mtypeDecls (v.ast, t.ast, names.ast) ;   }

-- Asgn
nonterminal Asgn_c with pp ;    -- same as in v4.2.9 and v6
concrete productions
a::Asgn_c ::= at::ASGN   { a.pp = " " ++ at.lexeme ++ " " ; }
a::Asgn_c ::=            { a.pp = " " ; }



-- VarList
nonterminal VarList_c with pp, ast<Decls>, inTypeExpr, inVis ;   -- same as v4.2.9 and v6
synthesized attribute cst_VarList_c::VarList_c occurs on Decls ;
autocopy attribute inTypeExpr::TypeExpr ;

concrete production one_var_c
vl::VarList_c ::= iv::IVar_c
{ vl.pp = iv.pp ;      vl.ast = iv.ast ;   
}
concrete production cons_var_c
vl::VarList_c ::= iv::IVar_c ',' rest::VarList_c
{ vl.pp = iv.pp ++ " ," ++ rest.pp ; 
  vl.ast = seqDecls(iv.ast, rest.ast) ;   
}


-- IVar
nonterminal IVar_c with pp, ast<Decls>, inTypeExpr, inVis;   -- same as in v4.2.9 and v6
synthesized attribute cst_IVar_c::IVar_c occurs on Decls ;

concrete production ivar_vardcl_c
iv::IVar_c ::= vd::VarDcl_c
{ iv.pp = vd.pp ; 
  iv.ast = varDecl (iv.inVis, iv.inTypeExpr, vd.ast ) ;
}
concrete production ivar_vardcl_assign_expr_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN e::Expr_c
{ iv.pp = vd.pp ++ " = " ++ e.pp ; 
  iv.ast = varAssignDecl (iv.inVis, iv.inTypeExpr, vd.ast, e.ast) ;
}
concrete production ivar_vardcl_assign_ch_init_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN ch::ChInit_c
{ iv.pp = vd.pp ++ " = " ++ ch.pp ; 
  iv.ast = varAssignDecl (iv.inVis, iv.inTypeExpr, vd.ast, exprChInit(ch.ast)) ;
}

-- ChInit
nonterminal ChInit_c with pp, ast<ChInit> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_ChInit_c::ChInit_c occurs on ChInit ;

concrete production ch_init_c 
ch::ChInit_c ::= '[' c::CONST ']' o::OF '{' tl::TypList_c '}'
{ ch.pp = "[ " ++ c.lexeme ++ " ]" ++ " of " ++ " { " ++ tl.pp ++ " } ";
  ch.ast = chInit(c, tl.ast);
}


--VarDcl_c
nonterminal VarDcl_c with pp, ppi, ast<Declarator> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_VarDcl_c::VarDcl_c occurs on Declarator ;

concrete production vd_id_c
vd::VarDcl_c ::= id::ID
{ vd.pp = id.lexeme;     
  vd.ast = vd_id(id);  }

concrete production vd_idconst_c
vd::VarDcl_c ::= id::ID ':' cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
  vd.ast = vd_idconst(id,cnt);   }

concrete production vd_array_c
vd::VarDcl_c ::= id::ID '[' cnt::CONST ']'
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
  vd.ast = vd_array(id,cnt);  }


-- Vis, visibility
nonterminal Vis_c with pp, ast<Vis> ;  -- same as in v4.2.9 and v6
synthesized attribute cst_Vis_c::Vis_c occurs on Vis ;

concrete production vis_empty_c  
v::Vis_c ::= 
{ v.pp = "" ; v.ast = vis_empty() ; }
concrete production vis_hidden_c  
v::Vis_c ::= h::HIDDEN 
{ v.pp = "hidden" ;  v.ast = vis_hidden(); }
concrete production vis_show_c   
v::Vis_c ::= s::SHOW   
{ v.pp = "show" ;  v.ast = vis_show(); }
concrete production vis_islocal_c
v::Vis_c ::= i::ISLOCAL 
{ v.pp = "local" ;  v.ast = vis_islocal() ; }







--NameList
nonterminal IDList_c with pp, ast<IDList> ;   -- same as v4.2.9 and v6
synthesized attribute cst_IDList_c::IDList_c occurs on IDList ;
-- nlst in spin.y

concrete production singleName_c
nlst::IDList_c ::= n::ID
{ nlst.pp = n.lexeme;
  nlst.ast = singleName(n);
}

concrete production snocNames_c
nlst::IDList_c ::= some::IDList_c n::ID
{ nlst.pp = some.pp ++ n.lexeme;
  nlst.ast = snocNames( some.ast ,n );
}

concrete production commaNames_c  
nlst1::IDList_c ::= nlst2::IDList_c ','   -- commas are optional
{ nlst1.pp = nlst2.pp ++ ",";
  nlst1.ast = nlst2.ast ;
}











