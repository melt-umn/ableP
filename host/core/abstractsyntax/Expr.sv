grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax ;

nonterminal Expr with pp, errors, host<Expr>, inlined<Expr> ;
nonterminal Exprs with pp, errors, asList<Expr>, host<Exprs>, inlined<Exprs> ;

abstract production noneExprs
es::Exprs ::=
{ es.pp = "" ;
  es.errors := [ ] ;
  es.uses = [ ] ;
  es.host = noneExprs() ;
  es.inlined = noneExprs();
  es.asList = [ ] ;
}
abstract production oneExprs
es::Exprs ::= e::Expr
{ es.pp = e.pp ;
  es.host = oneExprs(e.host);
  forwards to consExprs(e,noneExprs()) ;
}
abstract production consExprs
es::Exprs ::= e::Expr rest::Exprs
{ es.pp = e.pp ++ 
          case rest of 
             noneExprs() -> ""
           | _ -> ", " ++ rest.pp 
          end ; 
  es.errors := e.errors ++ rest.errors ;
  es.uses = e.uses ++ rest.uses ;
  es.host = consExprs(e.host, rest.host);
  es.asList = [e] ++ rest.asList ;
  es.inlined = consExprs(e.inlined, rest.inlined);
}

abstract production varRefExprAll
e::Expr ::= id::ID
{ production attribute overloads::[Expr] with ++ ;
  overloads := [ ] ;
  production eres::EnvResult = lookup_name(id.lexeme, e.env) ;
  e.host = varRefExprAll(id);

  forwards to if   null(overloads)
              then varRefExpr(id)
              else head(overloads) ;
  e.errors := if   length(overloads) > 1
              then [ mkError ("Internal error.  More than one overloading " ++
                              "productions for identifier \"" ++ 
                              id.lexeme, mkLocID(id) ) ]
              else forward.errors ;

{- Does pattern matching not work on Strings?
  overloads <- case id.lexeme of
                 "_"      -> [ varRefExpr__(id) ]
               | "_last"  -> [ varRefExpr__last(id) ]
               | "_pid"   -> [ varRefExpr__pid(id) ]
               | "_nr_pr" -> [ varRefExpr__nr_pr(id) ]
               | "_np_"   -> [ varRefExpr_np_(id) ]
               | _        -> [ ] 
               end ;
 -}

  overloads <- if id.lexeme == "_"      then [ varRefExpr__(id) ]
          else if id.lexeme == "_last"  then [ varRefExpr__last(id) ]
          else if id.lexeme == "_pid"   then [ varRefExpr__pid(id) ]
          else if id.lexeme == "_nr_pr" then [ varRefExpr__nr_pr(id) ]
          else if id.lexeme == "_np_"   then [ varRefExpr_np_(id) ]
          else [ ] ;

  {- It would certainly be more efficient to create a separate
     terminal symbol for each of these predefined names.  The SPIN
     grammar does not do that.  And thus we've chosen to stick as
     closely to the SPIN grammar as possible.  -} 
}

abstract production varRefExpr
e::Expr ::= id::ID
{ e.pp = id.lexeme ; 
  e.errors := if eres.found then [ ] 
              else [ mkError ("Id \"" ++ id.lexeme ++ "\" not declared" ,
                              mkLocID(id) ) ] ;

  production eres::EnvResult = lookup_name(id.lexeme, e.env) ;
  e.uses = [ mkUse(eres.dcl.idNum, e) ];
  e.host = varRefExpr(id) ;
  -- e.inlined = ... see Inline.sv ...
}

