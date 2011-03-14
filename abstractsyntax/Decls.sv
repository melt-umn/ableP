grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Decls   with pp, ppi, ppsep, errors, host<Decls> ; 
--synthesized attribute inlined_Decls    :: Decls  occurs on Decls ;

abstract production seqDecls
ds::Decls ::= ds1::Decls ds2::Decls
{ ds.pp = ds1.pp ++ -- ds.ppsep ++ 
          "\n" ++ 
          ds2.pp ;
  ds1.ppi = ds.ppi ;  ds1.ppsep = ds.ppsep ; 
  ds2.ppi = ds.ppi ;  ds2.ppsep = ds.ppsep ;
  ds.host = seqDecls(ds1.host, ds2.host);
-- ds.basepp = ds1.basepp ++ ";\n" ++ ds2.ppi ++ ds2.basepp ;
-- ds.errors = ds1.errors ++ ds2.errors;
-- ds.defs = mergeDefs(ds1.defs, ds2.defs);
-- ds1.env = ds.env ;
-- ds2.env = mergeDefs(ds.env, ds1.defs);
-- ds.inlined_Decls = seqDecls(ds1.inlined_Decls, ds2.inlined_Decls);
}

abstract production emptyDecl
ds::Decls ::= 
{ ds.pp = "" ;
  ds.host = emptyDecl();
-- ds.errors := [] ;
-- ds.defs = emptyDefs();
-- ds.inlined_Decls = empty_Decl();
}

abstract production varDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ++ ";" ;
 ds.host = varDecl(vis.host,  t.host, v.host);
-- ds.errors := v.errors ++ t.errors ;
-- v.typerep_in = t.typerep;
-- ds.defs = valueBinding(v.name, v.typerep) ; 
-- ds.inlined_Decls = varDecl(vis, t, v);
-- t.env = ds.env ;
}

abstract production varAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{
 ds.pp = ds.ppi ++ vis.pp ++ t.pp ++ " " ++ v.pp ++ " = " ++ e.pp ++ ";" ;
 ds.host = varAssignDecl(vis.host, t.host, v.host, e.host) ;
-- ds.errors := t.errors ++ v.errors ++ e.errors ;
-- v.typerep_in = t.typerep;
-- ds.defs = valueBinding(v.name, v.typerep) ;
}

inherited attribute typerep_in :: TypeRep ;

nonterminal Declarator  with pp, errors, host<Declarator> ;
abstract production vd_id
vd::Declarator ::= id::ID
{ vd.pp = id.lexeme;
  vd.errors := [ ];
  vd.host = vd_id(id);
-- vd.name = id.lexeme ;
-- vd.typerep = vd.typerep_in ;
}

abstract production vd_idconst
vd::Declarator ::= id::ID cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
  vd.errors := [ ];
  vd.host = vd_idconst(id,cnt);
-- vd.name = id.lexeme ;
-- vd.typerep = vd.typerep_in ; -- ToDo - are there typing issues here?
}

abstract production vd_array
vd::Declarator ::= id::ID cnt::CONST
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
  vd.errors := [ ];
  vd.host = vd_array(id,cnt);
-- vd.name = id.lexeme ;
-- vd.typerep = array_type(vd.typerep_in);
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


abstract production mtypeDecl
ds::Decls ::= v::Vis t::TypeExpr names::IDList
{
 ds.pp =  v.pp ++ t.pp ++ " = { " ++ names.pp ++ " } ";
 ds.errors := names.errors;
-- ds.defs = namelist.mtype_defs ;
}

nonterminal IDList with pp, errors ;
--synthesized attribute mtype_defs :: Env occurs on IDList ;

nonterminal VarList with basepp,pp;
abstract production singleName
nlst::IDList ::= n::ID
{ nlst.pp = n.lexeme;
  nlst.errors := [ ];
  -- nlst.mtype_defs = valueBinding(n.lexeme, mtype_type());
}

abstract production snocNames
nlst::IDList ::= some::IDList n::ID
{ nlst.pp = some.pp ++ ", " ++  n.lexeme;
  nlst.errors := some.errors;
 -- nlst1.mtype_defs = mergeDefs(nlst2.mtype_defs, valueBinding(n.lexeme, mtype_type())) ;
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
