grammar edu:umn:cs:melt:ableP:extensions:enhancedSelect ;

imports edu:umn:cs:melt:ableP:host:core ;
imports edu:umn:cs:melt:ableP:host:extensions ;

-- Concrete Syntax --

-- e.g. select ( quality : Low, Medium, High )
concrete production selectFrom_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' exprs::Arg_c ')'
{ s.pp = "select ( " ++ v.pp ++ " : " ++ exprs.pp ++ " ) " ;
  s.ast = selectFrom (sl, v.ast, exprs.ast) ; 
}


-- Abstract Syntax --

-- e.g. select ( quality : Low, Medium, High )
abstract production selectFrom
s::Stmt ::= sl::'select' v::Expr exprs::Exprs
{ s.pp = "select ( " ++ v.pp ++ ":" ++ exprs.pp ++ " ); \n" ;
  forwards to ifStmt( mkOptionsExprs (v, exprs) ) ;
}

-- A non-traditional approach - examining the structure of the Exprs tree.
function mkOptionsExprs
Options ::= v::Expr exprs::Exprs
{ return case exprs of
           noneExprs() -> oneOption(skipStmt())
         | oneExprs(e) -> oneOption(assign(v,'=',e))
         | consExprs(e,es) -> consOption (
                                assign(v,'=',e) ,
                                mkOptionsExprs(v, es) )
         end ;
}

-- Type checking, as an aspect with a collection attribute
aspect production selectFrom
s::Stmt ::= sl::'select' v::Expr exprs::Exprs
{ s.errors := if ! (null(exprs.selectErrors)) 
              then [ mkError ("Select statement requires all choices to " ++
                              "have the same type\n as variable assigned to, " ++ 
                              "which is \"" ++ v.typerep.pp ++ "\".", 
                              thisLoc ) ] ++
                   exprs.selectErrors 
              else [ ] ;
 exprs.vrefTypeRep = v.typerep ;

 local thisLoc::Loc = mkLoc(sl.line, sl.column) ;
 exprs.selectLoc = thisLoc ;
}

-- A "traditional" AG approach, using inherited and synthesized attributes.
synthesized attribute selectErrors :: [ Error ] with ++ ;
autocopy attribute selectLoc :: Loc ;
attribute selectErrors, selectLoc occurs on Exprs ;

inherited attribute vrefTypeRep :: TypeRep occurs on Exprs ;
aspect production noneExprs  es::Exprs ::=
{ es.selectErrors := [ ] ;  
}
aspect production consExprs  es::Exprs ::= e::Expr rest::Exprs
{ es.selectErrors := 
   ( if areCompatible( es.vrefTypeRep, e.typerep )  then [ ]
     else [ mkError ("Expressions that should have the same type instead " ++
                     "have types \n \"" ++ e.typerep.pp ++
                     " and \"" ++ es.vrefTypeRep.pp ++ "\".", 
                     es.selectLoc ) ]
   ) ++ rest.selectErrors ; 
   rest.vrefTypeRep = es.vrefTypeRep ;
}
