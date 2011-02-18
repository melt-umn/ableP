grammar edu:umn:cs:melt:ableP:concretesyntax;

nonterminal Proc_c with pp, ppi ;

--proc    : inst          /* optional instantiator */
--          proctype NAME 
--          '(' decl ')'  
--          Opt_priority
--          Opt_enabler
--          body        
--
--proctype: PROCTYPE      
--        | D_PROCTYPE    


attribute ppi occurs on Body_c;

concrete production proc_decl_c
proc::Proc_c ::= i::Inst_c procty::ProcType_c nm::ID 
                 lp::LPAREN dcl::Decl_c rp::RPAREN 
                 optpri::OptPriority_c optena::OptEnabler_c b::Body_c
{ proc.pp = "\n" ++ i.pp ++ " " ++ procty.pp ++ " " ++ nm.lexeme ++
            " (" ++ dcl.pp ++ ") " ++ optpri.pp ++ optena.pp ++ b.pp;
  b.ppi = proc.ppi;
--  proc.ast_Unit = proc_decl(i.ast_Inst,procty.ast_ProcType,nm,
--                            dcl.ast_Decls,optpri.ast_OptPriority,
--                            optena.ast_OptEnabler,b.ast_Body);
}

action
{
  local attribute getPname::String;
  getPname = nm.lexeme;
  usedProcess = 1;
  pnames = if((usedProcess == 1) && !listContains(getPname,pnames))
           then [getPname] ++ pnames
           else pnames;
}
  

--Inst

nonterminal Inst_c with pp, ppi;
--synthesized attribute ast_Inst::Inst occurs on Inst_c;

concrete production empty_inst_c
i::Inst_c ::= 
{ i.pp = "";
-- i.ast_Inst = empty_inst(); 
}

concrete production active_inst_c
i::Inst_c ::= a::ACTIVE
{ i.pp = "active";
-- i.ast_Inst = active_inst();
}

concrete production activeconst_inst_c
i::Inst_c ::= a::ACTIVE lbr::LSQUARE ct::CONST rbr::RSQUARE
{ i.pp = "active[" ++ ct.lexeme ++ "]";
-- i.ast_Inst = activeconst_inst(ct);
}

concrete production activename_inst_c
i::Inst_c ::= a::ACTIVE lbr::LSQUARE id::ID rbr::RSQUARE
{ i.pp = "active[" ++ id.lexeme ++ "]";
-- i.ast_Inst = activename_inst(id);
}

--ProcType

nonterminal ProcType_c with pp, ppi;
--synthesized attribute ast_ProcType::ProcType occurs on ProcType_c;

concrete production just_procType_c
procty::ProcType_c ::= pt::PROCTYPE
{ procty.pp = "proctype";
-- procty.ast_ProcType = just_procType();
}

concrete production d_procType_c
procty::ProcType_c ::= dpt::D_PROCTYPE
{ procty.pp = "D_proctype";
-- procty.ast_ProcType = d_procType();
}


--OptPriority

nonterminal OptPriority_c with pp, ppi;

concrete production none_priority_c
op::OptPriority_c ::=
{ op.pp= "";
-- op.ast_OptPriority = none_priority();
}

concrete production num_priority_c
op::OptPriority_c ::= p::PRIORITY ct::CONST
{ op.pp = " priority " ++ ct.lexeme;
-- op.ast_OptPriority = num_priority(ct);
}


--OptEnabler

nonterminal OptEnabler_c with pp, ppi;
--synthesized attribute ast_OptEnabler::OptEnabler occurs on OptEnabler_c;

concrete production none_enabler_c
oe::OptEnabler_c ::= 
{ oe.pp = "";
-- oe.ast_OptEnabler = none_enabler();
}

concrete production expr_enabler_c
oe::OptEnabler_c ::= p::PROVIDED lpr::LPAREN fe::FullExpr_c rpr::RPAREN 
{ oe.pp = "provided " ++ "(" ++ fe.pp ++ ")";
-- oe.ast_OptEnabler = expr_enabler(fe.ast_Expr);
}

concrete production err_enabler_c
oe::OptEnabler_c ::= p::PROVIDED err::Error_c
{ oe.pp = "provided " ++ err.pp ;
}

