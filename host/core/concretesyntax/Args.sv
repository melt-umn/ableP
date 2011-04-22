grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

--Args
nonterminal Args_c with pp, ast<Exprs> ;  -- same as in v4.2.9 and v6

concrete production empty_args_c
args::Args_c ::= 
{ args.pp = "";
  args.ast = noneExprs();  }

concrete production one_args_c
args::Args_c ::= a::Exprs_c
{ args.pp = a.pp;
  args.ast = a.ast ;  }


--Exprs_c
nonterminal Exprs_c with pp, ast<Exprs> ;    -- same as v4.2.9 and v6

concrete production arg_expr_c
a::Exprs_c ::= exp::Expr_c
{ a.pp = exp.pp;
  a.ast = oneExprs(exp.ast) ;   }

concrete production expr_args_c
a1::Exprs_c ::= exp::Expr_c ',' a2::Exprs_c
{ a1.pp = exp.pp ++ " , " ++ a2.pp ;
  a1.ast = consExprs (exp.ast ,a2.ast) ;  }


--PrArgs
nonterminal PrArgs_c with pp, ast<Exprs> ;   -- same as v4.2.9 and v6

concrete production empty_prargs_c
pa::PrArgs_c ::=
{ pa.pp = "";
  pa.ast = noneExprs() ;  }

concrete production one_prargs_c
pa::PrArgs_c ::= ',' a::Exprs_c
{ pa.pp = "," ++ a.pp;
  pa.ast = a.ast ;  }

--MArgs
nonterminal MArgs_c with pp, ast<MArgs> ;      -- same as v4.2.9 and v6
synthesized attribute cst_MArgs_c::MArgs_c occurs on MArgs ;

concrete production one_margs_c
ma::MArgs_c ::= a::Exprs_c
{ ma.pp = a.pp;
  ma.ast = margsSeq(a.ast); }

concrete production expr_margs_c
ma::MArgs_c ::= exp::Expr_c '(' a::Exprs_c ')'
{ ma.pp = exp.pp ++ "(" ++ a.pp ++ ")";
  ma.ast = margsPattern( consExprs(exp.ast, a.ast) ) ;  }




--RArg
nonterminal RArg_c with pp, ast<RArg> ;    -- same as v4.2.9 and v6
synthesized attribute cst_RArg_c::RArg_c occurs on RArg ;

concrete production var_rarg_c
ra::RArg_c ::= vr::Varref_c
{ ra.pp = vr.pp;
  ra.ast = varRArg(vr.ast);   }

concrete production eval_expr_c
ra::RArg_c ::= ev::EVAL '(' exp::Expr_c ')'
{ ra.pp = "eval" ++ "(" ++ exp.pp ++ ")";
  ra.ast = evalRArg(exp.ast);  }

concrete production const_rarg_c
ra::RArg_c ::= cst::CONST
{ ra.pp = cst.lexeme;
  ra.ast = constRArg(cst);  }

concrete production neg_const_c
ra::RArg_c ::= '-' cst::CONST
precedence = 20
{ ra.pp = "-" ++ cst.lexeme;
  ra.ast = negConstRArg(cst);  }


--RArgs
nonterminal RArgs_c with pp, ast<RArgs>;      -- same as v4.2.9 and v6
synthesized attribute cst_RArgs_c::RArgs_c occurs on RArgs ;

concrete production one_rargs_c
ras::RArgs_c ::= ra::RArg_c
{ ras.pp = ra.pp;
  ras.ast = oneRArg(ra.ast);  }

concrete production cons_rargs_c
ras1::RArgs_c ::= ra::RArg_c ',' ras2::RArgs_c
{ ras1.pp = ra.pp ++ " , " ++ ras2.pp;
  ras1.ast = consRArg(ra.ast,ras2.ast);  }

concrete production cons_rpargs_c
ras1::RArgs_c ::= ra::RArg_c '(' ras2::RArgs_c ')'
{ ras1.pp = ra.pp ++ "(" ++ ras2.pp ++ ")";
  ras1.ast = consParenRArg(ra.ast, ras2.ast);    }

concrete production paren_rargs_c
ras1::RArgs_c ::= '(' ras2::RArgs_c ')'
{ ras1.pp = "(" ++ ras2.pp ++ ")";
  ras1.ast = ras2.ast ; }
