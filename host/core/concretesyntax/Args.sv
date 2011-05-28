grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

--Args
attribute pp, ast<Exprs> occurs on Args_c ;

aspect production empty_args_c
args::Args_c ::= 
{ args.pp = "";
  args.ast = noneExprs();  }

aspect production one_args_c
args::Args_c ::= a::Arg_c
{ args.pp = a.pp;
  args.ast = a.ast ;  }


--Arg_c
attribute pp, ast<Exprs> occurs on Arg_c ;

aspect production arg_expr_c
a::Arg_c ::= exp::Expr_c
{ a.pp = exp.pp;
  a.ast = oneExprs(exp.ast) ;   }

aspect production expr_args_c
a1::Arg_c ::= exp::Expr_c ',' a2::Arg_c
{ a1.pp = exp.pp ++ ", " ++ a2.pp ;
  a1.ast = consExprs (exp.ast ,a2.ast) ;  }


--PrArgs
attribute pp, ast<Exprs> occurs on PrArgs_c ;

aspect production empty_prargs_c
pa::PrArgs_c ::=
{ pa.pp = "";
  pa.ast = noneExprs() ;  }

aspect production one_prargs_c
pa::PrArgs_c ::= ',' a::Arg_c
{ pa.pp = ", " ++ a.pp;
  pa.ast = a.ast ;  }

--MArgs
attribute pp, ast<MArgs> occurs on MArgs_c ;

aspect production one_margs_c
ma::MArgs_c ::= a::Arg_c
{ ma.pp = a.pp;
  ma.ast = margsSeq(a.ast); }

aspect production expr_margs_c
ma::MArgs_c ::= exp::Expr_c '(' a::Arg_c ')'
{ ma.pp = exp.pp ++ "(" ++ a.pp ++ ")";
  ma.ast = margsPattern( consExprs(exp.ast, a.ast) ) ;  }


--RArg
attribute pp, ast<RArg> occurs on RArg_c ;

aspect production var_rarg_c
ra::RArg_c ::= vr::Varref_c
{ ra.pp = vr.pp;
  ra.ast = varRArg(vr.ast);   }

aspect production eval_expr_c
ra::RArg_c ::= ev::EVAL '(' exp::Expr_c ')'
{ ra.pp = "eval" ++ "(" ++ exp.pp ++ ")";
  ra.ast = evalRArg(exp.ast);  }

aspect production const_rarg_c
ra::RArg_c ::= cst::CONST
{ ra.pp = cst.lexeme;
  ra.ast = constRArg(cst);  }

aspect production neg_const_c
ra::RArg_c ::= '-' cst::CONST
{ ra.pp = "- " ++ cst.lexeme;
  ra.ast = negConstRArg(cst);  }


--RArgs
attribute pp, ast<RArgs> occurs on RArgs_c ;

aspect production one_rargs_c
ras::RArgs_c ::= ra::RArg_c
{ ras.pp = ra.pp;
  ras.ast = oneRArg(ra.ast);  }

aspect production cons_rargs_c
ras1::RArgs_c ::= ra::RArg_c ',' ras2::RArgs_c
{ ras1.pp = ra.pp ++ ", " ++ ras2.pp;
  ras1.ast = consRArg(ra.ast,ras2.ast);  }

aspect production cons_rpargs_c
ras1::RArgs_c ::= ra::RArg_c '(' ras2::RArgs_c ')'
{ ras1.pp = ra.pp ++ "(" ++ ras2.pp ++ ")";
  ras1.ast = consParenRArg(ra.ast, ras2.ast);    }

aspect production paren_rargs_c
ras1::RArgs_c ::= '(' ras2::RArgs_c ')'
{ ras1.pp = "(" ++ ras2.pp ++ ")";
  ras1.ast = ras2.ast ; }
