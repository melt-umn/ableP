grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

import edu:umn:cs:melt:ableC:terminals only pp with pp as c_pp;
import edu:umn:cs:melt:ableC:concretesyntax;

-- Productions the embed C code into Promela, the 
-- following have promela nonterminals on the LHS 
-- of the production.
--------------------------------------------------
abstract production unit_ccode
cf::Unit ::= cc::Ccode
{
  cf.basepp = "\n" ++ cc.basepp; 
  cf.pp = "\n" ++ cc.pp;
  cf.errors = cc.errors;
  cf.defs = emptyDefs(); 
}

abstract production unit_cstate
cf::Unit ::= cs::Cstate
{
  cf.basepp = "\n" ++ cs.basepp;
  cf.pp = "\n" ++ cs.pp;
  cf.errors = cs.errors;
  cf.defs = emptyDefs();
}

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
nonterminal Cstate with basepp,pp;
nonterminal Ccode with basepp,pp;
nonterminal Cexpr with basepp,pp;
nonterminal Cstuff with pp, basepp,errors;

-- Ccode --
-----------
abstract production ccode_code
cc::Ccode ::= kwd::C_CODE code::Cstuff   -- C code
{
 cc.pp     = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
 cc.basepp = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
 cc.errors = [];
}

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
