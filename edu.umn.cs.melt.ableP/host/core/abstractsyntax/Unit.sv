grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

nonterminal PUnit with pp, ppi, ppterm, errors, host<PUnit>, inlined<PUnit> ;
propagate ppi on PUnit excluding seqUnit,unitDecls,initConstruct;
propagate ppterm on PUnit excluding seqUnit;


abstract production seqUnit
u::PUnit ::= u1::PUnit u2::PUnit
{ u.pp = u1.pp ++ u2.pp;
  u1.ppi = "";   u2.ppi = "";
  u1.ppterm = "; \n" ; u2.ppterm = "; \n" ;
  u.errors := u1.errors ++ u2.errors ;
  u.host = seqUnit(u1.host, u2.host);
  u.inlined = seqUnit(u1.inlined, u2.inlined);
  u.defs = mergeDefs(u1.defs,u2.defs);  
  u1.env = u.env ;
  u2.env = mergeDefs(u1.defs,u.env);
  u.transformed = applyARewriteRule(u.rwrules_Unit, u,
                    seqUnit(u1.transformed, u2.transformed));
}

abstract production emptyUnit
u::PUnit ::= 
{ u.pp = "" ;
  u.errors := [ ] ;
  u.host = emptyUnit();
  u.inlined = emptyUnit();
  u.defs = emptyDefs() ;
  u.transformed = applyARewriteRule(u.rwrules_Unit, u,
                    emptyUnit());
}

abstract production unitDecls
u::PUnit ::= ds::Decls
{ u.pp = ds.pp ++ u.ppterm ;
  ds.ppi = u.ppi;
  ds.ppsep = "; \n" ;
  u.errors := ds.errors;

  u.defs = ds.defs ;
  u.uses = ds.uses ;

  u.host = unitDecls(ds.host);
  u.inlined = unitDecls(ds.inlined);

  u.transformed = applyARewriteRule(u.rwrules_Unit, u,
                     unitDecls(ds.transformed));
}

-- This is called initConstruct instead of init since init is a built-in
-- function.
abstract production initConstruct
i::PUnit ::= op::Priority body::Stmt
{ i.pp = "init " ++ op.pp ++ body.pp ;
  body.ppi = "  ";
  body.ppsep = "; \n";
  i.errors := body.errors;
  i.defs = body.defs ;
  i.uses = body.uses ;
  i.host = initConstruct(op.host, body.host) ;
  i.inlined = initConstruct(op.inlined, body.inlined) ;

  i.transformed = applyARewriteRule(i.rwrules_Unit, i,
                    initConstruct(op, body.transformed));
}

abstract production commentedUnit
u::PUnit ::= comm::String u2::PUnit
{ u.pp = comm ++ u2.pp ;
  u.errors := u2.errors ;
  u.defs = u2.defs ;
  u.host = commentedUnit (comm, u2.host) ;
  u.inlined = commentedUnit (comm, u2.inlined) ;
  u.uses = u2.uses ;

  u.transformed = applyARewriteRule(u.rwrules_Unit, u,
                    commentedUnit(comm, u2.transformed));
}

abstract production ppUnit
u::PUnit ::= comm::String 
{ u.pp = comm ;
  u.errors := [ ] ;
  u.defs = emptyDefs() ;
  u.host = ppUnit(comm) ;
  u.inlined = ppUnit(comm) ;
  u.uses = [ ] ;

  u.transformed = applyARewriteRule(u.rwrules_Unit, u,
                    ppUnit(comm));
}

abstract production claim
c::PUnit ::= body::Stmt
{ c.pp = "never " ++ body.pp ;
  body.ppsep = "; \n";
  c.errors := body.errors;
  c.defs = body.defs;
  c.host = claim(body.host);
  c.inlined = claim(body.inlined);

  c.transformed = applyARewriteRule(c.rwrules_Unit, c,
                    claim(body.transformed));
}

abstract production events
e::PUnit ::= body::Stmt
{ e.pp = "trace " ++ body.pp ;
  e.errors := body.errors;
  body.ppsep = "; \n";
  e.defs = body.defs;
  e.host = events(body.host);
  e.inlined = events(body.inlined);

  e.transformed = applyARewriteRule(e.rwrules_Unit, e,
                    events(body.transformed));
}

abstract production typedefDecls
d::Decls ::= id::ID dl::Decls
{ d.pp = "typedef " ++ id.lexeme ++ "  {" ++ dl.pp ++ " } \n";
  d.errors := dl.errors;
  d.host = typedefDecls(id, dl.host) ;
  d.inlined = typedefDecls(id, dl.inlined) ;

  d.defs = valueBinding(id.lexeme, d) ;

  d.transformed = applyARewriteRule(d.rwrules_Decls, d,
                    typedefDecls(id, dl.transformed));
}

