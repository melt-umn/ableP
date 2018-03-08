grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

-- Body
attribute pp, ppi, ast<Stmt> occurs on Body_c ;

aspect production body_statements_c 
b::Body_c ::= '{' s::Sequence_c os::OS_c '}'
{ b.pp = "{\n" ++ s.ppi ++ s.pp ++ os.pp ++ "\n" ++ b.ppi ++ "}" ;
  s.ppi = "  " ++ b.ppi ;
  b.ast = blockStmt(s.ast);
}

-- Sequence
attribute pp, ppi, ast<Stmt> occurs on Sequence_c ;

aspect production single_step_c 
s::Sequence_c ::= st::Step_c
{ s.pp =  st.pp;
  st.ppi = s.ppi;
  s.ast = st.ast;
}
aspect production cons_step_c
s::Sequence_c ::= s2::Sequence_c ms::MS_c st::Step_c
{ s.pp = s2.pp ++ " " ++ ms.pp ++ "\n" ++ s.ppi ++ st.pp;
  s2.ppi = s.ppi;
  st.ppi = s.ppi ;
  s.ast = seqStmt(s2.ast, st.ast);
}

-- OS
attribute pp occurs on OS_c ;

aspect production os_no_semi_c
os::OS_c ::= 
{ os.pp = "" ;  }

aspect production os_semi_c
os::OS_c ::= s::SEMI 
{ os.pp = s.lexeme ; }

-- MS
attribute pp occurs on MS_c ;

aspect production ms_one_semi_c
ms::MS_c ::= s::SEMI 
{ ms.pp = ";" ; }

aspect production ms_many_semi_c
ms::MS_c ::= ms2::MS_c  s::SEMI 
{ ms.pp = ms2.pp ++ " ;" ; }

