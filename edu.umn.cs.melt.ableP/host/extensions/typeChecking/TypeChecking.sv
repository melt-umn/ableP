grammar edu:umn:cs:melt:ableP:host:extensions:typeChecking ;

imports edu:umn:cs:melt:ableP:host:core:concretesyntax ;
imports edu:umn:cs:melt:ableP:host:core:abstractsyntax ;

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


