grammar edu:umn:cs:melt:ableP:abstractsyntax ;

-- The new for loop and select constructs for Version 6 of Promela.
-- We may move these into an extension directory later on.

abstract production forRange
s::Stmt ::= f::FOR_t vr::Expr lower::Expr upper::Expr body::Stmt
{ -- s.pp = "for ( " ++ vr.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ")" ++
  --       " {\n" ++ body.pp ++ "\n} ;" ;
  -- Leave s.pp commented out so that can see that the forwards to code
  -- is correct.

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
  local op::Op = mkOp("<=", booleanTypeRep()) ;
  local label::ID = terminal(ID,"l"++toString(f.line), f.line, f.column) ;
}

