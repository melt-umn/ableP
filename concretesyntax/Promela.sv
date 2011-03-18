grammar edu:umn:cs:melt:ableP:concretesyntax ;

imports edu:umn:cs:melt:ableP:terminals ;
imports edu:umn:cs:melt:ableP:abstractsyntax ; 

synthesized attribute ast<a>::a ;

nonterminal Program_c with ast<Program> ;   -- same as in v4.2.9 and v6.
----------------------------------------
-- program	: units		{ yytext[0] = '\0'; }   

concrete production program_c
p::Program_c ::= u::Units_c
{ -- p.pp = u.pp ;
  u.ppi = "";
  p.ast = program(u.ast);  
}

nonterminal Units_c with pp, ppi, ast<Units> ;   -- same as in v4.2.9 and v6.
----------------------------------------
-- units : unit
--       | units unit

concrete production units_one_c
us::Units_c ::= u::Unit_c
{ us.pp = u.pp;
  us.ast = units_one(u.ast);   
}

concrete production units_snoc_c
us::Units_c ::= us2::Units_c u::Unit_c 
{ us.pp = us2.pp ++ u.pp ;
  us.ast = case u of
             unit_semi_c(_) -> us2.ast   -- drop semi-colon units from AST
           | _ -> units_snoc(us2.ast,u.ast)
           end ;
}
