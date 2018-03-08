grammar edu:umn:cs:melt:ableP:extensions:tables;

imports edu:umn:cs:melt:ableP:host:core ;
imports edu:umn:cs:melt:ableP:host:extensions ;

--Sample Table
--  c4 = table
--         c1 : T F
--         c2 : F *
--         c3 : T T 
--       end;

-- Concrete Syntax --
---------------------     
nonterminal ExprRows_c with pp, ppi, ast<ExprRows> ;
nonterminal ExprRow_c with pp, ppi, ast<ExprRow> ;
nonterminal TruthValueList_c with pp, ppi, ast<TruthValueList> ;

terminal TABLE     'tbl' lexer classes { promela,promela_kwd};
terminal END       'lbt' lexer classes { promela,promela_kwd};
terminal TrueTV_t  'T'   lexer classes { promela,promela_kwd};
terminal FalseTV_t 'F'   lexer classes { promela,promela_kwd};

{-
terminal BadInfix    '%+%'  lexer classes {promela},
                            precedence = 30,association = left;
concrete production infix_c
exp::Expr_c ::= e1::Expr_c op::BadInfix e2::Expr_c 
{ }
-}

--concrete syntax
concrete production table_c
exp::Expr_c ::= tbl1::TABLE erows::ExprRows_c e::END
{ exp.pp = " table\n" ++ erows.pp ++ "\n" ++ "     " ++ "  end";
  erows.ppi = "         ";
  exp.ast = table(erows.ast);
}


concrete production exprRowsCons_c
ers1::ExprRows_c ::= ers2::ExprRows_c erow::ExprRow_c
{ ers1.pp = ers2.pp ++ "\n" ++ erow.pp;
  ers1.ast = exprRowsCons(ers2.ast,erow.ast);
  erow.ppi = ers1.ppi;
  ers2.ppi = ers1.ppi;
}

concrete production exprRowOne_c
ers::ExprRows_c ::= erow::ExprRow_c
{ ers.pp = erow.pp;  erow.ppi = ers.ppi;
  ers.ast = exprRowOne(erow.ast);
}

concrete production exprRow_c
erow::ExprRow_c ::= e::Expr_c c::SCOLON tvl::TruthValueList_c
{ erow.pp = erow.ppi ++ e.pp ++ ":" ++ tvl.pp;
  erow.ast = exprRow(e.ast, tvl.ast);
}
 
concrete production tvlistsCons_c
tvl::TruthValueList_c ::= tv::TruthValue tvltail::TruthValueList_c
{ tvl.pp = tv.pp ++ " " ++ tvltail.pp;
  tvl.ast = tvlistsCons(tv, tvltail.ast);
}


concrete production tvlistOne_c
tvl::TruthValueList_c ::= tv::TruthValue
{ tvl.pp = tv.pp;
  tvl.ast = tvlistOne(tv);
}

concrete production tvTrue
tv::TruthValue ::= truetv::TrueTV_t
{ tv.pp = "T";
  tv.fexpr = tv.rowexpr;
  tv.lineno = truetv.line;
}

concrete production tvFalse
tv::TruthValue ::= falsetv::FalseTV_t
{ tv.pp = "F";
  tv.fexpr = sndNotExpr(tv.rowexpr);
  tv.lineno = falsetv.line;
}

concrete production tvStar
tv::TruthValue ::= startv::STAR
{ tv.pp = "*";
  tv.fexpr = trueExpr(terminal(CONST,"true")) ;
  tv.lineno = startv.line;
}




-- Abstract Syntax --
---------------------     
nonterminal ExprRows with pp, ppi, rlen, exprss, errors, lineno, env ;
nonterminal ExprRow with pp, ppi, rlen, exprs, errors, lineno, env ;
nonterminal TruthValueList with pp, rlen, rowexpr, exprs, lineno ;
nonterminal TruthValue with pp, rowexpr, fexpr, lineno ;

synthesized attribute rlen::Integer;
synthesized attribute fexpr::Expr;
inherited attribute rowexpr::Expr;
synthesized attribute exprss::[[Expr]];
synthesized attribute exprs::[Expr];
synthesized attribute lineno::Integer ;

