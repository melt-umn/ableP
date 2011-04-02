grammar edu:umn:cs:melt:ableP:concretesyntax;

nonterminal Proc_c with pp, ppi, ast<Decls> ; -- same in v4.2.9 and v6
--proc    : inst          /* optional instantiator */
--          proctype NAME 
--          '(' decl ')'  
--          Opt_priority
--          Opt_enabler
--          body        
--
-- same in v4.2.9 and v6
--proctype: PROCTYPE      
--        | D_PROCTYPE    

concrete production proc_decl_c
proc::Proc_c ::= i::Inst_c procty::ProcType_c nm::ID 
                 lp::LPAREN dcl::Decl_c rp::RPAREN 
                 optpri::OptPriority_c optena::OptEnabler_c b::Body_c
{ proc.pp = "\n" ++ i.pp ++ " " ++ procty.pp ++ " " ++ nm.lexeme ++
            " (" ++ dcl.pp ++ ") " ++ optpri.pp ++ optena.pp ++ b.pp;
  b.ppi = proc.ppi;
  proc.ast = procDecl(i.ast, procty.ast,nm, dcl.ast, 
                      optpri.ast, optena.ast,b.ast);
}

action
{ local attribute getPname::String;
  getPname = nm.lexeme;
  usedProcess = 1;
  pnames = if((usedProcess == 1) && !listContains(getPname,pnames))
           then [getPname] ++ pnames
           else pnames;
}
  

--ProcType
nonterminal ProcType_c with pp, ppi, ast<ProcType> ;  -- same in v4.2.9 and v6

concrete production just_procType_c
procty::ProcType_c ::= pt::PROCTYPE
{ procty.pp = "proctype";
  procty.ast = just_procType();
}

concrete production d_procType_c
procty::ProcType_c ::= dpt::D_PROCTYPE
{ procty.pp = "D_proctype";
  procty.ast = d_procType();
}


--Inst  
nonterminal Inst_c with pp, ppi, ast<Inst> ;  -- same in v4.2.9 and v6

concrete production empty_inst_c
i::Inst_c ::= 
{ i.pp = "";
  i.ast = empty_inst(); 
}

concrete production active_inst_c
i::Inst_c ::= a::ACTIVE
{ i.pp = "active";
  i.ast = active_inst();
}

concrete production activeconst_inst_c
i::Inst_c ::= a::ACTIVE lbr::LSQUARE ct::CONST rbr::RSQUARE
{ i.pp = "active[" ++ ct.lexeme ++ "]";
  i.ast = activeconst_inst(ct);
}

concrete production activename_inst_c
i::Inst_c ::= a::ACTIVE lbr::LSQUARE id::ID rbr::RSQUARE
{ i.pp = "active[" ++ id.lexeme ++ "]";
  i.ast = activename_inst(id);
}

--OptPriority
nonterminal OptPriority_c with pp, ppi, ast<Priority> ; -- same as v4.2.9 and v6

concrete production none_priority_c
op::OptPriority_c ::=
{ op.pp= "";
  op.ast = none_priority();
}

concrete production num_priority_c
op::OptPriority_c ::= p::PRIORITY ct::CONST
{ op.pp = " priority " ++ ct.lexeme;
  op.ast = num_priority(ct);
}


--OptEnabler
nonterminal OptEnabler_c with pp, ppi, ast<Enabler> ; -- same as in v4.2.9 and v6

concrete production none_enabler_c
oe::OptEnabler_c ::= 
{ oe.pp = "";
  oe.ast = none_enabler();
}

concrete production expr_enabler_c
oe::OptEnabler_c ::= p::PROVIDED lpr::LPAREN fe::FullExpr_c rpr::RPAREN 
{ oe.pp = "provided " ++ "(" ++ fe.pp ++ ")";
-- ToDo  oe.ast = expr_enabler(fe.ast_Expr);
}


