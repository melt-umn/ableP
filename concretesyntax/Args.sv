grammar edu:umn:cs:melt:ableP:concretesyntax;

--Args

nonterminal Args_c with pp;
--attribute ast_Args occurs on PrArgs_c;
--synthesized attribute ast_Arg::Arg occurs on Arg_c;
--synthesized attribute ast_MArgs::MArgs occurs on MArgs_c;
--synthesized attribute ast_RArgs::RArgs occurs on RArgs_c;
--synthesized attribute ast_RArg::RArg occurs on RArg_c;

concrete production empty_args_c
a::Args_c ::= 
{ a.pp = "";
-- a.ast_Args = empty_args();
}

concrete production one_args_c
a::Args_c ::= a1::Arg_c
{ a.pp = a1.pp;
-- a.ast_Args = one_args(a1.ast_Arg);
}

--PrArgs

nonterminal PrArgs_c with pp;

concrete production empty_prargs_c
pa::PrArgs_c ::=
{ pa.pp = "";
-- pa.ast_Args = empty_args(); 
}

concrete production one_prargs_c
pa::PrArgs_c ::= ',' a::Arg_c
{ pa.pp = "," ++ a.pp;
-- pa.ast_Args = one_args(a.ast_Arg);
}

--MArgs
nonterminal MArgs_c with pp;

concrete production one_margs_c
ma::MArgs_c ::= a::Arg_c
{ ma.pp = a.pp;
-- ma.ast_MArgs = one_margs(a.ast_Arg);
}


concrete production expr_margs_c
ma::MArgs_c ::= exp::Expr_c '(' a::Arg_c ')'
{ ma.pp = exp.pp ++ "(" ++ a.pp ++ ")";
-- ma.ast_MArgs = expr_margs(exp.ast_Expr,a.ast_Arg);
}


--Arg
nonterminal Arg_c with pp;

concrete production arg_expr_c
a::Arg_c ::= exp::Expr_c
{ a.pp = exp.pp;
-- a.ast_Arg = arg_expr(exp.ast_Expr);
}

concrete production expr_args_c
a1::Arg_c ::= exp::Expr_c ',' a2::Arg_c
{ a1.pp = exp.pp ++ " , " ++ a2.pp;
-- a1.ast_Arg = expr_args(exp.ast_Expr,a2.ast_Arg);
}

--RArgs

nonterminal RArgs_c with pp;

concrete production one_rargs_c
ras::RArgs_c ::= ra::RArg_c
{ ras.pp = ra.pp;
-- ras.ast_RArgs = one_rargs(ra.ast_RArg);
}

concrete production cons_rargs_c
ras1::RArgs_c ::= ra::RArg_c ',' ras2::RArgs_c
{ ras1.pp = ra.pp ++ " , " ++ ras2.pp;
-- ras1.ast_RArgs = cons_rargs(ra.ast_RArg,ras2.ast_RArgs);
}

concrete production cons_rpargs_c
ras1::RArgs_c ::= ra::RArg_c '(' ras2::RArgs_c ')'
{ ras1.pp = ra.pp ++ "(" ++ ras2.pp ++ ")";
-- ras1.ast_RArgs = cons_rpargs(ra.ast_RArg,ras2.ast_RArgs); 
}

concrete production paren_rargs_c
ras1::RArgs_c ::= '(' ras2::RArgs_c ')'
{ ras1.pp = "(" ++ ras2.pp ++ ")";
-- ras1.ast_RArgs = paren_rargs(ras2.ast_RArgs); 
}


--RArg
nonterminal RArg_c with pp ;

concrete production var_rarg_c
ra::RArg_c ::= vr::Varref_c
{ ra.pp = vr.pp;
-- ra.ast_RArg = var_rarg(vr.ast_Expr);
}

concrete production eval_expr_c
ra::RArg_c ::= ev::EVAL '(' exp::Expr_c ')'
{ ra.pp = "eval" ++ "(" ++ exp.pp ++ ")";
--  ra.ast_RArg = eval_expr(exp.ast_Expr);
}

concrete production const_rarg_c
ra::RArg_c ::= cst::CONST
{ ra.pp = cst.lexeme;
-- ra.ast_RArg = const_rarg(cst);
}

concrete production neg_const_c
ra::RArg_c ::= '-' cst::CONST
precedence = 20
{ ra.pp = "-" ++ cst.lexeme;
-- ra.ast_RArg = neg_const(cst);
}