abstract production varRefExpr__   --  "_"
e::Expr ::= id::ID
{ e.pp = id.lexeme ; 
  e.errors := [ ];
  e.host = varRefExpr__(id) ;
  e.inlined = varRefExpr__(id) ;
}
abstract production varRefExpr__last  -- "_last"
e::Expr ::= id::ID
{ e.pp = id.lexeme ; 
  e.errors := [ ];
  e.host = varRefExpr__last(id) ;
  e.inlined = varRefExpr__last(id) ;
}
abstract production varRefExpr__pid    -- "_pid"
e::Expr ::= id::ID
{ e.pp = id.lexeme ; 
  e.errors := [ ];
  e.host = varRefExpr__pid(id) ;
  e.inlined = varRefExpr__pid(id) ;
}
abstract production varRefExpr__nr_pr   -- "_nr_pr"
e::Expr ::= id::ID
{ e.pp = id.lexeme ; 
  e.errors := [ ];
  e.host = varRefExpr__nr_pr(id) ;
  e.inlined = varRefExpr__nr_pr(id) ;
}
abstract production varRefExpr_np_    -- "np_"
e::Expr ::= id::ID
{ e.pp = id.lexeme ; 
  e.errors := [ ];
  e.host = varRefExpr_np_(id) ;
  e.inlined = varRefExpr_np_(id) ;
}


abstract production constExpr
e::Expr ::= c::CONST
{ e.pp = c.lexeme ;
  e.errors := [ ] ;
  e.host = constExpr(c);
  e.inlined = constExpr(c);
  e.uses = [ ];
}

abstract production dotAccess
e::Expr ::= r::Expr f::ID
{ e.pp = r.pp ++ "." ++ f.lexeme ;
  e.errors := [ ] ;
  e.uses = r.uses ;
  e.host = dotAccess(r.host, f);
  e.inlined = dotAccess(r.inlined, f);
}

abstract production arrayAccess
e::Expr ::= a::Expr i::Expr
{ e.pp = a.pp ++ "[" ++ i.pp ++ "]" ; 
  e.errors := [ ] ;
  e.uses = a.uses ++ i.uses ;
  e.host = arrayAccess(a.host, i.host);
  e.inlined = arrayAccess(a.inlined, i.inlined);
}




-- Binary Operators        --
-----------------------------
abstract production genericBinOp
e::Expr ::= lhs::Expr op::Op rhs::Expr
{ e.pp = "(" ++ lhs.pp ++ " "++ op.pp ++ " " ++ rhs.pp ++ ")" ;
  e.errors := lhs.errors ++ rhs.errors;
  e.uses = lhs.uses ++ rhs.uses ;
  e.host = genericBinOp(lhs.host, op.host, rhs.host);
  e.inlined = genericBinOp(lhs.inlined, op.inlined, rhs.inlined);
}

nonterminal Op with pp, host<Op>, inlined<Op> ; 
abstract production mkOp
op::Op ::= n::String te::TypeExpr
{ op.pp = n;   
  op.host = mkOp(n, te.host) ;
  op.inlined = mkOp(n, te.inlined) ;
}


-- These can be specialized as need be.

-- Relational operators --
abstract production eqExpr
exp::Expr ::= lhs::Expr rhs::Expr
{ forwards to genericBinOp(lhs, mkOp("==",boolTypeExpr()), rhs) ; }
abstract production gteExpr
exp::Expr ::= lhs::Expr rhs::Expr
{ forwards to genericBinOp(lhs, mkOp(">=",boolTypeExpr()), rhs) ; }

-- Logical operators --
abstract production orExpr
exp::Expr ::= lhs::Expr rhs::Expr
{ forwards to genericBinOp(lhs, mkOp("||",boolTypeExpr()), rhs) ; }
abstract production andExpr
exp::Expr ::= lhs::Expr rhs::Expr
{ forwards to genericBinOp(lhs, mkOp("&&",boolTypeExpr()), rhs) ; }

-- Aritmetic operators --
abstract production minus
exp::Expr ::= lhs::Expr rhs::Expr
{ forwards to genericBinOp(lhs, mkOp("-",boolTypeExpr()), rhs) ; }

