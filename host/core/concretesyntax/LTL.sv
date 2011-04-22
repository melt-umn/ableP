grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

concrete production unit_ltl_c
u::Unit_c ::= l::LTL_c
{ u.pp = l.pp ;
--  u.ast_Unit = l.ast_Unit;
}

parser attribute ltlMode :: Boolean 
     action { ltlMode = false ; } ;

nonterminal LTL_c with pp ;
terminal LTL_t  'ltl'    lexer classes {promela,promela_kwd};

concrete production ltl_formula_c
l::LTL_c ::= lkwd::LTL_Kwd op::OptName2_c body::LTL_Body_c
{ l.pp = "ltl " ++ op.pp ++ body.pp ; }
action { ltlMode = false ; }

nonterminal LTL_Kwd ;
concrete production ltlKwd_c
l::LTL_Kwd ::= 'ltl' { }
action { ltlMode = true ; }

nonterminal LTL_Body_c with pp ;
concrete production ltl_body_c
l::LTL_Body_c ::= '{' fe::FullExpr_c os::OS_c '}'
{ l.pp = "{ " ++ fe.pp ++ os.pp ++ " }" ; }

nonterminal OptName2_c with pp ;
concrete production with_OptName2_c
op::OptName2_c ::= id::ID { op.pp = id.lexeme; }
concrete production without_OptName2_c
op::OptName2_c ::= { op.pp = ""; }


concrete production expr_ltl_c
e::Expr_c ::= l::LTL_expr_c
{ e.pp = l.pp ; }


{- v6

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


expr    : ltl_expr 
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

-- these are probably handled well by context aware scanning???!??


terminal IMPLIES_t  'implies'    lexer classes {promela,promela_kwd},
                                             precedence = 4,association = left;
terminal EQUIV_t  'equivalent'    lexer classes {promela,promela_kwd},
                                             precedence = 4,association = left;


terminal EVENTUALLY_t  'eventually'    lexer classes {promela,promela_kwd},
                                             precedence = 8,association = left;
terminal ALWAYS_t  'always'    lexer classes {promela,promela_kwd},
                                             precedence = 8,association = left;

terminal UNTIL_t  /U|(until)|(stronguntil)/ -- lexer classes {promela,promela_kwd},
                                             precedence = 9,association = left;
-- are we picking the right one here?  What does Spin do?
disambiguate UNTIL_t, UNAME
{ pluck if listContains(lexeme,unames) then UNAME else UNTIL_t ; }

terminal WEAK_UNTIL_t  /W|(weakuntil)/      -- lexer classes {promela,promela_kwd},
                                             precedence = 9,association = left;
disambiguate WEAK_UNTIL_t, UNAME
{ pluck if listContains(lexeme,unames) then UNAME else WEAK_UNTIL_t ; }

terminal RELEASE_t  /V|(release)/          --  lexer classes {promela,promela_kwd},
                                             precedence = 9,association = left;
disambiguate RELEASE_t, UNAME
{ pluck if listContains(lexeme,unames) then UNAME else RELEASE_t ; }

terminal NEXT_t  /X|(next)/    -- lexer classes {promela,promela_kwd},
                               precedence = 10,association = right;
disambiguate NEXT_t, UNAME
{ pluck if listContains(lexeme,unames) then UNAME else NEXT_t ; }

disambiguate NEXT_t, PNAME, ID
{ pluck if listContains(lexeme,pnames) then PNAME 
   else NEXT_t ; }

disambiguate NEXT_t, PNAME, INAME, ID
{ pluck if listContains(lexeme,pnames) then PNAME 
   else NEXT_t ; }

disambiguate NEXT_t, PNAME, INAME, UNAME, ID
{ pluck if listContains(lexeme,pnames) then PNAME 
   else NEXT_t ; }

nonterminal LTL_expr_c with pp ;

concrete production until_c
ltl::LTL_expr_c ::= l::Expr_c op::UNTIL_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
concrete production release_c
ltl::LTL_expr_c ::= l::Expr_c op::RELEASE_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
concrete production weak_until_c
ltl::LTL_expr_c ::= l::Expr_c op::WEAK_UNTIL_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
concrete production implies_c
ltl::LTL_expr_c ::= l::Expr_c op::IMPLIES_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
concrete production equiv_c
ltl::LTL_expr_c ::= l::Expr_c op::EQUIV_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }

concrete production next_c
ltl::LTL_expr_c ::= op::NEXT_t r::Expr_c 
precedence = 45
{ ltl.pp = op.lexeme ++ r.pp ; }

concrete production always_c
ltl::LTL_expr_c ::= op::ALWAYS_t r::Expr_c 
precedence = 45
{ ltl.pp = op.lexeme ++ r.pp ; }

concrete production eventually_c
ltl::LTL_expr_c ::= op::EVENTUALLY_t r::Expr_c 
precedence = 45
{ ltl.pp = op.lexeme ++ r.pp ; }

{-  -- this is Expr_c ::= LTL...
expr	| ltl_expr		{ $$ = $1; }
-}



