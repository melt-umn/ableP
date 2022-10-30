grammar edu:umn:cs:melt:ableP:extensions:discreteTime ;

-- Overloaded constructs, specific to discrete time.

-- variable declarations --
aspect production varDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{ overloads <- case t of 
                 timerTypeExpr() -> [ timerVarDecl(vis, t, v) ]
               | _ -> [ ] end ;
}
abstract production timerVarDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ; 
 ds.errors := t.errors ++ v.errors ;
 propagate alluses,
            ppsep,
            env,
            rwrules_ChInit,
            rwrules_Declarator,
            rwrules_Decls,
            rwrules_Enabler,
            rwrules_Expr,
            rwrules_Exprs,
            rwrules_IDList,
            rwrules_Inst,
            rwrules_MArgs,
            rwrules_Op,
            rwrules_Options,
            rwrules_Priority,
            rwrules_ProcType,
            rwrules_Program,
            rwrules_RArg,
            rwrules_RArgs,
            rwrules_Stmt,
            rwrules_TypeExpr,
            rwrules_TypeExprs,
            rwrules_Unit,
            rwrules_Vis;



 ds.defs = valueBinding(v.name, ds) ;
 ds.uses = [ ] ;
 ds.idNum = genInt();
 ds.typerep = v.typerep ;
 v.typerep_in = t.typerep;

 forwards to
   if   true -- TODO - add attributes to compute  ds.inDeclMode
   then varAssignDecl (vis, intTypeExpr(), v, constExpr(terminal(CONST,"-1")))
   else error ("not in Decl Mode") ;
}

-- assignment --
aspect production assign
s::Stmt ::= lhs::Expr op::'=' rhs::Expr 
{ overloads <- case lhs.typerep of
                 timerTypeRep() -> [ timerAssign(lhs, op, rhs) ] 
               | _ -> [ ] end ;
}
abstract production timerAssign
s::Stmt ::= lhs::Expr op::'=' rhs::Expr 
{ -- This is just syntactic sugar for the set operation.
  s.pp = lhs.pp ++ " = " ++ rhs.pp ;
  propagate alluses,
            ppsep,
            env,
            rwrules_ChInit,
            rwrules_Declarator,
            rwrules_Decls,
            rwrules_Enabler,
            rwrules_Expr,
            rwrules_Exprs,
            rwrules_IDList,
            rwrules_Inst,
            rwrules_MArgs,
            rwrules_Op,
            rwrules_Options,
            rwrules_Priority,
            rwrules_ProcType,
            rwrules_Program,
            rwrules_RArg,
            rwrules_RArgs,
            rwrules_Stmt,
            rwrules_TypeExpr,
            rwrules_TypeExprs,
            rwrules_Unit,
            rwrules_Vis;

  forwards to set(terminal(SET, "set", op.location), lhs, rhs) ;
}
