grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

-- This files contains the abstract syntax for the new for-loop
-- aspects on its concrete syntax.

-- For loop --
--------------
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


-- Aspects on concrete syntax for for-loops --
----------------------------------------------
attribute pp, ppi occurs on ForPre_c ; 
attribute ast<Expr> occurs on ForPre_c ; 
attribute forTerminal occurs on ForPre_c ; 

aspect production forPre_c
fp::ForPre_c ::= f::FOR '(' v::Varref_c 
{ fp.pp = "for (" ++ v.pp ; 
  fp.ast = v.ast ; 
  fp.forTerminal = f ;
}

attribute pp, ppi occurs on ForPost_c ;
attribute ast<Stmt> occurs on ForPost_c ;

aspect production forPost_c
fp::ForPost_c ::= '{' s::Sequence_c os::OS_c '}'
{ fp.pp = "{ " ++ s.pp ++ os.pp ++ "}" ; 
  fp.ast = s.ast ;
}

aspect production forRange_c
s::Special_c ::= fpre::ForPre_c ':' lower::Expr_c '..' upper::Expr_c ')' 
                 fpost::ForPost_c 
{ s.pp = fpre.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ")" ++ fpost.pp ; 
  s.ast = forRange ( fpre.forTerminal, fpre.ast, lower.ast, upper.ast, fpost.ast ) ;
}

aspect production forIn_c
s::Special_c ::= fpre::ForPre_c 'in' v::Varref_c ')' fpost::ForPost_c 
{ s.pp = fpre.pp ++ " in " ++ v.pp ++ ")" ++ fpost.pp ; 
  s.ast = forIn(fpre.forTerminal, fpre.ast, v.ast, fpost.ast) ;
}
