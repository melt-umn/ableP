grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

-- This files contains the abstract and concrete syntax for the named
-- claim constructed introducted in version 5.3.

-- Named claim --
-----------------
abstract production namedClaim
c::Unit ::= id::ID body::Stmt
{ c.pp = "never " ++ id.lexeme ++ " " ++ body.pp ;
  c.errors := body.errors;
  c.defs = body.defs;
  c.host = claim(body.host);
  c.inlined = claim(body.inlined);
}


{- In Promela 4.2.9 and thus in host:core:concretesyntax a claim has
   the following form:

     c::Claim_c ::= ck::CLAIM body::Body_c

   In v6 the claim producution in SPIN was giving an optional name
   after the CLAIM keyword.

   We did not modify the original production but instead added an new
   one below to handle the case when there is a name.
-}
concrete production namedClaim_c 
c::Claim_c ::= ck::CLAIM id::ID body::Body_c
{ c.pp = "never " ++ id.lexeme ++ body.ppi ++ body.pp ;
  body.ppi = "  ";
  c.ast = namedClaim(id, body.ast) ; 
}

