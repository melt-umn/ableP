grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

-- Step
nonterminal Step_c with pp, ppi, ast<Stmt> ;  -- same as v4.2.9 and v6

concrete production one_decl_c
s::Step_c ::= od::OneDecl_c
{ s.pp = od.pp ;   od.ppi = s.ppi;
  s.ast = one_decl(od.ast);
}

concrete production step_stamt_c
s::Step_c ::= st::Stmt_c
{ s.pp = st.pp;    st.ppi = s.ppi;
  s.ast = st.ast;
}

concrete production vref_lst_c
s::Step_c ::= xu::XU vlst::VrefList_c
{ s.pp = xu.lexeme ++ " " ++ vlst.pp ;
  s.ast = xuStmt( xu, vlst.ast );
}

concrete production name_od_c
s::Step_c ::= id::ID ':' od::OneDecl_c
{ s.pp = id.lexeme ++ ":" ++ od.pp;
  s.ast = namedDecl( id, od.ast );
}

concrete production name_xu_c
s::Step_c ::= id::ID ':' xu::XU
{ s.pp = id.lexeme ++ ":" ++ xu.lexeme ;
  s.ast = namedXUStmt( id, xu );
}

concrete production unless_c
s::Step_c ::= st1::Stmt_c un::UNLESS st2::Stmt_c
{ s.pp = st1.pp ++ "\n unless \n" ++ st2.pp ++ "\n";
  s.ast = unlessStmt( st1.ast, st2.ast );
}


-- VrefList
nonterminal VrefList_c with pp, ast<Exprs> ;   -- same as v4.2.9 and v6

concrete production single_varref_c
vrl::VrefList_c ::= vref::Varref_c
{ vrl.pp = vref.pp;
  vrl.ast = oneExprs(vref.ast) ;
}

concrete production comma_varref_c
vrls::VrefList_c ::= vref::Varref_c ',' rest::VrefList_c
{ vrls.pp = vref.pp ++ "," ++ rest.pp;
  vrls.ast = consExprs( vref.ast, rest.ast );
}