abstract production trueExpr
e::Expr ::= c::CONST
{ e.pp = c.lexeme ;
  e.errors := [ ] ;
  e.uses = [ ] ;
  e.host = trueExpr(c);
  e.inlined = trueExpr(c);
}

abstract production condExpr
e::Expr ::= c::Expr thenexp::Expr elseexp::Expr
{ e.pp = "(" ++ c.pp ++ "->" ++ thenexp.pp ++ ":" ++ elseexp.pp ++ ")";
  e.errors := c.errors ++ thenexp.errors ++ elseexp.errors;
  e.uses = c.uses ++ thenexp.uses ++ elseexp.uses ;
  e.host = condExpr(c.host, thenexp.host, elseexp.host) ; 
  e.inlined = condExpr(c.inlined, thenexp.inlined, elseexp.inlined) ; 
}

-- Send or Not
abstract production sndNotExpr
exp::Expr ::= lhs::Expr
{ exp.pp = "(!" ++ lhs.pp ++")" ;
  exp.errors := lhs.errors;
  exp.host = sndNotExpr(lhs.host);
  exp.inlined = sndNotExpr(lhs.inlined);
}

abstract production negExpr
exp::Expr ::= lhs::Expr
{ exp.pp = "(-" ++ lhs.pp ++")" ;
  exp.errors := lhs.errors;

  exp.uses = lhs.uses ; 
  exp.host = negExpr(lhs.host);
  exp.inlined = negExpr(lhs.inlined);
}

abstract production rcvExpr
exp::Expr ::= vref::Expr ra::RArgs
{ exp.pp = vref.pp ++ "?" ++ "[" ++ ra.pp ++ "]";
  exp.errors := vref.errors ++ ra.errors;
  exp.host = rcvExpr(vref.host, ra.host) ;
  exp.inlined = rcvExpr(vref.inlined, ra.inlined) ;
}

abstract production rrcvExpr
exp::Expr ::= vref::Expr ra::RArgs
{ exp.pp = vref.pp ++ "??" ++ "[" ++ ra.pp ++ "]";
  exp.errors := vref.errors ++ ra.errors;
  exp.host = rrcvExpr(vref.host, ra.host);
  exp.inlined = rrcvExpr(vref.inlined, ra.inlined);
}

abstract production run
exp::Expr ::= pn::ID args::Exprs p::Priority
{ exp.pp = "run " ++ pn.lexeme ++ "(" ++ args.pp ++ ")" ++ p.pp;

  production eres::EnvResult = lookup_name(pn.lexeme, exp.env) ;
  exp.errors := (if eres.found then [ ] 
                 else [ mkError ("Id \"" ++ pn.lexeme ++ "\" not declared", 
                                 mkLocID(pn) ) ] )
              ++ args.errors ;

  exp.uses = [ mkUse(eres.dcl.idNum, exp) ] ++ args.uses ;

  exp.host = run(pn, args.host, p.host);
  exp.inlined = run(pn, args.inlined, p.inlined);
}


abstract production exprChInit
exp::Expr ::= ci::ChInit
{ exp.pp = ci.pp;
  exp.errors := ci.errors;
  exp.host = exprChInit(ci.host) ;
  exp.inlined = exprChInit(ci.inlined) ;
  exp.uses = [ ] ;
}

nonterminal ChInit with pp, errors, host<ChInit>, inlined<ChInit> ;

abstract production chInit
ch::ChInit ::= c::CONST tl::TypeExprs
{ ch.pp = "[ " ++ c.lexeme ++ " ] of { " ++ tl.pp ++ " }";
  ch.errors := tl.errors;
  ch.host = chInit(c,tl.host);
  ch.inlined = chInit(c,tl.inlined);
}

-- Built in function --
abstract production lengthExpr
e::Expr ::= vref::Expr
{ e.pp = "len" ++ "(" ++ vref.pp ++ ")";
  e.errors := vref.errors;
  e.host = lengthExpr(vref.host);
  e.inlined = lengthExpr(vref.inlined);
}

