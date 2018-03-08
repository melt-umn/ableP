grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

function ifNEspace
String ::= s::String
{ return if s == "" then "" else " " ; }
