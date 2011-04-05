grammar edu:umn:cs:melt:ableP:extensions:typeChecking ;

--import edu:umn:cs:melt:ableP:host ;
import edu:umn:cs:melt:ableP:concretesyntax ;
import edu:umn:cs:melt:ableP:abstractsyntax ;
import edu:umn:cs:melt:ableP:terminals ;

aspect production run
exp::Expr ::= pn::ID args::Exprs p::Priority
{ exp.errors <- if true -- wrong number of errors
                then [ mkError ( "Incorrect number of arguments to \"" ++ exp.pp ++ "\"." ) ]
                else [ ] ;
}

aspect production defaultAssign
s::Stmt ::= lhs::Expr rhs::Expr 
{
 s.errors <- 
   if   areCompatible(lhs.typerep, rhs.typerep) 
   then [ ] 
   else [ mkError ("Types " ++ lhs.typerep.pp ++ " and " ++ rhs.typerep.pp ++
                   " are incompatible." ) ] ;
}