abstract production enabledExpr
e::Expr ::= en::Expr
{ e.pp = "enabled" ++ "(" ++ en.pp ++ ")";
  e.errors := en.errors;
  e.host = enabledExpr(en.host) ;
  e.inlined = enabledExpr(en.inlined) ;
}

abstract production tildeExpr
e::Expr ::= lhs::Expr
{ e.pp = "(~" ++ lhs.pp ++ ")" ;
  e.errors := lhs.errors;
  e.host = tildeExpr(lhs.host);
  e.inlined = tildeExpr(lhs.inlined);
}

abstract production timeoutExpr
e::Expr ::=
{ e.pp = "timeout";
  e.errors := [];
  e.host = timeoutExpr() ;
  e.inlined = timeoutExpr() ;
}

abstract production noprogressExpr
e::Expr ::=
{ e.pp = "nonprogress";
  e.errors := [];
  e.host = noprogressExpr() ;
  e.inlined = noprogressExpr() ;
}
abstract production pcvalExpr
e::Expr ::= pc::Expr
{ e.pp = "pc_value" ++ "(" ++ pc.pp ++ ")";
  e.errors := pc.errors;
  e.host = pcvalExpr(pc.host);
  e.inlined = pcvalExpr(pc.inlined);
}

abstract production pnameExprIdExpr
e::Expr ::= pn::PNAME ex::Expr n::ID
{ e.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]" ++ "@" ++ n.lexeme; 
  e.errors := ex.errors;
  e.host = pnameExprIdExpr(pn, ex.host, n) ;
  e.inlined = pnameExprIdExpr(pn, ex.inlined, n) ;
}
abstract production pnameIdExpr
e::Expr ::= pn::PNAME id::ID
{ e.pp = pn.lexeme ++ "@" ++ id.lexeme ;
  e.errors := [];
  e.host = pnameIdExpr(pn, id);
  e.inlined = pnameIdExpr(pn, id);
}
abstract production pnameExprExpr
e::Expr ::= pn::PNAME ex::Expr pf::Expr
{ e.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]" ++ ":" ++ pf.pp;
  e.errors := ex.errors ++ pf.errors ;
  e.host = pnameExprExpr(pn, ex.host, pf.host);
  e.inlined = pnameExprExpr(pn, ex.inlined, pf.inlined);
}
abstract production pnameExpr
e::Expr ::= pn::PNAME pf::Expr
{ e.pp = pn.lexeme ++ ":" ++ pf.pp;
  e.errors := pf.errors ;
  e.host = pnameExpr(pn, pf.host);
  e.inlined = pnameExpr(pn, pf.inlined);
}


abstract production fullProbe
pr::Expr ::= vref::Expr
{ pr.pp = "full" ++ "(" ++ vref.pp ++ ")";
  pr.errors := vref.errors;
  pr.host = fullProbe(vref.host);
  pr.inlined = fullProbe(vref.inlined);
}

abstract production nfullProbe
pr::Expr ::= vref::Expr
{ pr.pp = "nfull" ++ "(" ++ vref.pp ++ ")";
  pr.errors := vref.errors;
  pr.host = nfullProbe(vref.host);
  pr.inlined = nfullProbe(vref.inlined);
}

abstract production emptyProbe
pr::Expr ::= vref::Expr
{ pr.pp = "empty" ++ "(" ++ vref.pp ++ ")";
  pr.errors := vref.errors;
  pr.host = emptyProbe(vref.host);
  pr.inlined = emptyProbe(vref.inlined);
}

abstract production nemptyProbe
pr::Expr ::= vref::Expr
{ pr.pp = "nempty" ++ "(" ++ vref.pp ++ ")";
  pr.errors := vref.errors;
  pr.host = nemptyProbe(vref.host);
  pr.inlined = nemptyProbe(vref.inlined);
}


