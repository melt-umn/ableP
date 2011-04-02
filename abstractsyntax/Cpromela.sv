grammar edu:umn:cs:melt:ableP:abstractsyntax;

abstract production unitCcmpd
u::Unit ::= cc::Ccmpd
{ u.pp = "\n" ++ cc.pp ;
  u.errors :=  [ ] ;
  u.defs = emptyDefs() ;
  u.uses = [ ] ;
  u.host = unitCcmpd(cc) ;
}

abstract production unitCdcls
u::Unit ::= cc::Cdcls
{ u.pp = "\n" ++ cc.pp ;
  u.errors :=  [ ] ;
  u.defs = emptyDefs() ;
  u.uses = [ ] ;
  u.host = unitCdcls(cc) ;
}

abstract production cStateTrack
u::Unit ::= kwd::String str1::String str2::String str3::String
{ u.pp = kwd ++ " " ++ str1 ++ " " ++ str2 ++ " " ++ str3 ;
  u.errors := [ ] ;
  u.defs = emptyDefs() ;
  u.uses = [ ] ;
  u.host = cStateTrack(kwd, str1, str2, str3) ;
}

nonterminal Ccmpd with pp, errors, host<Ccmpd> ;
nonterminal Cdcls with pp, errors, host<Cdcls> ;

abstract production cCmpd
cc::Ccmpd ::= kwd::C_CODE cmpd::String
{ cc.pp = kwd.lexeme ++ "{ " ++  cmpd ++ " }";
  cc.errors := [];
  cc.host = cCmpd(kwd,cmpd);
}

abstract production cExprCmpd
cc::Ccmpd ::= kwd::C_CODE expr::String cmpd::String
{ cc.pp = kwd.lexeme ++ " [ " ++ expr ++ " ] { " ++ cmpd ++ " } " ;
  cc.errors := [];
  cc.host = cExprCmpd(kwd,expr,cmpd);
}

abstract production cDcls
c::Cdcls ::= kwd::C_DECL dcl::String
{ c.pp = kwd.lexeme ++ " { " ++ dcl ++ " } " ;
  c.errors := [] ;
  c.host = cDcls(kwd,dcl);
}

{-

nonterminal CcodeTEMP with pp ;
abstract production cCodeTemp
cc::CcodeTEMP ::= s::String
{ cc.pp = s ;
  cc.errors := [ ];
  cc.host = cCodeTemp(s) ;
}


import edu:umn:cs:melt:ableC:terminals only pp with pp as c_pp;
import edu:umn:cs:melt:ableC:concretesyntax;


-- Productions the embed C code into Promela, the 
-- following have promela nonterminals on the LHS 
-- of the production.
--------------------------------------------------


abstract production stmt_ccode
st::Stmt ::= cc::Ccode
{
 st.basepp = cc.basepp;
 st.pp = cc.pp;
 st.errors = cc.errors;
 st.defs = emptyDefs(); 
}
  
abstract production expr_ccode
e::Expr ::= cs::Cexpr
{
 e.pp = "\n" ++ cs.pp;
 e.basepp = "\n" ++ cs.basepp;
 e.errors = cs.errors;

}

-- Embedded C code                              --
--------------------------------------------------

nonterminal Cstuff with pp, basepp,errors;

-- Ccode --
-----------

abstract production ccode_expr_code
cc::Ccode ::= kwd::C_CODE e::Cstuff code::Cstuff  -- C expression, C code
{ 
 cc.pp     = kwd.lexeme ++ " [ " ++ e.pp ++ " ] { " ++ code.pp ++ "}";
 cc.basepp = kwd.lexeme ++ " [ " ++ e.pp ++ " ] { " ++ code.pp ++ "}";

 cc.errors = [];
}

abstract production ccode_decl
cc::Ccode ::= kwd::C_DECL code::Cstuff -- C declarations
{
 cc.pp     = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
 cc.basepp = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
 cc.errors = [];
}

-- Cstate --
------------
abstract production cstate
cs::Cstate ::= str1::STRING str2::STRING
{
 cs.basepp = "c_state " ++ str1.lexeme ++ str2.lexeme;
 cs.pp = "c_state " ++ str1.lexeme ++ str2.lexeme;
 cs.errors = [];
}

abstract production ctrack
cs::Cstate ::= str1::STRING str2::STRING
{
 cs.basepp = "c_track " ++ str1.lexeme ++ str2.lexeme;
 cs.pp = "c_track " ++ str1.lexeme ++ str2.lexeme;
 cs.errors = [];
}

abstract production cs_string
cs::Cstate ::= str1::STRING str2::STRING str3::STRING
{
 cs.basepp = "c_state " ++ str1.lexeme ++ str2.lexeme ++ str3.lexeme;
 cs.pp = "c_state " ++ str1.lexeme ++ str2.lexeme ++ str3.lexeme;
 cs.errors = [];
}

abstract production ct_string
cs::Cstate ::= str1::STRING str2::STRING str3::STRING
{
 cs.basepp = "c_track " ++ str1.lexeme ++ str2.lexeme ++ str3.lexeme;
 cs.pp = "c_track " ++ str1.lexeme ++ str2.lexeme ++ str3.lexeme;
 cs.errors = [];
}

-- Cexpr --
-----------
abstract production cexpr_code
ce::Cexpr ::= kwd::C_EXPR code::Cstuff
{
 ce.pp = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
 ce.basepp = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
 ce.errors = [];
}

abstract production cexpr_expr_code
ce::Cexpr ::= kwd::C_EXPR e::Cstuff code::Cstuff
{
 ce.pp     = kwd.lexeme ++ " [ " ++ e.pp ++ " ] { " ++ code.pp ++ "}";
 ce.basepp = kwd.lexeme ++ " [ " ++ e.pp ++ " ] { " ++ code.pp ++ "}";
 ce.errors = [];
}

-- Cstuff 
-- generic nonterminal for all C constructs     --
--------------------------------------------------
abstract production cstuff
cs::Cstuff ::= text::String 
{
 cs.pp = text ;
 cs.basepp = text ;
 cs.errors = [];
 
}

-}
