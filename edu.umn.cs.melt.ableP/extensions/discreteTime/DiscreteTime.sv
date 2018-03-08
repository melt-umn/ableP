grammar edu:umn:cs:melt:ableP:extensions:discreteTime ;

imports edu:umn:cs:melt:ableP:host:core ;
imports edu:umn:cs:melt:ableP:host:extensions ;

{- ToDo: 
   - add appropriate type checking
   - add the udelay statement
 -}

terminal TIMER  'timer'   lexer classes { promela,promela_kwd};
terminal TICK   'tick'    lexer classes { promela,promela_kwd};
terminal DELAY  'delay'   lexer classes { promela,promela_kwd};
terminal SET    'set'     lexer classes { promela,promela_kwd};
terminal EXPIRE 'expire'  lexer classes { promela,promela_kwd};

-- timer type
-- #define timer int 
concrete production typeType_c
t::Type_c ::= 'timer'
{ t.pp = "timer"; 
  t.ast = timerTypeExpr();
}

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


-- delay statement --
---------------------
concrete production delay_c
st::Statement_c ::= d::'delay' '(' t::Varref_c ',' e::Expr_c ')' 
{ st.pp = "delay (" ++ t.pp ++ ", " ++ e.pp ++ ")" ;
  st.ast = delay(d, t.ast, e.ast) ;
}

-- #define delay(tmr,val) set(tmr,val); expire(tmr) 
-- #define udelay(tmr) do :: delay(tmr,1) :: break od
abstract production delay
st::Stmt ::= d::DELAY tmr::Expr val::Expr
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
  forwards to seqStmt( set( terminal(SET,"set", d.line, d.column), tmr, val),
                       expire(tmr) ) ;
}

-- #define set(tmr,val) (tmr=val) 
concrete production set_c
st::Statement_c ::= s::'set' '(' t::Varref_c ',' e::Expr_c ')' 
{ st.pp = "set (" ++ t.pp ++ ", " ++ e.pp ++ ")" ;
  st.ast = set(s, t.ast, e.ast) ;
}
abstract production set
st::Stmt ::= s::'set' t::Expr e::Expr
{ st.pp = "set (" ++ t.pp ++ ", " ++ e.pp ++ ")" ;
  st.errors
   := if   e.typerep.isArithmetic
      then [ ]
      else [ mkError ( "Incompatible value assigned into timer variable",
                       mkLoc(s.line, s.column) ) ] ;
  st.defs = emptyDefs();

  forwards to defaultAssign(t.host, terminal(ASGN, "=", s.line, s.column), e.host) ;
}

-- #define expire(tmr) (tmr==0) 
concrete production expire_c
st::Statement_c ::= 'expire' '(' e::Expr_c ')' 
{ st.pp = "expire (" ++ e.pp ++ ")" ;
  st.ast = expire(e.ast) ;
}
abstract production expire
st::Stmt ::= t::Expr
{ st.pp = "expire (" ++ t.pp ++ ")" ;
  st.errors := case t.typerep of
                 timerTypeRep() -> [ ]
               | _ -> [ mkErrorNoLoc ("on expire; expression \"" ++ t.pp ++
                                      " must be a \"timer\" type" ) ]
               end ;
  forwards to exprStmt(eqExpr(t, constExpr(terminal(CONST, "0")))) ;
}

-- #define tick(tmr) if :: tmr>=0 -> tmr=tmr-1 :: else fi
concrete production tick_c
st::Statement_c ::= 'tick' '(' e::Expr_c ')' 
{ st.pp = "tick (" ++ e.pp ++ ")" ;
  st.ast = tick(e.ast) ;
}
abstract production tick
st::Stmt ::= tmr::Expr
{ st.pp = "tick (" ++ tmr.pp ++ ")" ;
  forwards to ifStmt ( consOption ( -- tmr>=0 -> tmr=tmr-1
                             seqStmt ( exprStmt(gteExpr(tmr, zero)) ,
                                       assign(tmr, '=', minus(tmr,one)) ) ,
                        oneOption ( elseStmt() ) ) ) ;
  local zero::Expr = constExpr(terminal(CONST,"0")) ;
  local one::Expr = constExpr(terminal(CONST,"1")) ;
}

-- Need to create this process so that all ids of type timer get plugged
-- into it so that they "tick" when a timeout occurs.

-- proctype Timers() { do :: timeout -> atomic{ tick(tmr1); tick(tmr2) } od }

aspect production program
p::Program ::= u::PUnit
{ newUnits <- mkTimerProc() ;
}

abstract production mkTimerProc
u::PUnit ::=
{ local declaredTimers::[String] = allTimerDecls( u.env.bindings ) ;

  forwards to 
    if   null(declaredTimers)
    then emptyUnit() 
    else --ppUnit ("proctype Timers() { \n" ++
         --        "{ do :: timeout -> atomic{ " ++
         --        mkTickStmts( declaredTimers ) ++
         --        " } od } \n} \n" ) ;

	 unitDecls ( procDecl(
	   empty_inst(), just_procType(),
	   terminal(ID, "Timers"), emptyDecl(),
	   none_priority(), noEnabler(),
	   blockStmt(
	     doStmt(
	       oneOption (
		 seqStmt(
		   exprStmt( timeoutExpr() ),
		   atomicStmt ( mkTickStmts( declaredTimers ) 
		   )
		 )
	       )
	     )
	   )
	  )
	 ) ;


}

function allTimerDecls
[String] ::= bs::[Binding]
{ return if   null(bs)
         then [ ]
         else (case head(bs).dcl.typerep of
                 timerTypeRep() -> [ head(bs).name ]
               | _ -> [ ] end )
              ++ allTimerDecls(tail(bs))  ;
}

function mkTickStmtsStr
String ::= timers::[String]
{ return if   null(timers)
         then ""
         else "tick(" ++ head(timers) ++ "); "
              ++ mkTickStmtsStr(tail(timers))  ;
}

function mkTickStmts
Stmt ::= timers::[String]
{ return if   null(timers)
         then skipStmt()
         else seqStmt (
                tick( varRefExprAll( terminal(ID,head(timers)))) ,
                mkTickStmts( tail(timers) )
              ) ;
}
