grammar edu:umn:cs:melt:ableP:concretesyntax ;

imports edu:umn:cs:melt:ableP:terminals ;
imports edu:umn:cs:melt:ableP:abstractsyntax ;

synthesized attribute pp::String ;
inherited attribute ppi::String;

nonterminal Program_c with pp ;   -- same as thein v4.2.9 and v6.
----------------------------------------
-- program	: units		{ yytext[0] = '\0'; }   

-- synthesized attribute ast_Program::Program occurs on Program_c;

concrete production program_c
p::Program_c ::= u::Units_c
{ p.pp = u.pp ;
--  p.ast_Program = program(u.ast_Units);  
}

nonterminal Units_c with pp ;   -- same as thein v4.2.9 and v6.
----------------------------------------
-- units : unit
--       | units unit

--synthesized attribute ast_Units::Units occurs on Units_c;

concrete production units_one_c
us::Units_c ::= u::Unit_c
{ us.pp = u.pp;
--  us.ast_Units = units_one(u.ast_Unit);   
}

concrete production units_snoc_c
us::Units_c ::= us2::Units_c u::Unit_c 
{ us.pp = us2.pp ++ u.pp ;
--  us.ast_Units = units_snoc(us2.ast_Units,u.ast_Unit);   
}

