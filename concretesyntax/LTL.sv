grammar edu:umn:cs:melt:ableP:concretesyntax ;

{- v6

concrete production unit_ltl_c
u::Unit_c ::= l::LTL_c
{ u.pp = l.pp ;
  u.ast_Unit = l.ast_Unit;  }
-}

{-
ltl	: LTL optname2		{ ltl_mode = 1; ltl_name = $2->sym->name; }
	  ltl_body		{ if ($4) ltl_list($2->sym->name, $4->sym->name);
			  ltl_mode = 0;
			}
	;

ltl_body: '{' full_expr OS '}' { $$ = ltl_to_string($2); }
	| error		{ $$ = NULL; }
	;


optname2 : /* empty */ { char tb[32]; static int nltl = 0;
			  memset(tb, 0, 32);
			  sprintf(tb, "ltl_%d", nltl++);
			  $$ = nn(ZN, NAME, ZN, ZN);
			  $$->sym = lookup(tb);
			}
	| NAME		{ $$ = $1; }
	;



ltl_expr: expr UNTIL expr	{ $$ = nn(ZN, UNTIL,   $1, $3); }
	| expr RELEASE expr	{ $$ = nn(ZN, RELEASE, $1, $3); }
	| expr WEAK_UNTIL expr	{ $$ = nn(ZN, ALWAYS, $1, ZN);
				  $$ = nn(ZN, OR, $$, nn(ZN, UNTIL, $1, $3));
				}
	| expr IMPLIES expr	{
				$$ = nn(ZN, '!', $1, ZN);
				$$ = nn(ZN, OR,  $$, $3);
				}
	| expr EQUIV expr	{ $$ = nn(ZN, EQUIV,   $1, $3); }
	| NEXT expr       %prec NEG { $$ = nn(ZN, NEXT,  $2, ZN); }
	| ALWAYS expr     %prec NEG { $$ = nn(ZN, ALWAYS,$2, ZN); }
	| EVENTUALLY expr %prec NEG { $$ = nn(ZN, EVENTUALLY, $2, ZN); }
	;

-}
