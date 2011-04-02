grammar edu:umn:cs:melt:ableP:abstractsyntax ;

imports lib:langproc:errors ;
exports lib:langproc:errors ;

imports edu:umn:cs:melt:ableP:terminals;

-- Attibutes used by most nonterminals.
synthesized attribute pp::String ;
autocopy attribute ppi::String;
autocopy attribute ppsep::String;
autocopy attribute ppterm::String;

--synthesized attribute basepp::String;

synthesized attribute errors::[ Error ] with ++ ;


function mkLoc
String ::= l::Integer c::Integer
{
 return "line: " ++ toString(l) ++ ", column: " ++ toString(c) ;
}
