grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax ;

imports edu:umn:cs:melt:ableP:host:core:terminals;

-- Attibutes used by most nonterminals.

synthesized attribute pp::String ;
synthesized attribute errors::[ Error ] with ++ ;
synthesized attribute host<a>::a ;

-- asList is used on some list-like nonterminals
synthesized attribute asList<a>::[a] ;

-- ToDo, remove this as we will now do pp from the CST.
inherited attribute ppi::String;
inherited attribute ppsep::String;
autocopy attribute ppterm::String;


--function mkLoc
--String ::= l::Integer c::Integer
--{
-- return "line: " ++ toString(l) ++ ", column: " ++ toString(c) ;
--}
