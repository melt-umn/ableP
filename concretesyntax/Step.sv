grammar edu:umn:cs:melt:ableP:concretesyntax ;


--synthesized attribute ast_Vis::Vis occurs on Vis_c;
--synthesized attribute ast_VrefList::VrefList occurs on VrefList_c;
--synthesized attribute ast_TypList::TypList occurs on TypList_c;
--synthesized attribute ast_VarDcl::VarDcl occurs on VarDcl_c;
--synthesized attribute ast_ChInit::ChInit occurs on ChInit_c;

--????????nonterminal Type_c with pp ;
--synthesized attribute ast_Type::Type occurs on Type_c, BaseType_c;


-- Step
nonterminal Step_c with pp, ppi, ast<Stmt> ;  -- same as v4.2.9 and v6
concrete production one_decl_c
s::Step_c ::= od::OneDecl_c
{ s.pp = od.pp ;
  od.ppi = s.ppi;
  s.ast = one_decl(od.ast);
}

concrete production vref_lst_c
s::Step_c ::= xu::XU vlst::VrefList_c
{ s.pp = xu.lexeme ++ " " ++ vlst.pp ;
--  s.ast_Stmt = vref_lst(xu,vlst.ast_VrefList);
}

concrete production name_od_c
s::Step_c ::= id::ID ':' od::OneDecl_c
{ s.pp = id.lexeme ++ ":" ++ od.pp;
--  s.ast_Stmt = name_od(id,od.ast_Decls);
}

concrete production name_xu_c
s::Step_c ::= id::ID ':' xu::XU
{ s.pp = id.lexeme ++ ":" ++ xu.lexeme ;
--  s.ast_Stmt = name_xu(id,xu);
}

concrete production step_stamt_c
s::Step_c ::= st::Stmt_c
{ s.pp = st.pp;
  st.ppi = s.ppi;
  s.ast = st.ast;
}

concrete production stmt_stmt_c
s::Step_c ::= st1::Stmt_c un::UNLESS st2::Stmt_c
{ s.pp = st1.pp ++ "\n unless \n" ++ st2.pp ++ "\n";
--  st1.ppi = s.ppi;
--  st2.ppi = s.ppi;
--  s.ast_Stmt = unless_stmt(st1.ast_Stmt,st2.ast_Stmt);
}



--VrefList
nonterminal VrefList_c with pp;   -- same as v4.2.9 and v6

concrete production single_varref_c
vrl::VrefList_c ::= vref::Varref_c
{ vrl.pp = vref.pp;
--  vrl.ast_VrefList = single_varref(vref.ast_Expr);
}

concrete production comma_varref_c
vrl1::VrefList_c ::= vref::Varref_c ',' vrl2::VrefList_c
{ vrl1.pp = vref.pp ++ "," ++ vrl2.pp;
--  vrl1.ast_VrefList = comma_varref(vref.ast_Expr,vrl2.ast_VrefList);
}







