grammar edu:umn:cs:melt:ableP:concretesyntax ;

import edu:umn:cs:melt:ableP:terminals ;

{-
nonterminal Root_c with pp ;

concrete production promelaRoot_c
r::Root_c ::= b::Bogus_t  -- ce::Expr_c
{
 r.pp = b.lexeme ++ "\n" ; -- ++ ce.pp ++ "\n\n" ;
}

-}

--concrete production promelaRoot2_c
--r::PromelaRoot_c ::= b1::Bogus_t b2::Bogus_t cr::HostRoot_c
--{
-- r.ppp = b1.lexeme ++ "\n" ++ cr.pp ++ "\n\n" ;
--}
