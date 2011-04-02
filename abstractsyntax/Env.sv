grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Env with bindings;
nonterminal Binding with name, dcl;

autocopy attribute env::Env;
synthesized attribute defs::Env;
synthesized attribute name :: String ;
synthesized attribute bindings::[ Binding ];
synthesized attribute dcl::Decorated Decls ;

abstract production bind
b::Binding ::= n::String d::Decorated Decls
{ b.name = n;
  b.dcl = d;
}

abstract production emptyDefs
e::Env ::=
{
 e.bindings = [ ];
}

abstract production valueBinding
e::Env ::= n::String d::Decorated Decls
{
 e.bindings = [bind(n,d)];
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
        then env_res(false, decorate emptyDecl() with {} )
        else if   n == head(bs).name
             then env_res(true, head(bs).dcl)
             else lookup_name_helper(n, tail(bs)) ;
}

synthesized attribute found :: Boolean ;
nonterminal EnvResult with found, dcl ;

abstract production env_res
e::EnvResult ::= f::Boolean d::Decorated Decls
{ e.found = f ;
  e.dcl = d ;
}

function show_env
String ::= e::Env
{ return show_env_helper( e.bindings );
}

function show_env_helper
String ::= bs :: [Binding]
{ return if   null(bs) 
         then ""
         else head(bs).name ++ " : " ++ head(bs).dcl.typerep.pp ++ " \n" ++ 
              show_env_helper(tail(bs)) ;
}


synthesized attribute uses::[Use]
  occurs on Units, Unit, Stmt, Body, Options, Expr, Exprs,
            Decls, Declarator, 
            Args, MArgs, RArgs, RArg ;

autocopy attribute alluses::[Use]
  occurs on Units, Unit, Stmt, Body, Options, Expr, Exprs,
            Decls, Declarator, 
            Args, MArgs, RArgs, RArg ;

attribute env
  occurs on Units, Unit, Stmt, Body, Options, Expr, Exprs,
            Decls, Declarator, IDList,
            Args, MArgs, RArgs, RArg ;

attribute defs
  occurs on Units, Unit, Stmt, Options, Body, 
            Decls, Declarator, IDList ;

nonterminal Use ;
abstract production mkUse
u::Use ::= did::Integer e::Decorated Expr
{ }

{-
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
-}
