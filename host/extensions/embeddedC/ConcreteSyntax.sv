{- 
The concrete syntax grammar for Promela in ableP is derived from the
Yacc grammar in the SPIN distribution.  Since SPIN is copyrighted by
Lucent Technologies and Bell Laboratories we do not distribute these
derivations under the GNU LGPL.  These files retain the original
licensing and copyright designations, given below:

/* Copyright (c) 1989-2003 by Lucent Technologies, Bell Laboratories.     */
/* All Rights Reserved.  This software is for educational purposes only.  */
/* No guarantee whatsoever is expressed or implied by the distribution of */
/* this code.  Permission is given to distribute this code provided that  */
/* this introductory message is not removed and no monies are exchanged.  */
/* Software written by Gerard J. Holzmann.  For tool documentation see:   */
/*             http://spinroot.com/                                       */
-}

grammar edu:umn:cs:melt:ableP:host:extensions:embeddedC;

concrete production unit_c_fcts_c
u::Unit_c ::= cf::C_Fcts_c
{ }
concrete production ccode_stmt_c
st::Statement_c ::= cc::Ccode_c
{ } 

-- Productions the embed C code into Promela, the 
-- following have promela nonterminals on the LHS 
-- of the production.
--------------------------------------------------
nonterminal C_Fcts_c  ;    -- same in v4.2.9 and v6

concrete productions
st::C_Fcts_c ::= cc::Ccode_c  ( p_Ccode_c )  { }
st::C_Fcts_c ::= cc::Cstate_c ( p_CState_c ) { } 

-- Cstate_c (cstate in spin.y)
nonterminal Cstate_c ;   -- same as in v4.2.9 and v6

concrete productions
cs::Cstate_c ::= ca::C_STATE str1::STRING str2::STRING  ( p_C_STATE_2 )
 { }
cs::Cstate_c ::= ct::C_TRACK str1::STRING str2::STRING  ( p_C_TRACK_2 )
 { }
cs::Cstate_c ::= ca::C_STATE str1::STRING str2::STRING str3::STRING  ( p_C_STATE_3 )
 { }
cs::Cstate_c ::= ct::C_TRACK str1::STRING str2::STRING str3::STRING  ( p_C_TRACK_3 )
 { }


-- Ccode_c, (ccode in spin.y)
nonterminal Ccode_c ;    -- modified to parse embedded C
                         -- new productions in MappingConcreteToAbstract.sv


-- C code in Promela expressions --
-----------------------------------
concrete production c_expr_c
e::Expr_c ::= ce::Cexpr_c
{ }

-- Cexpr_c, (cexpr  in spin.y)
nonterminal Cexpr_c ;    -- same as in v4.2.9 and v6

concrete production cexpr_expr_unit_c 
st::Cexpr_c ::= cc::C_EXPR_nt_c
{ }

