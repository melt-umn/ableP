grammar edu:umn:cs:melt:ableP:extensions:enhancedSelect ;

-- import edu:umn:cs:melt:ableP:host ;
import edu:umn:cs:melt:ableP:concretesyntax ;
import edu:umn:cs:melt:ableP:abstractsyntax ;
import edu:umn:cs:melt:ableP:terminals ;

terminal Step_t 'step' ;

-- Concrete Syntax --
concrete production enhSelelct_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' lower::Expr_c '..' upper::Expr_c 
                                  'step' step::Expr_c ')'
{ s.pp = "select ( " ++ v.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++
                                         " step " ++ step.pp ++ " ) " ;
  s.ast = 
   case lower of constExpr_c(lwCnst) ->
     case upper of constExpr_c(upCnst) ->
       case step  of constExpr_c(stCnst) ->
         enhSelectConst(sl, v.ast, lwCnst, upCnst, stCnst)
       | _ -> enhSelect(sl,v.ast, lower.ast, upper.ast, step.ast) end
     | _ -> enhSelect(sl,v.ast, lower.ast, upper.ast, step.ast) end
   | _ -> enhSelect(sl,v.ast, lower.ast, upper.ast, step.ast) end ;
}

concrete production selectFrom_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' exprs::Exprs_c ')'
{ s.ast = selectFrom (sl, v.ast, exprs.ast) ; 
  s.pp = "select ( " ++ v.pp ++ " : " ++ exprs.pp ++ " ) " ;
}


-- Abstract Syntax --
abstract production selectFrom
s::Stmt ::= sl::'select' v::Expr exprs::Exprs
{ s.pp = "select ( " ++ v.pp ++ ":" ++ exprs.pp ++ " ); \n" ;
  s.errors := v.errors ++ exprs.errors ++
              if true -- ToDo
              then [ mkError ("Error: select statement on line " ++ toString(sl.line) ++
                              " requires all possible choices to have the same type " ++
                              " as variable assigned to, which is \"" ++
                              v.typerep.pp ++ "\"." ) ]
              else [ ] ;
             -- check that all of exprs.typerep are assignable to v

  forwards to ifStmt( mkOptionsExprs (v, exprs) ) ;
}

abstract production enhSelect
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
     assign (v, lower),
     seqStmt (
       doStmt ( 
         consOption (
           gotoStmt (label) ,
           oneOption ( 
             seqStmt (
               exprStmt ( genericBinOp(v, op, upper) ) ,
               assign (v, genericBinOp(v, opPlus, step) ) 
             )
           )
         )
       ) , 
       labeledStmt ( label, skipStmt () )
     )
   ) ;
  local op::Op = mkOp("<", boolTypeRep()) ;
  local opPlus::Op = mkOp("+", intTypeRep()) ;
  local label::ID = terminal(ID,"l"++toString(sl.line), sl.line, sl.column) ;
}


abstract production enhSelectConst
s::Stmt ::= sl::'select' v::Expr lower::CONST upper::CONST step::CONST
{ s.pp = "select ( " ++ v.pp ++ ":" ++ lower.lexeme ++ " .. " ++ upper.lexeme ++
                   " step " ++ step.lexeme ++ " ); " ;
  s.errors := v.errors ;

  {- if ::v = lower;  ::v = lower+step;  ... ::v = upper;  fi;  -}
  forwards to ifStmt (mkOptions(v, lw, up, by)) ;

  local lw::Integer = toInt(lower.lexeme);  
  local up::Integer = toInt(upper.lexeme);  
  local by::Integer = toInt(step.lexeme);  
}

function mkOptions
Options ::= v::Expr lw::Integer up::Integer by::Integer
{ return if   lw > up
         then oneOption(skipStmt())
         else consOption (
                assign(v, constExpr(terminal(CONST,toString(lw)))) ,
                mkOptions(v, lw+by, up, by) 
              ) ;
}

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

