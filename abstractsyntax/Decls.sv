grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Decls with pp, ppi, ppsep, errors, host<Decls> ; 

abstract production seqDecls
ds::Decls ::= ds1::Decls ds2::Decls
{ ds.pp = ds1.pp ++ ds.ppsep ++
           -- "\n\n\n" ++ 
          ds2.pp ;
  ds.errors := ds1.errors ++ ds2.errors ;
  ds.host = seqDecls(ds1.host, ds2.host);

  ds.defs = mergeDefs(ds1.defs, ds2.defs);
  ds1.env = ds.env ;
  ds2.env = mergeDefs(ds.env, ds1.defs);
  ds.uses = ds1.uses ++ ds2.uses ;
-- ds.inlined_Decls = seqDecls(ds1.inlined_Decls, ds2.inlined_Decls);
}

abstract production emptyDecl
ds::Decls ::= 
{ ds.pp = "" ;
  ds.errors := [ ] ;
  ds.host = emptyDecl();

  ds.defs = emptyDefs();
  ds.uses = [ ] ;
  ds.typerep = errorTypeRep() ;
-- ds.inlined_Decls = empty_Decl();
}

-- Declarations, binding names to values or types.
synthesized attribute idNum::Integer occurs on Decls ;
attribute typerep occurs on Decls ;
--TODO -maybe we should make Decls a list of Decl so that idNum
-- decorates Decl but not Decls since this is not right for seqDecls.

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

 ds.defs = valueBinding(v.name, ds) ;
 ds.uses = [ ] ;
 ds.idNum = genInt();
 ds.typerep = v.typerep ;
 v.typerep_in = t.typerep;
-- ds.defs = valueBinding(v.name, v.typerep) ; 
-- ds.inlined_Decls = varDecl(vis, t, v);
-- t.env = ds.env ;
}

abstract production varAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ++ " = " ++ e.pp ;
 ds.errors := t.errors ++ v.errors ++ e.errors ;
 ds.host = varAssignDecl(vis.host, t.host, v.host, e.host) ;

 ds.defs = valueBinding(v.name, ds) ;
 ds.uses = e.uses ;
 ds.idNum = genInt();
 ds.typerep = v.typerep ;
 v.typerep_in = t.typerep;
-- ds.defs = valueBinding(v.name, v.typerep) ;
}


inherited attribute typerep_in :: TypeRep ;

nonterminal Declarator  with pp, errors, host<Declarator>, name, typerep, typerep_in ;
abstract production vd_id
vd::Declarator ::= id::ID
{ vd.pp = id.lexeme;
  vd.errors := [ ];
  vd.host = vd_id(id);
  vd.name = id.lexeme ;
  vd.typerep = vd.typerep_in ;
}

abstract production vd_idconst
vd::Declarator ::= id::ID cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
  vd.errors := [ ];
  vd.host = vd_idconst(id,cnt);
  vd.name = id.lexeme ;
  vd.typerep = vd.typerep_in ; -- ToDo - are there typing issues here?
}

abstract production vd_array
vd::Declarator ::= id::ID cnt::CONST
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
  vd.errors := [ ];
  vd.host = vd_array(id,cnt);
  vd.name = id.lexeme ;
  vd.typerep = arrayTypeRep(vd.typerep_in);
}

-- Visibility --
nonterminal Vis with pp, host<Vis> ;
abstract production vis_empty
v::Vis ::=
{ v.pp = "";   
  v.host = vis_empty(); 
}
abstract production vis_hidden
v::Vis ::=
{ v.pp = "hidden "; 
  v.host = vis_hidden() ;
}
abstract production vis_show
v::Vis ::=
{ v.pp = "show "; 
  v.host = vis_show();
}
abstract production vis_islocal
v::Vis ::=
{ v.pp = "local "; 
  v.host = vis_islocal();
}


abstract production mtypeDecls
ds::Decls ::= v::Vis t::TypeExpr names::IDList
{ -- spin.y accepts types syntactically but requires that t be an "mtype" type.
 ds.pp =  v.pp ++ t.pp ++ " = { " ++ names.pp ++ " } ";
 ds.errors := case t of
                mtypeTypeExpr() -> [ ] 
              | _ -> [ mkError ("Type \"" ++ t.pp ++ "\" cannot be used in " ++
                                "mtype-style declration.\n" ) ] end ;

 ds.host = mtypeDecls(v.host, t.host, names.host) ;

 forwards to names.decls ;
 names.inVis = v ;
}

nonterminal IDList with pp, errors, host<IDList> ;
autocopy attribute inVis :: Vis occurs on IDList ;
synthesized attribute decls :: Decls occurs on IDList ;

nonterminal VarList with pp;
abstract production singleName
names::IDList ::= name::ID
{ names.pp = name.lexeme;
  names.host = singleName(name);
  names.decls = mtypeDecl(names.inVis, name) ;
}

abstract production snocNames
names::IDList ::= some::IDList name::ID
{ names.pp = some.pp ++ ", " ++  name.lexeme;
  names.host = snocNames(some.host, name);
  names.decls = seqDecls( some.decls, mtypeDecl(names.inVis, name) ) ;
}

abstract production mtypeDecl
ds::Decls ::= v::Vis name::ID
{ -- we assume an implicit "mtype" in this production.
 ds.pp = v.pp ++ " mtype = { " ++ name.lexeme ++ " } " ;
 ds.errors := [ ] ; 
 ds.defs = valueBinding(name.lexeme, ds);
}

{-

-----
abstract production abs_varlist2dcl
vl::VarList ::= vd::Declarator
{
 vl.basepp = vd.basepp;
 vl.pp = vd.pp;
}

-}
