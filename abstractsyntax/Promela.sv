grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

synthesized attribute basepp::String;
inherited attribute ppi::String;
inherited attribute ppsep::String;

nonterminal Program;
-- with {basepp,pp};

synthesized attribute inlined_Program :: Program occurs on Program;

abstract production program
   p::Program ::= u::Units
{
 p.basepp = u.basepp;
 p.pp = u.pp;
 p.inlined_Program = program(u.inlined_Units);
 p.errors = u.errors;
 u.env = emptyDefs();
 p.defs = u.defs;
}

 
abstract production empty_program
p::Program ::=
{
 p.basepp = "";
 p.pp = "";
 p.inlined_Program = empty_program();
 p.errors = [];
 p.defs = emptyDefs();
} 
   
