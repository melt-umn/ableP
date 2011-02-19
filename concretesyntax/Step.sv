grammar edu:umn:cs:melt:ableP:concretesyntax ;


--synthesized attribute ast_Vis::Vis occurs on Vis_c;
--synthesized attribute ast_Asgn::Asgn occurs on Asgn_c;
--synthesized attribute ast_VrefList::VrefList occurs on VrefList_c;
--synthesized attribute ast_TypList::TypList occurs on TypList_c;
--synthesized attribute ast_VarDcl::VarDcl occurs on VarDcl_c;
--synthesized attribute ast_ChInit::ChInit occurs on ChInit_c;

--????????nonterminal Type_c with pp ;
--synthesized attribute ast_Type::Type occurs on Type_c, BaseType_c;


-- Step
nonterminal Step_c with pp ;  -- same as v4.2.9 and v6
concrete production one_decl_c
s::Step_c ::= od::OneDecl_c
{ s.pp = od.pp ;
--  od.ppi = s.ppi;
--  s.ast_Stmt = one_decl(od.ast_Decls);
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
--  st.ppi = s.ppi;
--  s.ast_Stmt = st.ast_Stmt;
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

-- VarList
nonterminal VarList_c with pp ;   -- same as v4.2.9 and v6
--attribute ast_VarDcl occurs on VarList_c,IVar_c;

concrete production one_var_c
vl::VarList_c ::= iv::IVar_c
{ vl.pp = iv.pp ; 
--  iv.typein = vl.typein;
--  iv.visibility = vl.visibility;
--  vl.treedcl = iv.treedcl;
}

concrete production cons_var_c
vl::VarList_c ::= iv::IVar_c ',' vltail::VarList_c
{ vl.pp = iv.pp ++ " ," ++ vltail.pp ; 

--  iv.typein = vl.typein;
--  iv.visibility = vl.visibility;
--  vltail.visibility = vl.visibility;
--  vltail.typein = vl.typein;
--  vl.treedcl = seqDecls(iv.treedcl,vltail.treedcl);
}


-- IVar
nonterminal IVar_c with pp;   -- same as in v4.2.9 and v6
--attribute typein occurs on IVar_c;
--attribute treedcl occurs on IVar_c;

concrete production ivar_vardcl_c
iv::IVar_c ::= vd::VarDcl_c
{ iv.pp = vd.pp ; 

--  vd.typein = iv.typein;
--  iv.treedcl = vd.treedcl;
--  vd.visibility = iv.visibility;
}

concrete production ivar_vardcl_assign_expr_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN e::Expr_c
{ iv.pp = vd.pp ++ " = " ++ e.pp ; 
 
--  vd.typein = iv.typein;
--  iv.treedcl = varAssignDecl(iv.visibility, vd.typein, vd.ast_VarDcl, e.ast_Expr);
--  vd.visibility = iv.visibility; 
}

concrete production ivar_vardcl_assign_ch_init_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN ch::ChInit_c
{ iv.pp = vd.pp ++ " = " ++ ch.pp ; 

--  vd.typein = iv.typein;
--  iv.treedcl = varAssignDecl( iv.visibility, vd.typein, vd.ast_VarDcl, abs_expr_chinit(ch.ast_ChInit) );
--  vd.visibility = iv.visibility;
}

-- ChInit
nonterminal ChInit_c with pp;   -- same as in v4.2.9 and v6
concrete production ch_init_c 
ch::ChInit_c ::= '[' c::CONST ']' o::OF '{' tl::TypList_c '}'
{ ch.pp = "[ " ++ c.lexeme ++ " ]" ++ " of " ++ " { " ++ tl.pp ++ " } ";
-- ch.ast_ChInit = ch_init(c,tl.ast_TypList);
}

--VarDcl
nonterminal VarDcl_c with pp, ppi ;   -- same as in v4.2.9 and v6
--attribute typein occurs on VarDcl_c;
--attribute treedcl occurs on VarDcl_c;

concrete production vd_id_c
vd::VarDcl_c ::= id::ID
{ vd.pp = id.lexeme;
--  vd.ast_VarDcl = vd_id(id);
--  vd.treedcl = varDecl(vd.visibility, vd.typein, vd_id(id));
}

concrete production vd_idconst_c
vd::VarDcl_c ::= id::ID ':' cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;

--  vd.ast_VarDcl = vd_idconst(id,cnt);
--  vd.treedcl = varDecl(vd.visibility, vd.typein, vd_idconst(id,cnt));
}

concrete production vd_array_c
vd::VarDcl_c ::= id::ID '[' cnt::CONST ']'
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";

--  vd.ast_VarDcl = vd_array(id,cnt);
--  vd.treedcl = varDecl(vd.visibility, vd.typein, vd_array(id,cnt));
}





