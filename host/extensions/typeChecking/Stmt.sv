grammar edu:umn:cs:melt:ableP:host:extensions:typeChecking ;

aspect production defaultAssign
s::Stmt ::= lhs::Expr rhs::Expr 
{
 s.errors <- 
   if   areCompatible(lhs.typerep, rhs.typerep) 
   then [ ] 
   else [ mkError ("Types " ++ lhs.typerep.pp ++ " and " ++ rhs.typerep.pp ++
                   " are incompatible." ) ] ;
}


