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

grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

nonterminal ForPre_c ; -- for_pre

synthesized attribute forTerminal::FOR ;

concrete production forPre_c
fp::ForPre_c ::= f::FOR '(' v::Varref_c 
{ }

nonterminal ForPost_c ;   -- for_post

concrete production forPost_c
fp::ForPost_c ::= '{' s::Sequence_c os::OS_c '}'
{ }
concrete production forRange_c
s::Special_c ::= fpre::ForPre_c ':' lower::Expr_c '..' upper::Expr_c ')' 
                 fpost::ForPost_c 
{ }
concrete production forIn_c
s::Special_c ::= fpre::ForPre_c 'in' v::Varref_c ')' fpost::ForPost_c 
{ }


concrete production select_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' lower::Expr_c '..' upper::Expr_c ')'
{ }


-- LTL formulas --
------------------

concrete productions
u::Unit_c ::= l::LTL_c (unit_ltl_c) { }

nonterminal LTL_c ;

terminal LTL_t  'ltl'    lexer classes {promela,promela_kwd};

parser attribute ltlMode :: Boolean 
     action { ltlMode = false ; } ;

concrete production ltl_formula_c
l::LTL_c ::= k::LTL_Kwd op::OptName2_c body::LTL_Body_c
{ } action { ltlMode = false ; }

nonterminal LTL_Body_c ; -- ltl_boby
concrete production ltl_body_c
l::LTL_Body_c ::= '{' fe::FullExpr_c os::OS_c '}'
{ }

-- The LTL_Kwd nonterminal exists here, and not in the SPIN grammar.
-- It is added so that an action can be performed after parsing the
-- 'ltl' terminal.  This is needed because Copper only allows parser
-- actions when the entire rule is reduced, not after part of the
-- right hand side has been parsed as is allowed in Yacc.

nonterminal LTL_Kwd ;  
concrete production ltlKwd_c
l::LTL_Kwd ::= 'ltl' { } action { ltlMode = true ; }

nonterminal OptName2_c ;
concrete productions
op::OptName2_c ::= id::ID (with_OptName2_c) { }
op::OptName2_c ::=        (without_OptName2_c) { }

concrete production expr_ltl_c
e::Expr_c ::= l::LTL_expr_c
{ e.pp = l.pp ; }

nonterminal LTL_expr_c ;

concrete productions
ltl::LTL_expr_c ::= l::Expr_c op::UNTIL_t r::Expr_c (until_c) { }
ltl::LTL_expr_c ::= l::Expr_c op::RELEASE_t r::Expr_c  (release_c) { }
ltl::LTL_expr_c ::= l::Expr_c op::WEAK_UNTIL_t r::Expr_c (weak_until_c) { }
ltl::LTL_expr_c ::= l::Expr_c op::IMPLIES_t r::Expr_c (implies_c) { } 
ltl::LTL_expr_c ::= l::Expr_c op::EQUIV_t r::Expr_c (equiv_c) { }
ltl::LTL_expr_c ::= op::NEXT_t r::Expr_c (next_c) precedence = 45 { }
ltl::LTL_expr_c ::= op::ALWAYS_t r::Expr_c (always_c) precedence = 45 { }
ltl::LTL_expr_c ::= op::EVENTUALLY_t r::Expr_c (eventually_c) precedence = 45 { }


-- ToDo:  these are probably handled well by context aware scanning.
terminal IMPLIES_t     'implies'    
  lexer classes {promela,promela_kwd}, precedence = 4,association = left;
terminal EQUIV_t       'equivalent'    
  lexer classes {promela,promela_kwd}, precedence = 4,association = left;
terminal EVENTUALLY_t  'eventually'    
  lexer classes {promela,promela_kwd}, precedence = 8,association = left;
terminal ALWAYS_t      'always'    
  lexer classes {promela,promela_kwd}, precedence = 8,association = left;

terminal UNTIL_t /U|(until)|(stronguntil)/  -- lexer classes {promela,promela_kwd},
                                               precedence = 9,association = left;
terminal WEAK_UNTIL_t /W|(weakuntil)/       -- lexer classes {promela,promela_kwd},
                                               precedence = 9,association = left;
terminal RELEASE_t /V|(release)/           --  lexer classes {promela,promela_kwd},
                                               precedence = 9,association = left;
terminal NEXT_t /X|(next)/                  -- lexer classes {promela,promela_kwd},
                                               precedence = 10,association = right;

-- ToDo: verity that we are we picking the corrects ones here.
disambiguate UNTIL_t, UNAME
 { pluck if listContains(lexeme,unames) then UNAME else UNTIL_t ; }
disambiguate WEAK_UNTIL_t, UNAME
 { pluck if listContains(lexeme,unames) then UNAME else WEAK_UNTIL_t ; }
disambiguate RELEASE_t, UNAME
 { pluck if listContains(lexeme,unames) then UNAME else RELEASE_t ; }
disambiguate NEXT_t, UNAME
 { pluck if listContains(lexeme,unames) then UNAME else NEXT_t ; }
disambiguate NEXT_t, PNAME, ID
 { pluck if listContains(lexeme,pnames) then PNAME else NEXT_t ; }
disambiguate NEXT_t, PNAME, INAME, ID
 { pluck if listContains(lexeme,pnames) then PNAME else NEXT_t ; }
disambiguate NEXT_t, PNAME, INAME, UNAME, ID
 { pluck if listContains(lexeme,pnames) then PNAME else NEXT_t ; }
