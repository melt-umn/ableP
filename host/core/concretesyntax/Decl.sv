grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

--Decl_c
attribute pp, ppi, ast<Decls> occurs on Decl_c ;

aspect production empty_Decl_c
dcl::Decl_c ::= 
{ dcl.pp = "";
  dcl.ast = emptyDecl();
}

aspect production decllist_c
dcl::Decl_c ::= dcllist::DeclList_c
{ dcl.pp = dcllist.pp;
  dcllist.ppi = dcl.ppi ;
  dcl.ast = dcllist.ast ;
}

--DeclList_c
attribute pp, ppi, ast<Decls> occurs on DeclList_c ;

aspect production single_Decl_c
dcls::DeclList_c ::= dcl::OneDecl_c
{ dcls.pp = dcl.pp;
  dcl.ppi = dcls.ppi;
  dcls.ast = dcl.ast ;
}

aspect production multi_Decl_c
dcls::DeclList_c ::= dcl::OneDecl_c sc::SEMI rest::DeclList_c
{ dcls.pp = dcl.pp ++ "; \n" ++ rest.pp;
  dcl.ppi = dcls.ppi;
  rest.ppi = dcls.ppi;
  dcls.ast = seqDecls(dcl.ast, rest.ast);
}

--OneDecl_c
attribute pp, ppi, ast<Decls> occurs on OneDecl_c ;

aspect production varDcls_c
d::OneDecl_c ::= v::Vis_c t::Type_c vars::VarList_c
{ d.pp = d.ppi ++ v.pp ++ " " ++ t.pp ++ " " ++ vars.pp;
  d.ast = vars.ast ; 
  vars.inTypeExpr = t.ast ;
  vars.inVis = v.ast ;
}

aspect production typeDclUNAME_c
od::OneDecl_c ::= v::Vis_c u::UNAME vars::VarList_c
{ od.pp = od.ppi ++ v.pp ++ " " ++ u.lexeme ++ " " ++ vars.pp; 
  od.ast = vars.ast ; 
  vars.inTypeExpr = unameTypeExpr(u);
  vars.inVis = v.ast ;
}

aspect production typenameDcl_c
od::OneDecl_c ::= v::Vis_c t::Type_c a::Asgn_c lc::LCURLY names::IDList_c rc::RCURLY
{ od.pp = od.ppi ++ v.pp ++ " " ++ t.pp ++ a.pp ++ "{ " ++ names.pp ++ " }" ;
  od.ast = mtypeDecls (v.ast, t.ast, names.ast) ;   }

-- Asgn
attribute pp occurs on Asgn_c ;
aspect production oneAsgn_c
a::Asgn_c ::= at::ASGN   { a.pp = " " ++ at.lexeme ++ " " ; }
aspect production noAsgn_c
a::Asgn_c ::=            { a.pp = " " ; }



-- VarList
attribute pp, ast<Decls>, inTypeExpr, inVis occurs on VarList_c ;
autocopy attribute inTypeExpr::TypeExpr ;

aspect production one_var_c
vl::VarList_c ::= iv::IVar_c
{ vl.pp = iv.pp ;      vl.ast = iv.ast ;   
}
aspect production cons_var_c
vl::VarList_c ::= iv::IVar_c ',' rest::VarList_c
{ vl.pp = iv.pp ++ " ," ++ rest.pp ; 
  vl.ast = seqDecls(iv.ast, rest.ast) ;   
}


-- IVar
attribute pp, ast<Decls>, inTypeExpr, inVis occurs on IVar_c ;

aspect production ivar_vardcl_c
iv::IVar_c ::= vd::VarDcl_c
{ iv.pp = vd.pp ; 
  iv.ast = varDecl (iv.inVis, iv.inTypeExpr, vd.ast ) ;
}
aspect production ivar_vardcl_assign_expr_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN e::Expr_c
{ iv.pp = vd.pp ++ " = " ++ e.pp ; 
  iv.ast = varAssignDecl (iv.inVis, iv.inTypeExpr, vd.ast, e.ast) ;
}
aspect production ivar_vardcl_assign_ch_init_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN ch::ChInit_c
{ iv.pp = vd.pp ++ " = " ++ ch.pp ; 
  iv.ast = varAssignDecl (iv.inVis, iv.inTypeExpr, vd.ast, exprChInit(ch.ast)) ;
}

-- ChInit
attribute pp, ast<ChInit> occurs on ChInit_c ;

aspect production ch_init_c 
ch::ChInit_c ::= '[' c::CONST ']' o::OF '{' tl::TypList_c '}'
{ ch.pp = "[ " ++ c.lexeme ++ " ]" ++ " of " ++ " { " ++ tl.pp ++ " } ";
  ch.ast = chInit(c, tl.ast);
}


--VarDcl_c
attribute pp, ppi, ast<Declarator> occurs on VarDcl_c ;

aspect production vd_id_c
vd::VarDcl_c ::= id::ID
{ vd.pp = id.lexeme;     
  vd.ast = vd_id(id);  }

aspect production vd_idconst_c
vd::VarDcl_c ::= id::ID ':' cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
  vd.ast = vd_idconst(id,cnt);   }

aspect production vd_array_c
vd::VarDcl_c ::= id::ID '[' cnt::CONST ']'
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
  vd.ast = vd_array(id,cnt);  }


-- Vis, visibility
attribute pp, ast<Vis> occurs on Vis_c ;

aspect production vis_empty_c  
v::Vis_c ::= 
{ v.pp = "" ; v.ast = vis_empty() ; }
aspect production vis_hidden_c  
v::Vis_c ::= h::HIDDEN 
{ v.pp = "hidden" ;  v.ast = vis_hidden(); }
aspect production vis_show_c   
v::Vis_c ::= s::SHOW   
{ v.pp = "show" ;  v.ast = vis_show(); }
aspect production vis_islocal_c
v::Vis_c ::= i::ISLOCAL 
{ v.pp = "local" ;  v.ast = vis_islocal() ; }

--NameList
attribute pp, ast<IDList> occurs on IDList_c ;

aspect production singleName_c
nlst::IDList_c ::= n::ID
{ nlst.pp = n.lexeme;
  nlst.ast = singleName(n);
}

aspect production snocNames_c
nlst::IDList_c ::= some::IDList_c n::ID
{ nlst.pp = some.pp ++ n.lexeme;
  nlst.ast = snocNames( some.ast ,n );
}

aspect production commaNames_c  
nlst1::IDList_c ::= nlst2::IDList_c ',' 
{ nlst1.pp = nlst2.pp ++ ",";
  nlst1.ast = nlst2.ast ;
}











