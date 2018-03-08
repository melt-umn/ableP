grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

attribute pp, ppi, ast<Decls> occurs on Proc_c ;

aspect production proc_decl_c
proc::Proc_c ::= i::Inst_c procty::ProcType_c nm::ID 
                 lp::LPAREN dcl::Decl_c rp::RPAREN 
                 optpri::OptPriority_c optena::OptEnabler_c b::Body_c
{ proc.pp = -- v1 proc.ppi ++ 
            i.pp ++ ifNEspace(i.pp) ++ procty.pp ++ " " ++ nm.lexeme ++
            " (" ++ dcl.pp ++ ") " ++ optpri.pp ++ optena.pp ++ 
            b.pp;
  dcl.ppsep = " " ;
  b.ppi = proc.ppi ; 
  proc.ast = procDecl(i.ast, procty.ast,nm, dcl.ast, 
                      optpri.ast, optena.ast, b.ast);
}

-- ProcType --
--------------
attribute pp, ppi, ast<ProcType> occurs on ProcType_c ;

aspect production just_procType_c
procty::ProcType_c ::= pt::PROCTYPE
{ procty.pp = "proctype";
  procty.ast = just_procType();
}
aspect production d_procType_c
procty::ProcType_c ::= dpt::D_PROCTYPE
{ procty.pp = "D_proctype";
  procty.ast = d_procType();
}


-- Inst --
----------
attribute pp, ppi, ast<Inst> occurs on Inst_c ;

aspect production empty_inst_c
i::Inst_c ::= {-empty-}
{ i.pp = "";
  i.ast = empty_inst(); 
}
aspect production active_inst_c
i::Inst_c ::= a::ACTIVE
{ i.pp = "active";
  i.ast = active_inst();
}
aspect production activeconst_inst_c
i::Inst_c ::= a::ACTIVE lbr::LSQUARE ct::CONST rbr::RSQUARE
{ i.pp = "active[" ++ ct.lexeme ++ "]";
  i.ast = activeconst_inst(ct);
}
aspect production activename_inst_c
i::Inst_c ::= a::ACTIVE lbr::LSQUARE id::ID rbr::RSQUARE
{ i.pp = "active[" ++ id.lexeme ++ "]";
  i.ast = activename_inst(id);
}

-- OptPriority --
-----------------
attribute pp, ppi, ast<Priority> occurs on OptPriority_c ;

aspect production none_priority_c
op::OptPriority_c ::=
{ op.pp= "";
  op.ast = none_priority();
}
aspect production num_priority_c
op::OptPriority_c ::= p::PRIORITY ct::CONST
{ op.pp = " priority " ++ ct.lexeme;
  op.ast = num_priority(ct);
}


-- OptEnabler --
----------------
attribute pp, ppi, ast<Enabler> occurs on OptEnabler_c ;

aspect production none_enabler_c
oe::OptEnabler_c ::= 
{ oe.pp = "";
  oe.ast = noEnabler();
}
aspect production expr_enabler_c
oe::OptEnabler_c ::= p::PROVIDED lpr::LPAREN fe::FullExpr_c rpr::RPAREN 
{ oe.pp = "provided " ++ "(" ++ fe.pp ++ ")";
  oe.ast = optEnabler(fe.ast);
}


