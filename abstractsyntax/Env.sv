grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

autocopy attribute env::Env;
synthesized attribute defs::Env;

nonterminal Env with bindings;
nonterminal Binding with name, typerep;

abstract production bind
b::Binding ::= n::String t::TypeRep
{
 b.name = n;
 b.typerep = t;
}
synthesized attribute bindings::[ Binding ];

abstract production emptyDefs
e::Env ::=
{
 e.bindings = [ ];
}

abstract production mergeDefs
e::Env ::= e1::Env e2::Env
{
 e.bindings = e1.bindings ++ e2.bindings;
}

function lookup_name
EnvResult ::= n::String e::Env
{
 return res ; 

 local attribute res :: EnvResult ;
 res = lookup_name_helper (n, e.bindings) ;
}

function lookup_name_helper
EnvResult ::= n::String bs::[Binding]
{
 return if   null(bs) 
        then env_res(false, error_type())
        else if   n == head(bs).name
             then env_res(true, head(bs).typerep)
             else lookup_name_helper(n, tail(bs)) ;
}


synthesized attribute found :: Boolean ;
nonterminal EnvResult with found, typerep ;

abstract production env_res
e::EnvResult ::= f::Boolean t::TypeRep
{ e.found = f ;
  e.typerep = t ;
}

function show_env
String ::= e::Env
{ return show_env_helper( e.bindings );
}

function show_env_helper
String ::= bs :: [Binding]
{ return if   null(bs) 
         then ""
         else head(bs).name ++ " : " ++ head(bs).typerep.pp ++ " \n" ++ show_env_helper(tail(bs)) ;
}

function mkError
[ String] ::= l::Integer c::Integer msg::String
{
 return [ "Error (line " ++ toString(l) ++ " col " ++ toString(c) ++ "): " ++ msg ] ;
}

function mkError_no_lc
[ String] ::= msg::String
{
 return [ "Error: " ++ msg ] ;
}
