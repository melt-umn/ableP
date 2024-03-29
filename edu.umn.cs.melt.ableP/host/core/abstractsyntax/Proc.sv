grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

abstract production procDecl
proc::Decls ::= i::Inst procty::ProcType nm::ID dcl::Decls
                pri::Priority ena::Enabler 
                b::Stmt
{ proc.pp = "\n" ++ i.pp ++ " " ++ procty.pp ++ " " ++ nm.lexeme ++
            " (" ++ dcl.pp ++ ") " ++ pri.pp ++ ena.pp ++  
            case b of
              blockStmt(_) -> b.pp
            | _ -> "\n{\n" ++ b.pp ++ "\n}\n" 
            end ;
  dcl.ppsep = "; " ;
  b.ppsep = "; \n" ;
  ena.env = proc.env;
  proc.errors := dcl.errors ++ b.errors ;
  proc.host = procDecl(i.host, procty.host, nm, dcl.host,
                       pri.host, ena.host, b.host);
  proc.inlined = procDecl(i.inlined, procty.inlined, nm, dcl.inlined,
                       pri.inlined, ena.inlined, b.inlined);

  proc.defs = valueBinding(nm.lexeme, proc) ;
  dcl.env = mergeDefs(proc.defs, proc.env) ;
  b.env = mergeDefs(dcl.defs, dcl.env) ;

  proc.uses = dcl.uses ++ b.uses;

  proc.transformed = applyARewriteRule(proc.rwrules_Decls, proc,
                     procDecl(i.transformed, procty.transformed, nm, 
                              dcl.transformed, pri.transformed, ena.transformed,
                              b.transformed));

}

--ProcType
nonterminal ProcType with pp, ppi, host<ProcType>, inlined<ProcType> ;
abstract production just_procType
pt::ProcType ::=
{ pt.pp = "proctype";
  pt.host = just_procType() ;
  pt.inlined = just_procType() ;
  pt.transformed = applyARewriteRule(pt.rwrules_ProcType, pt, pt) ;
}
abstract production d_procType
pt::ProcType ::=
{ pt.pp = "D_proctype";
  pt.host = d_procType() ;
  pt.inlined = d_procType() ;
  pt.transformed = applyARewriteRule(pt.rwrules_ProcType, pt, pt) ;
}


--Inst  
nonterminal Inst with pp, ppi, host<Inst>, inlined<Inst> ; 
abstract production empty_inst
i::Inst ::= 
{ i.pp = "";
  i.host = empty_inst();
  i.inlined = empty_inst();
  i.transformed = applyARewriteRule(i.rwrules_Inst, i, i) ;
}
abstract production active_inst
i::Inst ::= 
{ i.pp = "active";
  i.host = active_inst();
  i.inlined = active_inst();
  i.transformed = applyARewriteRule(i.rwrules_Inst, i, i) ;
}
abstract production activeconst_inst
i::Inst ::= ct::CONST
{ i.pp = "active[" ++ ct.lexeme ++ "]";
  i.host = activeconst_inst(ct);
  i.inlined = activeconst_inst(ct);
  i.transformed = applyARewriteRule(i.rwrules_Inst, i, i) ;
}
abstract production activename_inst
i::Inst ::= id::ID
{ i.pp = "active[" ++ id.lexeme ++ "]";
  i.host = activename_inst(id);
  i.inlined = activename_inst(id);
  i.transformed = applyARewriteRule(i.rwrules_Inst, i, i) ;
}

--Priority
nonterminal Priority with pp, ppi, host<Priority>, inlined<Priority> ;
abstract production none_priority
p::Priority ::=
{ p.pp= "";
  p.host = none_priority();
  p.inlined = none_priority();
  p.transformed = applyARewriteRule(p.rwrules_Priority, p, p) ;
}
abstract production num_priority
p::Priority ::= ct::CONST
{ p.pp = " priority " ++ ct.lexeme;
  p.host = num_priority(ct);
  p.inlined = num_priority(ct);
  p.transformed = applyARewriteRule(p.rwrules_Priority, p, p) ;
}


--Enabler
nonterminal Enabler with pp, ppi, host<Enabler>, inlined<Enabler> ;
abstract production noEnabler
e::Enabler ::= 
{ e.pp = "";
  e.host = noEnabler();
  e.inlined = noEnabler();
  e.transformed = applyARewriteRule(e.rwrules_Enabler, e, e) ;
}

abstract production optEnabler
en::Enabler ::= e::Expr
{ en.pp = "provided " ++ "(" ++ e.pp ++ ")";
  en.host = optEnabler(e.host);
  en.inlined = optEnabler(e.inlined);
  e.alluses = [];
  en.transformed = applyARewriteRule(en.rwrules_Enabler, en, 
                     optEnabler(e.transformed));
}


