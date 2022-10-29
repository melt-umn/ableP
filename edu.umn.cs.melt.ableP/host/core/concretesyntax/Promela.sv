grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

imports edu:umn:cs:melt:ableP:host:core:abstractsyntax ; 

synthesized attribute ast<a>::a ;

attribute pp, ast<Program> occurs on Program_c ;

aspect production program_c
p::Program_c ::= u::Units_c
{ p.pp = u.pp ;
  u.ppi = "";
  p.ast = program(u.ast);  
}
 
attribute pp, ppi, ast<PUnit> occurs on Units_c ;
propagate ppi on Units_c;

aspect production units_one_c
us::Units_c ::= u::Unit_c
{ us.pp = u.pp;
  us.ast = u.ast;   
}
aspect production units_snoc_c
us::Units_c ::= us2::Units_c u::Unit_c 
{ us.pp = us2.pp ++ u.pp ;
  us.ast = seqUnit (us2.ast, u.ast) ;
}
