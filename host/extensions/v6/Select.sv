grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

-- This files contains the abstract syntax for the new
-- select-statement constructs and aspects on its concrete syntax.

-- Selelct statement --
-----------------------
abstract production select
s::Stmt ::= sk::SELECT v::Expr lower::Expr upper::Expr 
{ s.pp = "select ( " ++ v.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ") ;\n" ;
  s.errors := v.errors ++ lower.errors ++ upper.errors ;

  {- $v = $lower ;
     do :: goto $label ;
        :: ($v < $upper) ; $v = $v + 1 ;
     $label : skip();
   -}
  
  forwards to 
   seqStmt ( assign(v,lower),
             seqStmt (
               doStmt ( consOption (
                          gotoStmt (label) ,
                          oneOption ( 
                            seqStmt ( 
                              exprStmt ( genericBinOp(v, oplt, upper) ) ,
                              assign (v, genericBinOp(v, opplus, one) )
                            )
                          )  
                        )
               ) ,
               labeledStmt ( label, skipStmt () )
             )
           ) ;
  local oplt::Op = mkOp("<", boolTypeExpr()) ;
  local opplus::Op = mkOp("+", boolTypeExpr()) ;
  local one::Expr = constExpr(terminal(CONST,"1")) ;
  local label::ID = terminal(ID,"l"++toString(sk.line), sk.line, sk.column) ;
}


-- Mapping the select concrete syntax to its abstract syntax.
aspect production select_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' lower::Expr_c '..' upper::Expr_c ')'
{ s.pp = "select (" ++ v.pp ++ ": " ++ lower.pp ++ ".." ++ upper.pp ++ ")" ; 
  s.ast = select (sl, v.ast, lower.ast, upper.ast) ;
}
