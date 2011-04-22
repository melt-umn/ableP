grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

{- 12/leader.pml, 14/v14_16.pml
   
for_pre : FOR '('			{ in_for = 1; }
	  varref			{ $$ = $4; }
	;

for_post: '{' sequence OS '}' ;

Special : for_pre ':' expr DOTDOT expr ')'	{ for_setup($1, $3, $5); in_for = 0;}
	  for_post			{ $$ = for_body($1, 1);	}
	| for_pre IN varref ')'	{ $$ = for_index($1, $3); in_for = 0;}
	  for_post			{ $$ = for_body($5, 1);	}
	| SELECT '(' varref ':' expr DOTDOT expr ')' {$$ = sel_index($3, $5, $7);}
-}

nonterminal ForPre_c with pp, ast<Expr>, forTerminal ;
synthesized attribute cst_ForPre_c :: ForPre_c occurs on Expr ;

synthesized attribute forTerminal::FOR ;

concrete production forPre_c
fp::ForPre_c ::= f::FOR '(' v::Varref_c 
{ fp.pp = "for (" ++ v.pp ; 
  fp.ast = v.ast ; 
  fp.forTerminal = f ;
}

nonterminal ForPost_c with pp, ast<Stmt> ;
synthesized attribute cst_ForPost_c :: ForPost_c occurs on Stmt ;

concrete production forPost_c
fp::ForPost_c ::= '{' s::Sequence_c os::OS_c '}'
{ fp.pp = "{ " ++ s.pp ++ os.pp ++ "}" ; 
  fp.ast = s.ast ;
}

concrete production forRange_c
s::Special_c ::= fpre::ForPre_c ':' lower::Expr_c '..' upper::Expr_c ')' 
                 fpost::ForPost_c 
{ s.pp = fpre.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ")" ++ fpost.pp ; 
  s.ast = forRange ( fpre.forTerminal, fpre.ast, lower.ast, upper.ast, fpost.ast ) ;
}

concrete production forIn_c
s::Special_c ::= fpre::ForPre_c 'in' v::Varref_c ')' fpost::ForPost_c 
{ s.pp = fpre.pp ++ " in " ++ v.pp ++ ")" ++ fpost.pp ; 
  s.ast = forIn(fpre.forTerminal, fpre.ast, v.ast, fpost.ast) ;
}


--terminal SELECT 'select'           lexer classes {promela,promela_kwd};
concrete production select_c
s::Special_c ::= sl::'select' '(' v::Varref_c ':' lower::Expr_c '..' upper::Expr_c ')'
{ s.pp = "select (" ++ v.pp ++ ": " ++ lower.pp ++ ".." ++ upper.pp ++ ")" ; 
  s.ast = select (sl, v.ast, lower.ast, upper.ast) ;
}


{-
 In 4.2.9 a claim looked like the following:
  concrete production claim_c
  c::Claim_c ::= ck::CLAIM body::Body_c

In v6 claim prod has the right hand side: CLAIM  optname  body 
    -- 4.2.9 did not have the optname

v6 adds the following.
optname : /* empty */	{ ... }
	| NAME		{ $$ = $1; }
	;

Thus we don't need to the optname nonterminal introduced in v6 for the
modified claim production shown abouve.

So we add the following production 

-}
concrete production namedClaim_c    -- to get to v6 for Claim_c
c::Claim_c ::= ck::CLAIM id::ID body::Body_c
{ c.pp = "never " ++ id.lexeme ++ body.ppi ++ body.pp ;
  body.ppi = "  ";
}
