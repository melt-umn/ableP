grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Unit with pp, ppi, ppterm, errors, host<Unit> ;

abstract production seqUnit
u::Unit ::= u1::Unit u2::Unit
{ u.pp = u1.pp ++ u2.pp;
  u1.ppi = "";   u2.ppi = "";
  u1.ppterm = "; \n" ; u2.ppterm = "; \n" ;
  u.errors := u1.errors ++ u2.errors ;
  u.host = seqUnit(u1.host, u2.host);
  u.defs = mergeDefs(u1.defs,u2.defs);  
  u1.env = u.env ;
  u2.env = mergeDefs(u1.defs,u.env);
--  us.inlined_Units = units_snoc(some.inlined_Units, u.inlined_Unit);
}

abstract production emptyUnit
u::Unit ::= 
{ u.pp = "" ;
  u.errors := [ ] ;
  u.host = emptyUnit();
  u.defs = emptyDefs() ;
}

abstract production unitDecls
un::Unit ::= ds::Decls
{ un.pp = ds.pp ++ un.ppterm ;
  ds.ppi = un.ppi;
  ds.ppsep = "; \n" ;
  un.errors := ds.errors;

  un.defs = ds.defs ;
  un.uses = ds.uses ;

  un.host = unitDecls(ds.host);
}

abstract production init
i::Unit ::= op::Priority body::Stmt
{ i.pp = "\n" ++ "init " ++ op.pp ++ "{" ++  body.ppi ++ body.pp ++ "}" ;
  body.ppi = "  ";
  i.errors := body.errors;
  i.defs = body.defs ;
  i.uses = body.uses ;
  i.host = init(op.host, body.host) ;
-- i.inlined_Unit = init(op.inlined_OptPriority, body.inlined_Body);
}

abstract production commentedUnit
u::Unit ::= comm::String u2::Unit
{
 u.pp = comm ++ u2.pp ;
 u.errors := u2.errors ;
 u.defs = u2.defs ;
 u.host = commentedUnit (comm, u2.host) ;
 u.uses = u2.uses ;
}

abstract production ppUnit
u::Unit ::= comm::String 
{
 u.pp = comm ;
 u.errors := [ ] ;
 u.defs = emptyDefs() ;
 u.host = ppUnit(comm);
 u.uses = [ ] ;
}


{-  Will go back and add these as necessesary.


-- Unit --
----------
abstract production unit_semi
u::Unit ::= 
{ u.pp = ";\n";
--  u.basepp = ";\n";
--  u.errors = [];
--  u.defs = emptyDefs(); 
--  u.inlined_Unit = unit_semi();
}




abstract production claim
c::Unit ::= body::Body
{
 c.pp = "\n" ++ "never " ++ body.ppi ++ body.pp;
 body.ppi = "   ";
 c.basepp = "\n" ++ "never " ++ body.ppi ++ body.basepp;

 c.errors = body.errors;
 c.defs = body.defs;
 body.env = c.env;

 c.inlined_Unit = claim(body.inlined_Body); 
}

abstract production events
e::Unit ::= body::Body
{
 e.pp = "\n" ++ "trace " ++ body.pp;
 body.ppi = "   ";
 e.basepp = "\n" ++ "trace " ++ body.basepp;

 e.errors = body.errors;
 e.defs = body.defs;
 body.env = e.env;

 e.inlined_Unit = events(body.inlined_Body);
}

abstract production utype_dcllist
u::Unit ::= id::ID dl::Decls
{
 u.pp = "\n" ++ "typedef " ++ id.lexeme ++ " \n{" ++ dl.pp ++ " \n} \n";
 dl.ppi = "  ";
 dl.ppsep = "; \n ";
 u.basepp = "\n" ++ "typedef " ++ id.lexeme ++ " \n{" ++ dl.basepp ++ " \n} \n";

 u.errors = dl.errors;
 u.defs = valueBinding(id.lexeme, user_type(dl.defs)); 

 u.inlined_Unit = utype_dcllist(id,dl.inlined_Decls);
}



 
abstract production error_type_const
er::Error ::= ty::Type ct::CONST
{
 er.basepp = ty.basepp ++ ":" ++ ct.lexeme ;
 er.pp = ty.pp ++ ":" ++ ct.lexeme ;
 er.inlined_Error = error_type_const(ty,ct);
}
-}
