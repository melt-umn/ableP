grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

-- The new for loop and select constructs for Version 6 of Promela.
-- We may move these into an extension directory later on.

abstract production forRange
s::Stmt ::= f::FOR vr::Expr lower::Expr upper::Expr body::Stmt
{ s.pp = "for ( " ++ vr.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ")" ++
         " {\n" ++ body.pp ++ "\n} ;" ;

  s.errors := vr.errors ++ lower.errors ++ upper.errors ++ body.errors ;

  {- do :: $vr <= $upper ;  $body
        :: else; goto $label ;
     $label : skip();
   -}
  
  forwards to 
   seqStmt ( doStmt ( consOption (
                        seqStmt ( exprStmt ( genericBinOp(vr, op, upper) ) ,
                                  body
                                ) ,
                      oneOption ( 
                        seqStmt ( elseStmt() ,
                                  gotoStmt (label)
                                ) 
                      ) ) ) ,
             labeledStmt ( label, skipStmt () )
           ) ;
  local op::Op = mkOp("<=", boolTypeExpr()) ;
  local label::ID = terminal(ID,"l"++toString(f.line), f.line, f.column) ;
}


abstract production forIn
s::Stmt ::= f::FOR vr::Expr e::Expr body::Stmt
{ s.pp = "for ( " ++ vr.pp ++ " in " ++ e.pp ++ ")" ++
         " {\n" ++ body.pp ++ "\n} ;" ;

  s.errors := vr.errors ++ e.errors ++ body.errors ;
  s.host = forIn(f,vr.host, e.host,body.host) ;
  s.inlined = forIn(f,vr.inlined, e.inlined,body.inlined) ;
}



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

