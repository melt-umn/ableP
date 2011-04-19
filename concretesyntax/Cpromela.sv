grammar edu:umn:cs:melt:ableP:concretesyntax;

import edu:umn:cs:melt:ableC:terminals 
 only pp with pp as ansi_c_pp ;

import edu:umn:cs:melt:ableC:concretesyntax 
 only Expr_c, DeclarationList_c, StmtList_c, Root_c, CompoundStatement_c 
 with Expr_c as Ansi_C_Expr,
      DeclarationList_c as Ansi_C_DeclarationList,
      StmtList_c as Ansi_C_StmtList,
      Root_c as Ansi_C_Root ;

-- Productions the embed C code into Promela, the 
-- following have promela nonterminals on the LHS 
-- of the production.
--------------------------------------------------
nonterminal C_Fcts_c with pp, ast<Unit> ;    -- same in v4.2.9 and v6
synthesized attribute cst_C_Fcts_c::C_Fcts_c occurs on Unit ;

concrete productions
st::C_Fcts_c ::= cc::Ccode_c   { st.pp = cc.pp; st.ast = cc.ast ; }
st::C_Fcts_c ::= cc::Cstate_c  { st.pp = cc.pp; st.ast = cc.ast ; }

-- Cstate_c (cstate in spin.y)
nonterminal Cstate_c with pp, ast<Unit> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_Cstate_c::Cstate_c occurs on Unit ;

-- ToDo, add proper abstract syntax for these.
concrete productions
cs::Cstate_c ::= ca::C_STATE str1::STRING str2::STRING
 { cs.pp  = ca.lexeme ++ " " ++ str1.lexeme ++ " " ++ str2.lexeme ;
   cs.ast = cStateTrack( ca.lexeme, str1.lexeme, str2.lexeme, "" ) ;  }
cs::Cstate_c ::= ct::C_TRACK str1::STRING str2::STRING
 { cs.pp  = ct.lexeme ++ " " ++ str1.lexeme ++ " " ++ str2.lexeme ;
   cs.ast = cStateTrack( ct.lexeme, str1.lexeme, str2.lexeme, "" ) ;  }
cs::Cstate_c ::= ca::C_STATE str1::STRING str2::STRING str3::STRING
 { cs.pp  = ca.lexeme ++ " " ++ str1.lexeme ++ " " ++ str2.lexeme ++ " " ++ str3.lexeme ;
   cs.ast = cStateTrack( ca.lexeme, str1.lexeme, str2.lexeme, str3.lexeme ) ;  }
cs::Cstate_c ::= ct::C_TRACK str1::STRING str2::STRING str3::STRING
 { cs.pp  = ct.lexeme ++ " " ++ str1.lexeme ++ " " ++ str2.lexeme ++ " " ++ str3.lexeme ;
   cs.ast = cStateTrack( ct.lexeme, str1.lexeme, str2.lexeme, str3.lexeme ) ;  }


-- Ccode_c, (ccode in spin.y)
nonterminal Ccode_c with pp, ast<Unit>, ast_Stmt ;    -- same as in v4.2.9 and v6
synthesized attribute ast_Stmt :: Stmt ;

concrete productions
c::Ccode_c ::= cmpd::C_CODE_nt_c  
  { c.pp = cmpd.pp; 
    c.ast = unitCcmpd(cmpd.ast); 
    c.ast_Stmt = stmtCode(cmpd.ast);
  }
c::Ccode_c ::= dcls::C_DECL_nt_c  
  { c.pp = dcls.pp;  
    c.ast = unitCdcls(dcls.ast); 
  }

-- Embedded C code                              --
--------------------------------------------------
-- Since we parse the embedded C code, we introduce new nonterminals
-- and terminals not found in the spin.y specification.  The new
-- nonterminals are named to keep this specifiation somewhat similar
-- to the original in spin.y.

-- In spin.y, C_CODE, C_DECL, and C_EXPR are terminals.  Here,
-- we create a terminal and nonterminal for each of these
-- For C_CODE, we create 
--   the terminal    C_CODE, which matches /c_code/
--   the nonterminal C_CODE_nt_c which derives strings such as
--       "c_code { int *x; int *y; }"
-- Similar terminals and nonterminals are created for C_DECL and C_EXPR.

nonterminal C_CODE_nt_c with pp, ast<Ccmpd> ;
nonterminal C_DECL_nt_c with pp, ast<Cdcls> ;
nonterminal C_EXPR_nt_c with pp, ast<Expr> ;

