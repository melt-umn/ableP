grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

nonterminal Unit with pp, ppi, ppterm, errors, host<Unit>, inlined<Unit> ;

abstract production seqUnit
u::Unit ::= u1::Unit u2::Unit
{ u.pp = u1.pp ++ u2.pp;
  u1.ppi = "";   u2.ppi = "";
  u1.ppterm = "; \n" ; u2.ppterm = "; \n" ;
  u.errors := u1.errors ++ u2.errors ;
  u.host = seqUnit(u1.host, u2.host);
  u.inlined = seqUnit(u1.inlined, u2.inlined);
  u.defs = mergeDefs(u1.defs,u2.defs);  
  u1.env = u.env ;
  u2.env = mergeDefs(u1.defs,u.env);
}

abstract production emptyUnit
u::Unit ::= 
{ u.pp = "" ;
  u.errors := [ ] ;
  u.host = emptyUnit();
  u.inlined = emptyUnit();
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
  un.inlined = unitDecls(ds.inlined);
}

abstract production init
i::Unit ::= op::Priority body::Stmt
{ i.pp = "init " ++ op.pp ++ body.pp ;
  body.ppi = "  ";
  i.errors := body.errors;
  i.defs = body.defs ;
  i.uses = body.uses ;
  i.host = init(op.host, body.host) ;
  i.inlined = init(op.inlined, body.inlined) ;
}

abstract production commentedUnit
u::Unit ::= comm::String u2::Unit
{
 u.pp = comm ++ u2.pp ;
 u.errors := u2.errors ;
 u.defs = u2.defs ;
 u.host = commentedUnit (comm, u2.host) ;
 u.inlined = commentedUnit (comm, u2.inlined) ;
 u.uses = u2.uses ;
}

abstract production ppUnit
u::Unit ::= comm::String 
{
 u.pp = comm ;
 u.errors := [ ] ;
 u.defs = emptyDefs() ;
 u.host = ppUnit(comm) ;
 u.inlined = ppUnit(comm) ;
 u.uses = [ ] ;
}

abstract production claim
c::Unit ::= body::Stmt
{ c.pp = "never " ++ body.pp ;
  c.errors := body.errors;
  c.defs = body.defs;
  c.host = claim(body.host);
  c.inlined = claim(body.inlined);
}

abstract production events
e::Unit ::= body::Stmt
{ e.pp = "trace " ++ body.pp ;
  e.errors := body.errors;
  e.defs = body.defs;
  e.host = events(body.host);
  e.inlined = events(body.inlined);
}

abstract production typedefDecls
d::Decls ::= id::ID dl::Decls
{ d.pp = "typedef " ++ id.lexeme ++ "  {" ++ dl.pp ++ " } \n";
  d.errors := dl.errors;
  d.host = typedefDecls(id, dl.host) ;
  d.inlined = typedefDecls(id, dl.inlined) ;

  d.defs = valueBinding(id.lexeme, d) ;
}

