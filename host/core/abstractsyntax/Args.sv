grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

-- Message arguments for sending
nonterminal MArgs with pp, errors, host<MArgs>, inlined<MArgs> ;

-- ToDo: The following are the same.
abstract production margsSeq
ma::MArgs ::= es::Exprs
{ ma.pp = es.pp;
  ma.errors := es.errors ;
  ma.uses = es.uses ;
  ma.host = margsSeq(es.host) ;
  ma.inlined = margsSeq(es.inlined) ;
 -- ma.arg_list = a.arg_list ;
}

abstract production margsPattern
ma::MArgs ::= es::Exprs
{ ma.pp = es.pp;
  ma.errors := es.errors ;
  ma.uses = es.uses ;
  ma.host = margsPattern(es.host) ;
  ma.inlined = margsPattern(es.inlined) ;
 -- ma.arg_list = a.arg_list ;
}

-- Message arguments for receiving
nonterminal RArgs with pp, errors, host<RArgs>, inlined<RArgs> ;

abstract production oneRArg
ras::RArgs ::= ra::RArg
{ ras.pp = ra.pp;  
  ras.errors := ra.errors ; 
  ras.uses = ra.uses ;
  ras.host = oneRArg(ra.host) ; 
  ras.inlined = oneRArg(ra.inlined) ; 
}
abstract production consRArg
ras::RArgs ::= ra::RArg rest::RArgs
{ ras.pp = ra.pp ++ " , " ++ rest.pp;  
  ras.errors := ra.errors ++ rest.errors ;
  ras.uses = ra.uses ++ rest.uses ;
  ras.host = consRArg(ra.host, rest.host);  
  ras.inlined = consRArg(ra.inlined, rest.inlined);  
}
abstract production consParenRArg
ras::RArgs ::= ra::RArg rest::RArgs
{ ras.pp = ra.pp ++ "(" ++ rest.pp ++ ")";
  ras.errors := ra.errors ++ rest.errors ;
  ras.uses = ra.uses ++ rest.uses ;
  ras.host = consParenRArg(ra.host, rest.host); 
  ras.inlined = consParenRArg(ra.inlined, rest.inlined);  
}

nonterminal RArg with pp, errors, host<RArg>, inlined<RArg> ;

abstract production varRArg
ra::RArg ::= vr::Expr
{ ra.pp = vr.pp;
  ra.errors := vr.errors ;
  ra.uses = vr.uses ;
  ra.host = varRArg(vr.host);   
  ra.inlined = varRArg(vr.inlined);   
}
abstract production evalRArg
ra::RArg ::= exp::Expr
{ ra.pp = "eval" ++ "(" ++ exp.pp ++ ")";
  ra.errors := exp.errors ;
  ra.uses = exp.uses ;
  ra.host = evalRArg(exp.host);   
  ra.inlined = evalRArg(exp.inlined);   
}
abstract production constRArg
ra::RArg ::= cst::CONST
{ ra.pp = cst.lexeme;
  ra.errors := [ ];
  ra.uses = [ ] ;
  ra.host = constRArg(cst) ;
  ra.inlined = constRArg(cst) ;   
}
abstract production negConstRArg
ra::RArg ::= cst::CONST
{ ra.pp = "-" ++ cst.lexeme;
  ra.errors := [ ];
  ra.uses = [ ]  ;
  ra.host = negConstRArg(cst) ; 
  ra.inlined = negConstRArg(cst) ; 
}

nonterminal Args with pp;
-- Args_c maps to Exprs.
-- So the following and the above nonterminal are probably not needed.
{-
nonterminal Arg with pp, errors, ;


synthesized attribute arg_list :: [ Expr ] occurs on Arg, Args, MArgs ;

abstract production empty_args
a::Args ::=
{
 a.basepp = "";
 a.pp = "";
 a.arg_list = [ ] ;
}

abstract production one_args
a::Args ::= a1::Arg
{
 a.basepp = a1.basepp;
 a.pp = a1.pp;
 a.arg_list = a1.arg_list ;
}


abstract production expr_margs
ma::MArgs ::= exp::Expr a::Arg
{
 ma.basepp = exp.basepp ++ "(" ++ a.basepp ++ ")";
 ma.pp = exp.pp ++ "(" ++ a.pp ++ ")";
 ma.arg_list = [ exp ] ++ a.arg_list ;
}

abstract production arg_expr
a1::Arg ::= exp::Expr
{
 a1.basepp = exp.basepp;
 a1.pp = exp.pp;
 a1.arg_list = [ exp'' ] ;
}

abstract production expr_args
a1::Arg ::= exp::Expr a2::Arg
{
 a1.basepp = exp.basepp ++ " , " ++ a2.basepp;
 a1.pp = exp.pp ++ " , " ++ a2.pp;
 a1.arg_list = [ exp''] ++ a2.arg_list ;
}


-}
