grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

nonterminal Decls with pp, ppi, ppsep, errors, host<Decls>, inlined<Decls> ; 

abstract production seqDecls
ds::Decls ::= ds1::Decls ds2::Decls
{ ds.pp = ds1.pp ++ ds.ppsep ++
           -- "\n\n\n" ++ 
          ds2.pp ;
  ds.errors := ds1.errors ++ ds2.errors ;
  ds.host = seqDecls(ds1.host, ds2.host);
  ds.inlined = seqDecls(ds1.inlined, ds2.inlined);

  ds.defs = mergeDefs(ds1.defs, ds2.defs);
  ds1.env = ds.env ;
  ds2.env = mergeDefs(ds.env, ds1.defs);
  ds.uses = ds1.uses ++ ds2.uses ;
}

abstract production emptyDecl
ds::Decls ::= 
{ ds.pp = "" ;
  ds.errors := [ ] ;
  ds.host = emptyDecl();
  ds.inlined = emptyDecl();

  ds.defs = emptyDefs();
  ds.uses = [ ] ;
}

-- Declarations, binding names to values or types.
synthesized attribute idNum::Integer occurs on Decls ;

abstract production varDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ; 
 production attribute overloads :: [Decls] with ++ ;
 overloads := [ ] ;

 forwards to if null(overloads) then defaultVarDecl(vis,t,v) 
             else head(overloads) ;
}

abstract production defaultVarDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ; 
 ds.errors := t.errors ++ v.errors ;
 ds.host = varDecl(vis.host,  t.host, v.host);
 ds.inlined = varDecl(vis.inlined,  t.inlined, v.inlined);

 ds.defs = valueBinding(v.name, ds) ;
 ds.uses = [ ] ;
 ds.idNum = genInt();
}

abstract production varAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{ forwards to defaultVarAssignDecl(vis, t, v, e) ; } 

abstract production defaultVarAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ++ " = " ++ e.pp ;
 ds.errors := t.errors ++ v.errors ++ e.errors ;
 ds.host = varAssignDecl(vis.host, t.host, v.host, e.host) ;
 ds.inlined = varAssignDecl(vis.inlined, t.inlined, v.inlined, e.inlined) ;

 ds.defs = valueBinding(v.name, ds) ;
 ds.uses = e.uses ;
 ds.idNum = genInt();
}

nonterminal Declarator  with pp, errors, host<Declarator>, inlined<Declarator>, name; 

abstract production vd_id
vd::Declarator ::= id::ID
{ vd.pp = id.lexeme;
  vd.errors := [ ];
  vd.host = vd_id(id);
  vd.inlined = vd_id(id);
  vd.name = id.lexeme ;
}

abstract production vd_idconst
vd::Declarator ::= id::ID cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
  vd.errors := [ ];
  vd.host = vd_idconst(id,cnt);
  vd.inlined = vd_idconst(id,cnt);
  vd.name = id.lexeme ;
}

abstract production vd_array
vd::Declarator ::= id::ID cnt::CONST
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
  vd.errors := [ ];
  vd.host = vd_array(id,cnt);
  vd.inlined = vd_array(id,cnt);
  vd.name = id.lexeme ;
}


-- Visibility --
nonterminal Vis with pp, host<Vis>, inlined<Vis> ;
abstract production vis_empty
v::Vis ::=
{ v.pp = "";   
  v.host = vis_empty(); 
  v.inlined = vis_empty(); 
}
abstract production vis_hidden
v::Vis ::=
{ v.pp = "hidden "; 
  v.host = vis_hidden() ;
  v.inlined = vis_hidden() ;
}
abstract production vis_show
v::Vis ::=
{ v.pp = "show "; 
  v.host = vis_show();
  v.inlined = vis_show();
}
abstract production vis_islocal
v::Vis ::=
{ v.pp = "local "; 
  v.host = vis_islocal();
  v.inlined = vis_islocal();
}


abstract production mtypeDecls
ds::Decls ::= v::Vis t::TypeExpr names::IDList
{ -- spin.y accepts types syntactically but requires that t be an "mtype" type.
 ds.pp =  v.pp ++ t.pp ++ " = { " ++ names.pp ++ " } ";
 ds.errors := case t of
                mtypeTypeExpr() -> [ ] 
              | _ -> [ mkErrorNoLoc ("Type \"" ++ t.pp ++ "\" cannot be used in " ++
                                "mtype-style declration.\n" ) ] end ;

 ds.host = mtypeDecls(v.host, t.host, names.host) ;
 ds.inlined = mtypeDecls(v.inlined, t.inlined, names.inlined) ;

 forwards to names.decls ;
 names.inVis = v ;
}

nonterminal IDList with pp, errors, host<IDList>, inlined<IDList> ;
autocopy attribute inVis :: Vis occurs on IDList ;
synthesized attribute decls :: Decls occurs on IDList ;

nonterminal VarList with pp;
abstract production singleName
names::IDList ::= name::ID
{ names.pp = name.lexeme;
  names.host = singleName(name);
  names.inlined = singleName(name);
  names.decls = mtypeDecl(names.inVis, name) ;
}

abstract production snocNames
names::IDList ::= some::IDList name::ID
{ names.pp = some.pp ++ ", " ++  name.lexeme;
  names.host = snocNames(some.host, name);
  names.inlined = snocNames(some.inlined, name);
  names.decls = seqDecls( some.decls, mtypeDecl(names.inVis, name) ) ;
}

abstract production mtypeDecl
ds::Decls ::= v::Vis name::ID
{ -- we assume an implicit "mtype" in this production.
 ds.pp = v.pp ++ " mtype = { " ++ name.lexeme ++ " } " ;
 ds.errors := [ ] ; 
 ds.defs = valueBinding(name.lexeme, ds);
}
