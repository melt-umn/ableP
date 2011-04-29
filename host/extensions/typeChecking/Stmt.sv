grammar edu:umn:cs:melt:ableP:host:extensions:typeChecking ;

aspect production defaultAssign
s::Stmt ::= lhs::Expr op::'=' rhs::Expr 
{
 s.errors <- 
   if   areCompatible(lhs.typerep, rhs.typerep) ||
        case lhs.typerep of
          pidTypeRep() -> rhs.typerep.isArithmetic
        | _ -> false end                             
   then [ ] 
   else [ mkError ("Types " ++ lhs.typerep.pp ++ " and " ++ rhs.typerep.pp ++
                   " are incompatible",
                   mkLoc(op.line, op.column) ) ] ;
}
