grammar edu:umn:cs:melt:ableP:concretesyntax ;

{- In 4.2.9 a claim looked like the following:
  concrete production claim_c
  c::Claim_c ::= ck::CLAIM body::Body_c

In v6 claim prod has the right hand side: CLAIM  optname  body 
    -- 4.2.9 did not have the optname

so add  concrete production   ... CLAIM NAME body

Thus we don't need to the optname nonterminal introduced in v6 for the modified claim
production shown abouve.
   
optname : /* empty */	{ char tb[32];
			  memset(tb, 0, 32);
			  sprintf(tb, "never_%d", nclaims);
			  $$ = nn(ZN, NAME, ZN, ZN);
			  $$->sym = lookup(tb);
			}
	| NAME		{ $$ = $1; }
	;



for_pre : FOR '('				{ in_for = 1; }
	  varref			{ $$ = $4; }
	;

for_post: '{' sequence OS '}' ;




Special : for_pre ':' expr DOTDOT expr ')'	{
				  for_setup($1, $3, $5); in_for = 0;
				}
	  for_post			{ $$ = for_body($1, 1);
				}
	| for_pre IN varref ')'	{ $$ = for_index($1, $3); in_for = 0;
				}
	  for_post			{ $$ = for_body($5, 1);
				}
	| SELECT '(' varref ':' expr DOTDOT expr ')' {
				  $$ = sel_index($3, $5, $7);
				}


-- this is Expr_c ::= LTL...
expr	| ltl_expr		{ $$ = $1; }

-}


concrete production namedClaim_c    -- to get to v6 for Claim_c
c::Claim_c ::= ck::CLAIM id::ID body::Body_c
{ c.pp = "never " ++ id.lexeme ++ body.ppi ++ body.pp ;
  body.ppi = "  ";
}
