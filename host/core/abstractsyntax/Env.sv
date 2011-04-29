grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

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


synthesized attribute uses::[Use]
  occurs on Unit, Stmt, Options, Expr, Exprs,
            Decls, Declarator, 
            MArgs, RArgs, RArg ;

autocopy attribute alluses::[Use]
  occurs on Unit, Stmt, Options, Expr, Exprs,
            Decls, Declarator, 
            MArgs, RArgs, RArg ;

attribute env
  occurs on Unit, Stmt, Options, Expr, Exprs, Enabler,
            Decls, Declarator, IDList,
            MArgs, RArgs, RArg ;

attribute defs
  occurs on Unit, Stmt, Options,
            Decls, Declarator, IDList ;

nonterminal Use ;
abstract production mkUse
u::Use ::= did::Integer e::Decorated Expr
{ }