abstract production table
exp::Expr ::= erows::ExprRows
{ exp.errors := erows.errors;

--  exp.is_var_ref = false;
--  erows.env = exp.env;
--  exp.typerep = boolean_type();

  forwards to resultExpr ; 
  local resultExpr::Expr
    = if !null(erows.errors)
      then trueExpr(terminal(CONST,"true"))
      else disjunction(mapConjunction(transpose(erows.exprss)));
}

abstract production exprRowsCons
ers1::ExprRows ::= ers2::ExprRows erow::ExprRow
{ ers1.rlen = erow.rlen;
  ers1.exprss = ers2.exprss ++ [erow.exprs];
  ers1.lineno = ers2.lineno;
 
--  erow.env = ers1.env;
--  ers2.env = ers1.env;

  ers1.errors := ers2.errors ++ erow.errors ++
                 if erow.rlen == ers2.rlen 
                 then [ ]
                 else [mkErrorNoLoc (
                        "Error: On line no " ++ toString(erow.lineno) ++
                        " The number of T,F,* entries in table row \n" ++
                        erow.pp ++ "  must be the same as the preceding rows" ) ];
}


abstract production exprRowOne
ers::ExprRows ::= er::ExprRow
{ ers.rlen = er.rlen;
  ers.exprss = [er.exprs];
  ers.lineno = er.lineno;
--  er.env = ers.env;
  ers.errors := er.errors;
}

abstract production exprRow
er::ExprRow ::= e::Expr tvl::TruthValueList
{ er.pp = e.pp ++ " : " ++ tvl.pp;
  er.rlen = tvl.rlen;
  tvl.rowexpr = e;
  er.exprs = tvl.exprs; 
  er.lineno = tvl.lineno;
  er.errors := e.errors;
  -- ToDo - check that this is boolean
}

abstract production tvlistsCons
tvl::TruthValueList ::= tv::TruthValue tvltail::TruthValueList
{ tvl.pp = tv.pp ++ " " ++ tvltail.pp;
  tvl.rlen = 1 + tvltail.rlen;
  tv.rowexpr = tvl.rowexpr;

  tvltail.rowexpr = tvl.rowexpr;
  tvl.exprs = cons(tv.fexpr,tvltail.exprs);
 
  tvl.lineno = tv.lineno;
}


abstract production tvlistOne
tvl::TruthValueList ::= tv::TruthValue
{ tvl.pp = tv.pp;

  tv.rowexpr = tvl.rowexpr;
  tvl.rlen = 1;
  tvl.exprs = [ tv.fexpr ];

  tvl.lineno = tv.lineno;
}


-- utility functions

function disjunction 
Expr ::= es::[Expr]
{ return if  length(es) == 1
         then head(es)
         else orExpr(head(es),disjunction(tail(es)));
}

function mapConjunction
[Expr] ::= ess::[[Expr]]
{ return if   null(ess)
         then [ ] -- [::Expr]
         else cons ( conjunction( head(ess)),mapConjunction(tail(ess)));
}

function conjunction
Expr ::= es::[Expr]
{
  return if length(es) == 1
         then head(es)
         else andExpr(head(es),conjunction(tail(es)));
}

function mapOr
[Expr] ::= ess::[[Expr]]
{
  return if null(ess)
         then [ ] -- [ ::Expr]
         else cons ( disjunction(head(ess)),mapOr(tail(ess)));
}


function transpose
[[ a ]] ::= matrix::[[ a ]]
{
 return if length(matrix) == 1
        then mapWrap( row)
        else mapCons( row,
                           transpose(tail(matrix)));

 local row::[ a ] = head(matrix);
}

function mapWrap
[[ a ]] ::= l::[ a ]
{ return if null(l)
         then [ ] 
         else cons(cons(head(l),[ ]),  mapWrap(tail(l)));
}

function mapCons
[[ a ]] ::= row::[ a ] matrix::[[ a ]]
{ return if null(row)
         then [ ]
         else cons(cons(head(row),head(matrix)),mapCons(tail(row),tail(matrix)));

}




