grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

synthesized attribute errors::[String];
attribute errors occurs on Program,Units,Unit,Body,
                           Stmt,Expr,Args,VrefList,Arg,RArg,RArgs,
                           MArgs,Options,IDList,Ccode,VarList,ChInit,Probe,Cexpr,Cstate;
attribute defs occurs on Program,Unit,Body,Stmt,Args,ChInit,Units,Expr,Options;

attribute env occurs on Expr,ChInit,Probe,Cexpr,Stmt,Unit,Body,Units,Options,MArgs,Arg,RArgs,RArg,Args,VrefList;

attribute typerep occurs on ProcType;

aspect production empty_args
a::Args ::=
{
 a.errors = [];
}

aspect production one_args
a::Args ::= a1::Arg
{
 a.errors = a1.errors;
 a1.env = a.env;
}

aspect production one_margs
ma::MArgs ::= a::Arg
{
 ma.errors = a.errors;
 a.env = ma.env; 
}

aspect production expr_margs
ma::MArgs ::= exp::Expr a::Arg
{
 ma.errors = exp.errors ++ a.errors;
 exp.env = ma.env;
 a.env = ma.env;
}

aspect production arg_expr
a1::Arg ::= exp::Expr
{
 a1.errors = exp.errors;
 exp.env = a1.env;
}

aspect production expr_args
a1::Arg ::= exp::Expr a2::Arg
{
 a1.errors = exp.errors ++ a2.errors;
 exp.env = a1.env;
 a2.env = a1.env;
}

aspect production one_rargs
ras::RArgs ::= ra::RArg
{
 ras.errors = ra.errors ++ ras2.errors;
 ra.env = ras.env;
 ras2.env = ras.env;
}

aspect production cons_args
ras::RArgs ::= ra::RArg ras2::RArgs
{
 ras.errors = ra.errors ++ ras2.errors;
 ra.env = ras.env;
 ras2.env = ras.env;
}

aspect production cons_rpargs
ras1::RArgs ::= ra::RArg ras2::RArgs
{
 ras1.errors = ra.errors ++ ras2.errors;
 ra.env = ras1.env;
 ras2.env = ras1.env;
}

aspect production paren_args
  ras1::RArgs ::= ras2::RArgs
{
 ras1.errors = ras2.errors;
 ras2.env = ras1.env;
}

aspect production var_rarg
ra::RArg ::= vr::Expr
{
 ra.errors = vr.errors;
 vr.env = ra.env;
}

aspect production eval_expr
ra::RArg ::= exp::Expr
{
 ra.errors = exp.errors;
 exp.env = ra.env;
}

aspect production const_rarg
ra::RArg ::= cst::CONST
{
 ra.errors = [];
}

aspect production neg_const
  ra::RArg ::= cst::CONST
{
 ra.errors = [];
}

aspect production abs_varlist2dcl
vl::VarList ::= vd::VarDcl
{
 vl.errors = vd.errors;
}

function unify_strings
[String] ::= str1::String str2::String
{
  return if str1 == str2
         then []
         else ["Error : " ++ str1 ++ " does not unify with " ++ str2 ];



}

function adjustArgs
String ::= str::String
{
  return " chan [" ++ str ++ "]"  ++ " " ++ toString(i1) ++ " " ++ toString(i1);

  local attribute i1::Integer;
  
  i1 = countOccurences("/*",str);
  
 -- local attribute i2::Integer;
  
--  i2 = countOccurences("*/",str);
}

function countOccurences
Integer ::= str1::String str2::String
{
  return if indexof(str1,str2)== -1
         then 0
         else 1 + countOccurences(str1,str3);

  local attribute str3::String;
  str3 = getString(str1,str2);
--substring(indexof(str1,str2),length(str2),str2);

}

function getString
String ::= str1::String str2::String
{
  return
  if (indexof(str1,str2)== -1)
  then ""
  else substring(indexof(str1,str2)+1,length(str2),str2);

}

   
   