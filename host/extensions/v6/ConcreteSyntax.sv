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

nonterminal ForPre_c ;

synthesized attribute forTerminal::FOR ;

concrete production forPre_c
fp::ForPre_c ::= f::FOR '(' v::Varref_c 
{ }

nonterminal ForPost_c ;

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

