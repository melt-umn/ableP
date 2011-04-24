grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

-- Step
attribute pp, ppi, ast<Stmt> occurs on Step_c ;

aspect production one_decl_c
s::Step_c ::= od::OneDecl_c
{ s.pp = od.pp ;   od.ppi = s.ppi;
  s.ast = one_decl(od.ast);
}

aspect production step_stamt_c
s::Step_c ::= st::Stmt_c
{ s.pp = st.pp;    st.ppi = s.ppi;
  s.ast = st.ast;
}

aspect production vref_lst_c
s::Step_c ::= xu::XU vlst::VrefList_c
{ s.pp = xu.lexeme ++ " " ++ vlst.pp ;
  s.ast = xuStmt( xu, vlst.ast );
}

aspect production name_od_c
s::Step_c ::= id::ID ':' od::OneDecl_c
{ s.pp = id.lexeme ++ ":" ++ od.pp;
  s.ast = namedDecl( id, od.ast );
}

aspect production name_xu_c
s::Step_c ::= id::ID ':' xu::XU
{ s.pp = id.lexeme ++ ":" ++ xu.lexeme ;
  s.ast = namedXUStmt( id, xu );
}

aspect production unless_c
s::Step_c ::= st1::Stmt_c un::UNLESS st2::Stmt_c
{ s.pp = st1.pp ++ "\n unless \n" ++ st2.pp ++ "\n";
  s.ast = unlessStmt( st1.ast, st2.ast );
}


-- VrefList
attribute pp, ast<Exprs> occurs on VrefList_c ;

aspect production single_varref_c
vrl::VrefList_c ::= vref::Varref_c
{ vrl.pp = vref.pp;
  vrl.ast = oneExprs(vref.ast) ;
}

aspect production comma_varref_c
vrls::VrefList_c ::= vref::Varref_c ',' rest::VrefList_c
{ vrls.pp = vref.pp ++ "," ++ rest.pp;
  vrls.ast = consExprs( vref.ast, rest.ast );
}







