grammar edu:umn:cs:melt:ableP:extensions:discreteTime ;

imports edu:umn:cs:melt:ableP:concretesyntax ;
imports edu:umn:cs:melt:ableP:abstractsyntax ;
imports edu:umn:cs:melt:ableP:terminals ;

terminal TIMER 'timer'  lexer classes { promela,promela_kwd};
terminal DELAY 'delay'  lexer classes { promela,promela_kwd};

-- timer type
-- #define timer int 
concrete productions
t::Type_c ::= 'timer'
  { t.pp = "timer"; t.ast = timerTypeExpr(); }

abstract production timerTypeExpr
t::TypeExpr ::=
{ t.pp = "timer";
  t.typerep = timerTypeRep();
  t.errors := [ ];
  t.host = intTypeExpr() ;
}

abstract production timerTypeRep
t::TypeRep ::= 
{ t.pp = "timer" ;
  t.host = intTypeRep();
  t.tag = "timer";
  t.isCompatible = false;
}


-- delay statement
concrete production delay_c
st::Statement_c ::= 'delay' '(' t::Varref_c ',' e::Expr_c ')' 
{ st.pp = "delay (" ++ t.pp ++ ", " ++ e.pp ++ ")" ;
  st.ast = delay(t.ast, e.ast) ;
}

-- #define delay(tmr,val) set(tmr,val); expire(tmr) 
-- #define udelay(tmr) do :: delay(tmr,1) :: break od
abstract production delay
st::Stmt ::= tmr::Expr val::Expr
{ st.pp = "delay (" ++ tmr.pp ++ ", " ++ val.pp ++ ")" ;
  st.errors := 
{-             case tmr.typerep of
                 timerTypeRep() -> [ ] 
               | _ -> [ mkError("\"" ++ tmr.pp ++ "\" must be of type \"timer\".") ]
               end ++
               case val.typerep of
                 timerTypeRep() -> [ ] 
               | _ -> [ mkError("\"" ++ val.pp ++ "\" must be of type \"timer\".") ]
               end ++ -}
               tmr.errors ++ val.errors ;
  forwards to seqStmt( set(tmr,val), expire(tmr) ) ;
}

-- #define set(tmr,val) (tmr=val) 
abstract production set
st::Stmt ::= t::Expr e::Expr
{ st.pp = "set (" ++ t.pp ++ ", " ++ e.pp ++ ")" ;
  forwards to assign(t.host, e.host) ;
}

-- #define expire(tmr) (tmr==0) 
abstract production expire
st::Stmt ::= t::Expr
{ st.pp = "expire (" ++ t.pp ++ ")" ;
  forwards to exprStmt(eqExpr(t, constExpr(terminal(CONST, "0")))) ;
}

-- #define tick(tmr) if :: tmr>=0 -> tmr=tmr-1 :: else fi
abstract production tick
st::Stmt ::= tmr::Expr
{ st.pp = "tick (" ++ tmr.pp ++ ")" ;
  forwards to ifStmt ( consOption ( -- tmr>=0 -> tmr=tmr-1
                             seqStmt ( exprStmt(gteExpr(tmr, zero)) ,
                                       assign(tmr, minus(tmr,one)) ) ,
                        oneOption ( elseStmt() ) ) ) ;
  local zero::Expr = constExpr(terminal(CONST,"0")) ;
  local one::Expr = constExpr(terminal(CONST,"1")) ;
}

-- Need to create this process so that all ids of type timer get plugged
-- into it so that they "tick" when a timeout occurs.
-- We need a synthesized attribute that maps uses back to decls.  
-- Reverse of our reference attrs! 
-- This is a genuine need for the decl-ref-to-use case.

-- proctype Timers() { do :: timeout -> atomic{ tick(tmr1); tick(tmr2) } od }

aspect production program
p::Program ::= u::Unit
{
 newUnits <- mkTimerProc() ;

 newUnits <- ppUnit ("int TICK_MAYBE ;\n");

 newUnits <- commentedUnit ("/* Hi */\n", emptyUnit()) ;

 newUnits <- 
  unitDecls(defaultVarDecl ( vis_empty(), intTypeExpr(), vd_id ( terminal(ID,"FOOO"))));

}

abstract production mkTimerProc
u::Unit ::=
{
 forwards to ppUnit ("proctype Timers() { \n" ++
                     "{ do :: timeout -> atomic{ " ++
                     allTimerDecls( u.env.bindings ) ++
                     " } od } \n" ) ;
}

function allTimerDecls
String ::= bs::[Binding]
{ return if   null(bs)
         then ""
         else (case head(bs).dcl.typerep of
                 timerTypeRep() -> "tick(" ++ head(bs).name ++ "); "
               | _ -> "" end )
              ++ allTimerDecls(tail(bs))  ;
}