synthesized attribute cst_C_CODE_nt_c::C_CODE_nt_c occurs on Ccmpd ;
synthesized attribute cst_C_DECL_nt_c::C_DECL_nt_c occurs on Cdcls ;
synthesized attribute cst_C_EXPR_nt_c::C_EXPR_nt_c occurs on Expr ;

-- The following are introduced because the above two rules in spin.y
-- use the same prep_inline function that the inlining productions use
-- to read the code by some hand-coded method.  We can do better.

concrete productions
st::C_CODE_nt_c ::= kwd::C_CODE '{' cmpd::C_CmpdStmt '}'
 { st.pp  = kwd.lexeme ++ " { " ++ cmpd.pp ++ " } " ; 
   st.ast = cCmpd(kwd, cmpd.pp ) ; }
st::C_CODE_nt_c ::= kwd::C_CODE '[' ce::Ansi_C_Expr ']' '{' cmpd::C_CmpdStmt '}'
 { st.pp  = kwd.lexeme ++ " [ " ++ ce.ansi_c_pp ++ " ] { " ++ cmpd.pp ++ " } " ;
   st.ast = cExprCmpd(kwd, ce.ansi_c_pp, cmpd.pp) ;  }
st::C_DECL_nt_c ::= kwd::C_DECL '{' cd::Ansi_C_DeclarationList '}' 
 { st.pp  = kwd.lexeme ++ " { " ++ cd.ansi_c_pp ++ " } " ;
   st.ast = cDcls(kwd, cd.ansi_c_pp);  }


-- C ~almost~ compound statment                 --
--------------------------------------------------
-- This is CompoundStatement_c in ableC without the curly brackets.
nonterminal C_CmpdStmt with pp ; 

concrete productions
c::C_CmpdStmt ::= dcls::Ansi_C_DeclarationList stmt::Ansi_C_StmtList
 { c.pp = dcls.ansi_c_pp  ++ " " ++ stmt.ansi_c_pp ;  }
c::C_CmpdStmt ::= dcls::Ansi_C_DeclarationList
 { c.pp = dcls.ansi_c_pp ; }
c::C_CmpdStmt ::= stmt::Ansi_C_StmtList
 { c.pp = stmt.ansi_c_pp ; }
c::C_CmpdStmt ::=
 { c.pp = "" ; }


-- C code in Promela expressions --
-----------------------------------

concrete production c_expr_c
e::Expr_c ::= ce::Cexpr_c
{ e.pp = ce.pp;   e.ast = ce.ast ; }

-- Cexpr_c, (cexpr  in spin.y)
nonterminal Cexpr_c with pp, ast<Expr> ;    -- same as in v4.2.9 and v6

concrete production cexpr_expr_unit_c 
st::Cexpr_c ::= cc::C_EXPR_nt_c
{ st.pp = cc.pp;   st.ast = cc.ast ;  }

-- as above, the previous productions in spin.y use the prep_inline
-- function to read the C code using hand written code, so it is not
-- in the rules.  We have the following rules to do a better job.
concrete productions
ce::C_EXPR_nt_c ::= kwd::C_EXPR '{' e::Ansi_C_Expr  '}'
{ ce.pp  = kwd.lexeme ++ " { " ++ e.ansi_c_pp ++ " } " ;
  ce.ast = exprCExpr (kwd, e.ansi_c_pp) ;   }

ce::C_EXPR_nt_c ::= kwd::C_EXPR '{' cmpd::C_CmpdStmt  '}'
{ ce.pp  = kwd.lexeme ++ " { " ++ cmpd.pp ++ " } " ;
  ce.ast = exprCCmpd (kwd, cmpd.pp ) ;   }

ce::C_EXPR_nt_c ::= kwd::C_EXPR '[' e::Ansi_C_Expr ']' '{' cmpd::C_CmpdStmt '}'
{ ce.pp  = kwd.lexeme ++ " [ " ++ e.ansi_c_pp ++ " ] { " ++ cmpd.pp ++ " } " ;
  ce.ast = exprCExprCmpd (kwd, e.ansi_c_pp, cmpd.pp ) ;   }




--- To avoid useless production errors!         --
--------------------------------------------------
terminal BOGUS_C_ROOT_t '!!!!!!BOGUSCROOT' ;
concrete production bogus_C_Root
p::Program_c ::= t::BOGUS_C_ROOT_t cr::Ansi_C_Root
{ } -- p.pp = "BOGUS C ROOT" ; }

