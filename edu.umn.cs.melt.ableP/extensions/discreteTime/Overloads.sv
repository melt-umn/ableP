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
  forwards to set(terminal(SET, "set", op.line, op.column), lhs, rhs) ;
}
