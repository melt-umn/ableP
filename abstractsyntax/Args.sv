grammar edu:umn:cs:melt:ableP:abstractsyntax;

{-
nonterminal Arg with basepp,pp;
nonterminal RArg with basepp,pp;

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

abstract production one_margs
ma::MArgs ::= a::Arg
{
 ma.basepp = a.basepp;
 ma.pp = a.pp;
 ma.arg_list = a.arg_list ;
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

abstract production one_rargs
ras::RArgs ::= ra::RArg
{
 ras.basepp = ra.basepp;
 ras.pp = ra.pp;
}

abstract production cons_rargs
ras1::RArgs ::= ra::RArg ras2::RArgs
{
 ras1.basepp = ra.basepp ++ " , " ++ ras2.basepp;
 ras1.pp = ra.pp ++ " , " ++ ras2.pp;
}

abstract production cons_rpargs
ras1::RArgs ::= ra::RArg ras2::RArgs
{
  ras1.basepp = ra.basepp ++ "(" ++ ras2.basepp ++ ")";
  ras1.pp = ra.pp ++ "(" ++ ras2.pp ++ ")";
}

abstract production paren_rargs
ras1::RArgs ::= ras2::RArgs
{
  ras1.basepp = "(" ++ ras2.basepp ++ ")";
  ras1.pp = "(" ++ ras2.pp ++ ")";
}

abstract production var_rarg
ra::RArg ::= vr::Expr   -- was Varref
{
  ra.basepp = vr.basepp;
  ra.pp = vr.pp;
}

abstract production eval_expr
ra::RArg ::= exp::Expr
{
  ra.basepp = "eval" ++ "(" ++ exp.basepp ++ ")";
  ra.pp = "eval" ++ "(" ++ exp.pp ++ ")";
}

abstract production const_rarg
ra::RArg ::= cst::CONST
{
  ra.basepp = cst.lexeme;
  ra.pp = cst.lexeme;

}

abstract production neg_const
ra::RArg ::= cst::CONST
{
  ra.basepp = "-" ++ cst.lexeme;
  ra.pp = "-" ++ cst.lexeme;
}

-}
