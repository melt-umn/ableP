grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal Decls   with pp, basepp, ppi, ppsep, defs, env, errors ;
nonterminal VarDcl  with pp, basepp, name, errors, typerep, typerep_in ;
nonterminal Vis     with pp, basepp ;

synthesized attribute inlined_Decls    :: Decls  occurs on Decls ;

synthesized attribute name :: String ;


abstract production seqDecls
ds::Decls ::= ds1::Decls ds2::Decls
{
 ds.pp = ds1.pp ++ ds.ppsep ++ ds2.ppi ++ ds2.pp ;
 ds1.ppi = ds.ppi ; 
 ds2.ppi = ds.ppi ;
 ds1.ppsep = ds.ppsep ;
 ds2.ppsep = ds.ppsep ;
 ds.basepp = ds1.basepp ++ ";\n" ++ ds2.ppi ++ ds2.basepp ;

 ds.errors = ds1.errors ++ ds2.errors;

 ds.defs = mergeDefs(ds1.defs, ds2.defs);
 ds1.env = ds.env ;
 ds2.env = mergeDefs(ds.env, ds1.defs);
 ds.inlined_Decls = seqDecls(ds1.inlined_Decls, ds2.inlined_Decls);
}

abstract production empty_Decl
ds::Decls ::= 
{
 ds.pp = "" ;
 ds.basepp = "" ;
 ds.errors = [] ;
 ds.defs = emptyDefs();
 ds.inlined_Decls = empty_Decl();
}

abstract production varDecl
ds::Decls ::= vis::Vis t::Type v::VarDcl
{
 ds.pp =  vis.pp ++ t.pp ++ " " ++ v.pp ;
 ds.basepp =  vis.basepp ++ t.pp ++ " " ++ v.basepp ;
 ds.errors = v.errors ++ t.errors ;

 v.typerep_in = t.typerep;
 ds.defs = valueBinding(v.name, v.typerep) ; 
 ds.inlined_Decls = varDecl(vis, t, v);

 t.env = ds.env ;
}

abstract production varAssignDecl
ds::Decls ::= vis::Vis t::Type v::VarDcl e::Expr
{
 ds.pp = vis.pp ++ t.pp ++ " " ++ v.pp ++ " = " ++ e.pp ;
 ds.basepp = vis.basepp ++ t.pp ++ " " ++ v.basepp ++ " = " ++ e.basepp ;

 v.typerep_in = t.typerep;
 ds.defs = valueBinding(v.name, v.typerep) ;

 ds.errors = t.errors ++ v.errors ++ e.errors ;
}

abstract production mtypeDecl
ds::Decls ::= v::Vis t::Type a::Asgn namelist::IDList
{
 ds.pp =  v.pp ++ t.pp ++ " " ++ a.pp ++ " { " ++ namelist.pp ++ " } ";
 ds.basepp =  v.basepp ++ t.pp ++ " " ++ a.basepp ++ " { " ++ namelist.basepp ++ " } ";
 ds.defs = namelist.mtype_defs ;
 ds.errors = namelist.errors;
}

inherited attribute typerep_in :: TypeRep ;

abstract production vd_id
vd::VarDcl ::= id::ID
{
 vd.basepp = id.lexeme;
 vd.pp = id.lexeme;
 vd.name = id.lexeme ;
 vd.typerep = vd.typerep_in ;
 vd.errors = [ ];
}

abstract production vd_idconst
vd::VarDcl ::= id::ID cnt::CONST
{
 vd.basepp = id.lexeme ++ ":" ++ cnt.lexeme;
 vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
 vd.name = id.lexeme ;
 vd.typerep = vd.typerep_in ; -- ToDo - are there typing issues here?
 vd.errors = [ ];
}

abstract production vd_array
vd::VarDcl ::= id::ID cnt::CONST
{
 vd.basepp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
 vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
 vd.name = id.lexeme ;
 vd.typerep = array_type(vd.typerep_in);
 vd.errors = [ ];
}

nonterminal IDList with basepp,pp;
synthesized attribute mtype_defs :: Env occurs on IDList ;

nonterminal VarList with basepp,pp;
abstract production singleName
nlst::IDList ::= n::ID
{
 nlst.basepp = n.lexeme;
 nlst.pp = n.lexeme;
 nlst.errors = [];
 nlst.mtype_defs = valueBinding(n.lexeme, mtype_type());
}

abstract production multiNames
nlst1::IDList ::= nlst2::IDList n::ID
{
 nlst1.basepp = nlst2.basepp ++ n.lexeme;
 nlst1.pp = nlst2.pp ++ n.lexeme;
 nlst1.errors = nlst2.errors;
 nlst1.mtype_defs = mergeDefs(nlst2.mtype_defs, valueBinding(n.lexeme, mtype_type())) ;
}

abstract production commaNames
nlst1::IDList ::= nlst2::IDList
{
 nlst1.basepp = nlst2.basepp ++ ",";
 nlst1.pp = nlst2.pp ++ ",";
 nlst1.errors = nlst2.errors;
 nlst1.mtype_defs = nlst2.mtype_defs ;
}


-----
abstract production abs_varlist2dcl
vl::VarList ::= vd::VarDcl
{
 vl.basepp = vd.basepp;
 vl.pp = vd.pp;
}
-- Visibility --
abstract production vis_hidden
v::Vis ::=
{
 v.basepp = "hidden ";
 v.pp = "hidden ";
}

abstract production vis_show
v::Vis ::=
{
 v.basepp = "show ";
 v.pp = "show ";
}

abstract production vis_islocal
v::Vis ::=
{
 v.basepp = "local ";
 v.pp = "local ";
}

abstract production vis_empty
v::Vis ::=
{
  v.basepp = "";
  v.pp = "";
}

