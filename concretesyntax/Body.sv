grammar edu:umn:cs:melt:ableP:concretesyntax ;

nonterminal Body_c with pp;
nonterminal Sequence_c with pp;
nonterminal OS_c with pp ;
nonterminal MS_c with pp ;

attribute ppi occurs on Sequence_c,Step_c;
--attribute ast_Stmt occurs on Sequence_c;
--synthesized attribute ast_OS::OS occurs on OS_c;
--synthesized attribute ast_MS::MS occurs on MS_c;

concrete production body_statements_c
b::Body_c ::= '{' s::Sequence_c os::OS_c '}'
{ b.pp = "\n{\n" ++ s.ppi ++ s.pp ++ os.pp ++ " \n}";
  s.ppi = b.ppi ++ "  " ;
-- b.ast_Body = body_stmts(s.ast_Stmt);
}

-- Sequence
concrete production single_step_c
s::Sequence_c ::= st::Step_c
{ s.pp =  st.pp;
  st.ppi = s.ppi;
-- s.ast_Stmt = st.ast_Stmt;
}

concrete production cons_step_c
s::Sequence_c ::= s2::Sequence_c ms::MS_c st::Step_c
{ s.pp = s2.pp ++ ms.pp ++ "\n" ++ s.ppi ++ st.pp;
  s2.ppi = s.ppi;
  st.ppi = s.ppi ;
--  s.ast_Stmt = stmt_seq(s2.ast_Stmt,st.ast_Stmt);
}

-- OS
concrete production os_no_semi_c
os::OS_c ::= 
{ os.pp = "" ; 
--  os.ast_OS = os_no_semi();
}

concrete production os_semi_c
os::OS_c ::= s::SEMI 
{ os.pp = ";" ; 
-- os.ast_OS = os_semi();
}

-- MS
concrete production ms_one_semi_c
ms::MS_c ::= s::SEMI 
{ ms.pp = ";" ; 
-- ms.ast_MS = ms_one_semi();
}


concrete production ms_many_semi_c

ms::MS_c ::= ms2::MS_c  s::SEMI 
{ ms.pp = ms2.pp ++ " ;" ;
-- ms.ast_MS = ms_many_semi(ms2.ast_MS);
}

