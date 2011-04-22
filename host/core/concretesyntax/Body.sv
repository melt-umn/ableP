grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

-- Body
nonterminal Body_c with pp, ppi, ast<Stmt> ; -- same as in v4.2.9 and v6

concrete production body_statements_c 
b::Body_c ::= '{' s::Sequence_c os::OS_c '}'
{ b.pp = "\n{\n" ++ s.ppi ++ s.pp ++ os.pp ++ " \n}";
  s.ppi = b.ppi ++ "  " ;
  b.ast = blockStmt(s.ast);
}

-- Sequence
nonterminal Sequence_c with pp, ppi, ast<Stmt>;   -- same as in v4.2.9 and v6

concrete production single_step_c 
s::Sequence_c ::= st::Step_c
{ s.pp =  st.pp;
  st.ppi = s.ppi;
  s.ast = st.ast;
}
concrete production cons_step_c
s::Sequence_c ::= s2::Sequence_c ms::MS_c st::Step_c
{ s.pp = s2.pp ++ ms.pp ++ "\n" ++ s.ppi ++ st.pp;
  s2.ppi = s.ppi;
  st.ppi = s.ppi ;
  s.ast = seqStmt(s2.ast, st.ast);
}

-- OS
nonterminal OS_c with pp ;  -- same as in v4.2.9 and v6
concrete production os_no_semi_c
os::OS_c ::= 
{ os.pp = "" ;  }

concrete production os_semi_c
os::OS_c ::= s::SEMI 
{ os.pp = ";" ; }

-- MS
nonterminal MS_c with pp ;   -- same as in v4.2.9 and v6
concrete production ms_one_semi_c
ms::MS_c ::= s::SEMI 
{ ms.pp = ";" ; }

concrete production ms_many_semi_c
ms::MS_c ::= ms2::MS_c  s::SEMI 
{ ms.pp = ms2.pp ++ " ;" ; }

