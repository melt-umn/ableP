grammar edu:umn:cs:melt:ableP:abstractsyntax ;

imports edu:umn:cs:melt:ableP:terminals;

imports lib:langproc:errors ;

-- Attibutes used by most nonterminals.
synthesized attribute pp::String ;
autocopy attribute ppi::String;
autocopy attribute ppsep::String;
synthesized attribute basepp::String;


synthesized attribute errors::[ Error ] with ++ ;



{- nonterminal Program ;
abstract production program 
p::Program ::= u::Units   { }

nonterminal Units ;
abstract production units_one
us::Units ::= u::Units { } 
abstract production units_snoc
us::Units ::= some::Units u::Unit { }

nonterminal Unit;  -}
