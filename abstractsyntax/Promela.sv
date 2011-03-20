grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal Program with pp, errors, host<Program> ;

--synthesized attribute inlined_Program :: Program occurs on Program;

abstract production program
p::Program ::= u::Units
{ p.pp = "// Promela code generated by ableP.\n\n" ++ u.pp ++ "//end\n" ;
  u.ppi = "" ;
  p.errors := u.errors;
  p.host = program(u.host);
-- p.inlined_Program = program(u.inlined_Units);
-- u.env = emptyDefs();
-- p.defs = u.defs;
}


-- Units --
-----------
nonterminal Units with pp, ppi, errors, host<Units> ;

abstract production units_one
us::Units ::= u::Unit
{ us.pp = u.pp; 
  u.ppi = "";
  us.errors := u.errors ;
  us.host = units_one(u.host);
--  us.basepp = u.basepp;
--  us.errors = u.errors;
--  us.defs = u.defs;
--  u.env = us.defs;
--  us.inlined_Units = units_one(u.inlined_Unit);
}

abstract production units_snoc
us::Units ::= some::Units u::Unit
{ us.pp = some.pp ++ u.pp;
  u.ppi = "";
  us.errors := some.errors ++ u.errors ;
  us.host = units_snoc(some.host, u.host);
--  us.basepp = some.basepp ++ u.basepp;
--  us.errors = some.errors ++ u.errors;
--  us.defs = mergeDefs(some.defs,u.defs);  
--  some.env = us.env ;
--  u.env = mergeDefs(some.defs,us.env);
--  us.inlined_Units = units_snoc(some.inlined_Units, u.inlined_Unit);
}



{- Not sure that we need this anymore.  It is not used anywhere but in
its own definition of inlined_Program.
 
abstract production empty_program
p::Program ::=
{
 p.basepp = "";
 p.pp = "";
 p.inlined_Program = empty_program();
 p.errors = [];
 p.defs = emptyDefs();
} 
   
-}