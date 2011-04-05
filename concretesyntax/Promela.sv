grammar edu:umn:cs:melt:ableP:concretesyntax ;

imports edu:umn:cs:melt:ableP:terminals ;
imports edu:umn:cs:melt:ableP:abstractsyntax ; 

synthesized attribute ast<a>::a ;

nonterminal Program_c with pp, ast<Program> ;   -- same as in v4.2.9 and v6.
synthesized attribute cst_Program_c :: Program_c occurs on Program ;
----------------------------------------
-- program	: units		{ yytext[0] = '\0'; }   

concrete production program_c
p::Program_c ::= u::Units_c
{ p.pp = u.pp ;
  u.ppi = "";
  p.ast = program(u.ast);  
}
aspect production program  p ::= u 
{ p.cst_Program_c = program_c( us_cst ) ; 
  local us_cst::Units_c = 
    if null(us) then error ("Empty list of Unit_c on program.")
    else foldl_p ( units_snoc_c, units_one_c( head(us) ), tail(us) ) ;
  local us::[Unit_c] = u.cst_Unit_c_asList ;
}
 
nonterminal Units_c with pp, ppi, ast<Unit> ;   -- same as in v4.2.9 and v6.
--synthesized attribute cst_Units_c :: Units_c occurs on Units ;
----------------------------------------
-- units : unit
--       | units unit

concrete production units_one_c
us::Units_c ::= u::Unit_c
{ us.pp = u.pp;
  us.ast = u.ast;   
}
--aspect production units_one  us ::= u
--{ us.cst_Units_c = units_one_c(u.cst_Unit_c) ; }

concrete production units_snoc_c
us::Units_c ::= us2::Units_c u::Unit_c 
{ us.pp = us2.pp ++ u.pp ;
  us.ast = seqUnit (us2.ast, u.ast) ;
{-
           case u of
             unit_semi_c(_) -> us2.ast   -- drop semi-colon units from AST
           | _ -> units_snoc(us2.ast,u.ast)
           end ; -}
}
--aspect production units_snoc  us ::= us2 u
--{ us.cst_Units_c = units_snoc_c(us2.cst_Units_c, u.cst_Unit_c) ; }
