grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

nonterminal Loc with linBeg, colBeg, linEnd, colEnd, lfile, pp ;
synthesized attribute linBeg::Integer ;
synthesized attribute colBeg::Integer ;
synthesized attribute linEnd::Integer ;
synthesized attribute colEnd::Integer ;
synthesized attribute lfile::String ;

function mkLoc -- a Point
Loc ::= l::Integer c::Integer
{ return mkLocation(l, c, l, c, "") ; } 

function mkLocFile  -- a Point
Loc ::= l::Integer c::Integer f::String
{ return mkLocation(l, c, l, c, f) ; } 

function mergeLocs  -- a Span
Loc ::= l1::Loc l2::Loc
{ return mkLocation ( l1.linBeg, l1.colBeg, 
                      l2.linEnd, l2.colEnd, l1.lfile ) ; 
}

function noLoc
Loc ::=
{ return  mkLocation (-1, -1, -1, -1, "") ; }

abstract production mkLocation 
loc::Loc ::= ls::Integer cs::Integer le::Integer ce::Integer f::String
{ loc.linBeg = ls; loc.colBeg = cs;  
  loc.linEnd = le; loc.colEnd = ce;  
  loc.lfile = f ;

  loc.pp = "line " ++ toString(loc.linBeg) ++ " column " ++ toString(loc.colBeg) ;
}


-- Terminal specific location constructors
function mkLocID
Loc ::= t::ID
{ return mkLocation ( t.line, t.column, -1, -1, t.filename ) ; } 
