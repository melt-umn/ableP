grammar edu:umn:cs:melt:ableP:extensions:enhancedSelect ;

imports edu:umn:cs:melt:ableP:host:core ;
imports edu:umn:cs:melt:ableP:host:extensions ;

-- Concrete Syntax --

-- select ( quality : Low, Medium, High )
concrete production selectFrom_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' exprs::Arg_c ')'
{ s.pp = "select ( " ++ v.pp ++ " : " ++ exprs.pp ++ " ) " ;
  s.ast = selectFrom (sl, v.ast, exprs.ast) ; 
}


-- Abstract Syntax --

-- select ( quality : Low, Medium, High )
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
         | oneExprs(e) -> oneOption(assign(v,e))
         | consExprs(e,es) -> consOption (
                                assign(v,e) ,
                                mkOptionsExprs(v, es) )
         end ;
}

-- Type checking, as an aspect with a collection attribute
aspect production selectFrom
s::Stmt ::= sl::'select' v::Expr exprs::Exprs
{ s.errors := if ! (null(exprs.selectErrors)) 
              then [ mkError ("Error: select statement on line " ++ 
                              toString(sl.line) ++ " requires all choices to " ++
                              "have the same \ntype as variable assigned to, " ++ 
                              " which is \"" ++ v.typerep.pp ++ "\"." ) ] ++
                   exprs.selectErrors 
              else [ ] ;
 exprs.vrefTypeRep = v.typerep ;
}

-- A "traditional" AG approach, using inherited and synthesized attributes.
synthesized attribute selectErrors :: [ Error ] with ++ ;
attribute selectErrors occurs on Exprs ;

inherited attribute vrefTypeRep :: TypeRep occurs on Exprs ;
aspect production noneExprs  es::Exprs ::=
{ es.selectErrors := [ ] ;  
}
aspect production consExprs  es::Exprs ::= e::Expr rest::Exprs
{ es.selectErrors := 
   ( if areCompatible( es.vrefTypeRep, e.typerep )  then [ ]
     else [ mkError ("Error: Expression has type \"" ++ e.typerep.pp ++
                     " but it should be \"" ++ es.vrefTypeRep.pp ++ "\"." ) ] 
   ) ++ rest.selectErrors ; 
   rest.vrefTypeRep = es.vrefTypeRep ;
}
