grammar edu:umn:cs:melt:ableP:extensions:enhancedSelect ;

-- Concrete Syntax --

terminal Step_t 'step' ;

-- select ( x : 1 to 100 step 3 )
concrete production selectStep_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' lower::Expr_c '..' upper::Expr_c 
                                  'step' step::Expr_c ')'
{ s.pp = "select ( " ++ v.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++
                                         " step " ++ step.pp ++ " ) " ;
  s.ast = 
   case lower of constExpr_c(lwCnst) ->
     case upper of constExpr_c(upCnst) ->
       case step  of constExpr_c(stCnst) ->

         selectStepConst(sl, v.ast, lwCnst, upCnst, stCnst)

       | _ -> selectStep(sl,v.ast, lower.ast, upper.ast, step.ast) end
     | _ -> selectStep(sl,v.ast, lower.ast, upper.ast, step.ast) end
   | _ -> selectStep(sl,v.ast, lower.ast, upper.ast, step.ast) end ;
}


-- Abstract Syntax --

abstract production selectStep
s::Stmt ::= sl::'select' v::Expr lower::Expr upper::Expr step::Expr
{ s.pp = "select ( " ++ v.pp ++ ":" ++ lower.pp ++ " .. " ++ upper.pp ++
                   " step " ++ step.pp ++ " ); \n" ;
  s.errors := v.errors ++ lower.errors ++ upper.errors ++ step.errors ;

  {- $v = $lower ; 
     do :: goto $label ;
        :: $v <= $upper ;  $v = $v + 1;
     $label : skip();
   -}
  
  forwards to 
   seqStmt ( 
     assign (v, '=', lower),
     seqStmt (
       doStmt ( 
         consOption (
           gotoStmt (label) ,
           oneOption ( 
             seqStmt (
               exprStmt ( genericBinOp(v, op, upper) ) ,
               assign (v, '=', genericBinOp(v, opPlus, step) ) 
             )
           )
         )
       ) , 
       labeledStmt ( label, skipStmt () )
     )
   ) ;
  local op::Op = mkOp("<", boolTypeExpr()) ;
  local opPlus::Op = mkOp("+", intTypeExpr()) ;
  local label::ID = terminal(ID,"l"++toString(sl.line), sl.location) ;
}


abstract production selectStepConst
s::Stmt ::= sl::'select' v::Expr lower::CONST upper::CONST step::CONST
{ s.pp = "select ( " ++ v.pp ++ ":" ++ lower.lexeme ++ " .. " ++ upper.lexeme ++
                   " step " ++ step.lexeme ++ " ); " ;
  s.errors := if   lw > up
              then [ mkError ("Select statement requires lower bound to be " ++ 
                              "less than or equal to upper bound.",
                               mkLoc(sl.line, sl.column) ) ] ++
                   v.errors
              else v.errors ;

  {- if ::v = lower;  ::v = lower+step;  ... ::v = upper;  fi;  -}
  forwards to ifStmt (mkOptions(v, lw, up, by)) ;

  local lw::Integer = toInteger(lower.lexeme);  
  local up::Integer = toInteger(upper.lexeme);  
  local by::Integer = toInteger(step.lexeme);  
}

function mkOptions
Options ::= v::Expr lw::Integer up::Integer by::Integer
{ return if   lw + by > up
         then oneOption(stmt)
         else consOption ( stmt, mkOptions(v, lw+by, up, by) ) ;
 local stmt::Stmt = assign(v, '=', constExpr(terminal(CONST,toString(lw)))) ;
}


