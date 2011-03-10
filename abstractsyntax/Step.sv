grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal Asgn with basepp,pp;
nonterminal VrefList with basepp,pp;
nonterminal ChInit with basepp,pp;

abstract production asgn
a::Asgn ::= 
{
 a.basepp = "=";
 a.pp = "=";
}

abstract production asgn_empty
a::Asgn ::= 
{
 a.basepp = "";
 a.pp = "";
}

abstract production single_varref
vrl::VrefList ::= vref::Expr
{
  vrl.basepp = vref.basepp;
  vrl.pp = vref.basepp;
  vrl.errors = vref.errors;
  vref.env = vrl.env;
}

abstract production comma_varref
vrl1::VrefList ::= vref::Expr vrl2::VrefList
{
 vrl1.basepp = vref.basepp ++ "," ++ vrl2.basepp;
 vrl1.pp = vref.pp ++ "," ++ vrl2.pp;
 vrl1.errors = vref.errors ++ vrl2.errors;
 vref.env = vrl1.env;
 vrl2.env = vrl1.env;
}
