grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal ProcType with basepp,pp;
nonterminal Inst with basepp,pp;
nonterminal OptEnabler with basepp,pp;

synthesized attribute inlined_ProcType::ProcType occurs on ProcType ;
synthesized attribute inlined_Inst::Inst occurs on Inst ;
synthesized attribute inlined_OptEnabler::OptEnabler occurs on OptEnabler ;


abstract production proc_decl
proc::Unit ::= i::Inst procty::ProcType nm::ID dcl::Decls optpri::OptPriority optena::OptEnabler b::Body
{
 proc.pp = "\n" ++ i.pp ++ procty.pp ++ " " ++ nm.lexeme ++ " (" ++ dcl.pp ++ ") " ++ optpri.pp
               ++ optena.pp ++ b.pp;
 b.ppi = proc.ppi;
 dcl.ppi = "" ;
 dcl.ppsep = ", " ;
 proc.basepp = "\n" ++ i.basepp ++ " " ++ procty.basepp ++ " " ++ nm.lexeme ++ " (" ++ dcl.basepp ++ ") " ++ optpri.basepp
               ++ optena.basepp ++ b.basepp; 

 proc.errors = dcl.errors ++ b.errors;

 proc.defs = mergeDefs(valueBinding(nm.lexeme,proc_type()),mergeDefs(dcl.defs,b.defs));

 b.env = mergeDefs(dcl.defs, mergeDefs(proc.defs,proc.env)) ;
 optena.env = proc.env;
 proc.inlined_Unit = proc_decl(i.inlined_Inst, procty.inlined_ProcType, nm, dcl.inlined_Decls, 
                               optpri.inlined_OptPriority, optena.inlined_OptEnabler, b.inlined_Body);
}


-- Inst --
abstract production empty_inst
i::Inst ::=
{
 i.pp = "";
 i.basepp = "";

 i.inlined_Inst = empty_inst();
}

abstract production active_inst
i::Inst ::= 
{
 i.pp = "active " ;
 i.basepp = "active " ;

 i.inlined_Inst = active_inst();
}

abstract production activeconst_inst
i::Inst ::= ct::CONST 
{
 i.pp = "active [" ++ ct.lexeme ++ "] " ;
 i.basepp = "active [" ++ ct.lexeme ++ "] ";

 i.inlined_Inst = activeconst_inst(ct);
}

abstract production activename_inst
i::Inst ::= id::ID
{
 i.pp = "active [" ++ id.lexeme ++ "] ";
 i.basepp = "active [" ++ id.lexeme ++ "] ";

 i.inlined_Inst = activename_inst(id);
}

-- ProcType --
abstract production just_procType
procty::ProcType ::= 
{
 procty.pp = "proctype";
 procty.basepp = "proctype";
 procty.inlined_ProcType = just_procType();
 procty.typerep = pid_type();
}

abstract production d_procType
procty::ProcType ::= 
{
 procty.pp = "D_proctype";
 procty.basepp = "D_proctype";
 procty.inlined_ProcType = d_procType();
 procty.typerep = pid_type();
}

-- Priority --
abstract production none_priority
op::OptPriority ::=
{
 op.pp = "";
 op.basepp = "";
 op.inlined_OptPriority = none_priority();
}

abstract production num_priority
op::OptPriority ::= ct::CONST
{
 op.pp = " priority " ++ ct.lexeme ++ " " ;
 op.basepp = " priority " ++ ct.lexeme ++ " " ;
 op.inlined_OptPriority = num_priority(ct);
}

-- Enabler --
abstract production none_enabler
oe::OptEnabler ::=
{
 oe.pp = "";
 oe.basepp = "";
 oe.inlined_OptEnabler = none_enabler();
}
attribute env occurs on OptEnabler;

abstract production expr_enabler
oe::OptEnabler ::= fe::Expr
{
 oe.pp = "provided " ++ "(" ++ fe.pp ++ ") ";
 oe.basepp = "provided " ++ "(" ++ fe.basepp ++ ") ";
 oe.inlined_OptEnabler = expr_enabler(fe);

 fe.env = oe.env;
}

abstract production err_enabler
oe::OptEnabler ::= err::Error
{
 oe.pp = "provided " ++ err.pp ++ " " ;
 oe.basepp = "provided " ++ err.basepp ++ " " ;
 oe.inlined_OptEnabler = err_enabler(err);
}
