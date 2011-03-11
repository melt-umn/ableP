grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Proc with pp, ppi, errors ;

abstract production proc_decl
proc::Unit ::= i::Inst procty::ProcType nm::ID dcl::Decls
               pri::Priority ena::Enabler 
               b::Body
{ proc.pp = "\n" ++ i.pp ++ " " ++ procty.pp ++ " " ++ nm.lexeme ++
            " (" ++ dcl.pp ++ ") " ++ pri.pp ++ ena.pp ++ b.pp;
  b.ppi = proc.ppi;

-- proc.defs = mergeDefs(valueBinding(nm.lexeme,proc_type()),mergeDefs(dcl.defs,b.defs));

-- b.env = mergeDefs(dcl.defs, mergeDefs(proc.defs,proc.env)) ;
-- optena.env = proc.env;
-- proc.inlined_Unit = proc_decl(i.inlined_Inst, procty.inlined_ProcType, nm, dcl.inlined_Decls, 
--                               optpri.inlined_OptPriority, optena.inlined_OptEnabler, b.inlined_Body);

}

--ProcType
nonterminal ProcType with pp, ppi;
abstract production just_procType
procty::ProcType ::=
{ procty.pp = "proctype";
}
abstract production d_procType
procty::ProcType ::=
{ procty.pp = "D_proctype";
}


--Inst  
nonterminal Inst with pp, ppi; 
abstract production empty_inst
i::Inst ::= 
{ i.pp = "";
}
abstract production active_inst
i::Inst ::= 
{ i.pp = "active";
}
abstract production activeconst_inst
i::Inst ::= ct::CONST
{ i.pp = "active[" ++ ct.lexeme ++ "]";
}
abstract production activename_inst
i::Inst ::= id::ID
{ i.pp = "active[" ++ id.lexeme ++ "]";
}

--Priority
nonterminal Priority with pp, ppi;
abstract production none_priority
p::Priority ::=
{ p.pp= "";
}
abstract production num_priority
p::Priority ::= ct::CONST
{ p.pp = " priority " ++ ct.lexeme;
}


--Enabler
nonterminal Enabler with pp, ppi;
abstract production none_enabler
e::Enabler ::= 
{ e.pp = "";
}

{- ToDo
abstract production expr_enabler
e::Enabler ::= fe::FullExpr
{ e.pp = "provided " ++ "(" ++ fe.pp ++ ")";
}
-}

