grammar edu:umn:cs:melt:ableP:extensions:typeChecking ;

attribute typerep occurs on Expr ;
attribute typereps occurs on Exprs ;
-- Expr
aspect production varRefExpr
e::Expr ::= id::ID
{ e.typerep = eres.dcl.typerep ; 
}
aspect production varRefExpr__   --  "_"
e::Expr ::= id::ID
{ e.typerep = intTypeRep() ; 
}
aspect production varRefExpr__last  -- "_last"
e::Expr ::= id::ID
{ e.typerep = pidTypeRep() ;
}
aspect production varRefExpr__pid    -- "_pid"
e::Expr ::= id::ID
{ e.typerep = pidTypeRep() ;
}
aspect production varRefExpr__nr_pr   -- "_nr_pr"
e::Expr ::= id::ID
{ e.typerep = intTypeRep() ; 
}
aspect production varRefExpr_np_    -- "np_"
e::Expr ::= id::ID
{ e.typerep = boolTypeRep() ; 
}
aspect production constExpr
e::Expr ::= c::CONST
{ e.typerep = intTypeRep() ; 
}
aspect production dotAccess
e::Expr ::= r::Expr f::ID
{
}
aspect production arrayAccess
e::Expr ::= a::Expr i::Expr
{
}
aspect production trueExpr
e::Expr ::= c::CONST
{ e.typerep = boolTypeRep() ; 
}
aspect production condExpr
e::Expr ::= c::Expr thenexp::Expr elseexp::Expr
{ e.typerep = thenexp.typerep; 
}
aspect production exprCExpr
exp::Expr ::= kwd::C_EXPR ce::String
{
}
aspect production exprCCmpd
exp::Expr ::= kwd::C_EXPR ce::String
{
}
aspect production exprCExprCmpd
exp::Expr ::= kwd::C_EXPR ce::String cp::String
{
}
aspect production negExpr
exp::Expr ::= lhs::Expr
{ exp.typerep = boolTypeRep(); 
}
aspect production rcvExpr
exp::Expr ::= vref::Expr ra::RArgs
{ exp.typerep = boolTypeRep();
}
aspect production rrcvExpr
exp::Expr ::= vref::Expr ra::RArgs
{ exp.typerep = boolTypeRep();
}
aspect production run
exp::Expr ::= pn::ID args::Exprs p::Priority
{ exp.typerep = eres.dcl.typerep ; 
  exp.errors <- if true -- wrong number of errors ToDo
                then [ mkError ( "Incorrect number of arguments to \"" ++ 
                                 exp.pp ++ "\"." ) ]
                else [ ] ;
}
aspect production exprChInit
exp::Expr ::= ci::ChInit
{ exp.typerep = chanTypeRep();
}

aspect production lengthExpr
exp::Expr ::= vref::Expr
{ exp.typerep = intTypeRep();
}
aspect production enabledExpr
exp::Expr ::= ex::Expr
{ exp.typerep = boolTypeRep();
}
aspect production tildeExpr
exp::Expr ::= lhs::Expr
{ exp.typerep = lhs.typerep;
}
aspect production timeoutExpr
e::Expr ::=
{ e.typerep = boolTypeRep();
}
aspect production noprogressExpr
e::Expr ::=
{ e.typerep = unsignedTypeRep();
}
aspect production pcvalExpr
e::Expr ::= pc::Expr
{ e.typerep = intTypeRep();
}
-- ToDo: Fix types on pname expressions
aspect production pnameExprIdExpr
e::Expr ::= pn::PNAME ex::Expr n::ID
{ e.typerep = intTypeRep();
}
aspect production pnameIdExpr
e::Expr ::= pn::PNAME id::ID
{ e.typerep = intTypeRep();
}
aspect production pnameExprExpr
e::Expr ::= pn::PNAME ex::Expr pf::Expr
{ e.typerep = intTypeRep() ;
}
aspect production pnameExpr
e::Expr ::= pn::PNAME pf::Expr
{ e.typerep = intTypeRep() ;
}
aspect production fullProbe
pr::Expr ::= vref::Expr
{ pr.typerep = boolTypeRep();
}
aspect production nfullProbe
pr::Expr ::= vref::Expr
{ pr.typerep = boolTypeRep();
}
aspect production emptyProbe
pr::Expr ::= vref::Expr
{ pr.typerep = boolTypeRep();
}
aspect production nemptyProbe
pr::Expr ::= vref::Expr
{ pr.typerep = boolTypeRep();
}





attribute typerep occurs on Op ;
aspect production mkOp
op::Op ::= n::String te::TypeExpr
{ op.typerep = te.typerep ;
}
aspect production genericBinOp
e::Expr ::= lhs::Expr op::Op rhs::Expr
{ e.typerep = op.typerep ;
}


aspect production noneExprs  es::Exprs ::=
{ es.typereps = [ ] ;  }
aspect production oneExprs   es::Exprs ::= e::Expr
{ es.typereps = [ e.typerep ] ; }
aspect production consExprs  es::Exprs ::= e::Expr rest::Exprs
{ es.typereps = [ e.typerep ] ++ rest.typereps ;  }

-- send or not expr....  
{-
aspect production sndNotExpr
exp::Expr ::= lhs::Expr
{ forwards to case lhs.typerep of
                boolTypeRep() -> notExpr(lhs)
              | _ -> sndExpr(lhs) end ;
}
abstract production sndExpr
exp::Expr ::= lhs::Expr
{ exp.pp = "(!" ++ lhs.pp ++ ")" ;
  exp.errors := lhs.errors;
  exp.typerep = lhs.typerep ;
  exp.uses = lhs.uses ; 
  exp.host = sndExpr(lhs.host);
}
abstract production notExpr
exp::Expr ::= ne::Expr
{ exp.pp = "(! " ++ ne.pp ++ ")" ;
  exp.errors := ne.errors ;
  exp.uses = ne.uses ;
  exp.host = notExpr(ne.host) ;
}
aspect production notExpr
exp::Expr ::= ne::Expr
{ exp.typerep = boolTypeRep() ; }

-}
