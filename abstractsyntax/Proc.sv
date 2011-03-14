grammar edu:umn:cs:melt:ableP:abstractsyntax;

--nonterminal Proc with pp, ppi, errors ;

abstract production proc_decl
proc::Unit ::= i::Inst procty::ProcType nm::ID dcl::Decls
               pri::Priority ena::Enabler 
               b::Body
{ proc.pp = "\n" ++ i.pp ++ " " ++ procty.pp ++ " " ++ nm.lexeme ++
            " (" ++ dcl.pp ++ ") " ++ pri.pp ++ ena.pp ++ b.pp;
  b.ppi = proc.ppi;
  proc.errors := dcl.errors ++ b.errors ;
  proc.host = proc_decl(i.host, procty.host, nm, dcl.host,
                        pri.host, ena.host, b.host);

-- proc.defs = mergeDefs(valueBinding(nm.lexeme,proc_type()),mergeDefs(dcl.defs,b.defs));

-- b.env = mergeDefs(dcl.defs, mergeDefs(proc.defs,proc.env)) ;
-- optena.env = proc.env;
-- proc.inlined_Unit = proc_decl(i.inlined_Inst, procty.inlined_ProcType, nm, dcl.inlined_Decls, 
--                               optpri.inlined_OptPriority, optena.inlined_OptEnabler, b.inlined_Body);

}

--ProcType
nonterminal ProcType with pp, ppi, host<ProcType> ;
abstract production just_procType
pt::ProcType ::=
{ pt.pp = "proctype";
  pt.host = just_procType() ;
}
abstract production d_procType
pt::ProcType ::=
{ pt.pp = "D_proctype";
  pt.host = d_procType() ;
}


--Inst  
nonterminal Inst with pp, ppi, host<Inst> ; 
abstract production empty_inst
i::Inst ::= 
{ i.pp = "";
  i.host = empty_inst();
}
abstract production active_inst
i::Inst ::= 
{ i.pp = "active";
  i.host = active_inst();
}
abstract production activeconst_inst
i::Inst ::= ct::CONST
{ i.pp = "active[" ++ ct.lexeme ++ "]";
  i.host = activeconst_inst(ct);
}
abstract production activename_inst
i::Inst ::= id::ID
{ i.pp = "active[" ++ id.lexeme ++ "]";
  i.host = activename_inst(id);
}

--Priority
nonterminal Priority with pp, ppi, host<Priority> ;
abstract production none_priority
p::Priority ::=
{ p.pp= "";
  p.host = none_priority();
}
abstract production num_priority
p::Priority ::= ct::CONST
{ p.pp = " priority " ++ ct.lexeme;
  p.host = num_priority(ct);
}


--Enabler
nonterminal Enabler with pp, ppi, host<Enabler> ;
abstract production none_enabler
e::Enabler ::= 
{ e.pp = "";
  e.host = none_enabler();
}

{- ToDo
abstract production expr_enabler
e::Enabler ::= fe::FullExpr
{ e.pp = "provided " ++ "(" ++ fe.pp ++ ")";
  e.host = expr_enabler(fe.host);
}
-}

