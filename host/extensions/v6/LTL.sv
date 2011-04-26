grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

-- Currently we do no processing of LTL formulas and do not define any
-- abstract syntax for it.

-- LTL formulas --
------------------
abstract production unitLTL
u::Unit ::= l::LTL_c
{ u.pp = l.pp ;
  u.errors := [ ] ;
  u.defs = emptyDefs() ;
  u.host = unitLTL(l) ;
  u.inlined = unitLTL(l) ;
}


-- Aspects on concrete syntax --
--------------------------------
aspect production unitLTL_c
u::Unit_c ::= l::LTL_c
{ u.pp = l.pp ; 
  u.ast = unitLTL ( l ) ;
}

attribute pp occurs on LTL_c ;

aspect production ltl_formula_c
l::LTL_c ::= lkwd::LTL_Kwd op::OptName2_c body::LTL_Body_c
{ l.pp = "ltl " ++ op.pp ++ body.pp ; }

attribute pp occurs on LTL_Body_c ;
aspect production ltl_body_c
l::LTL_Body_c ::= '{' fe::FullExpr_c os::OS_c '}'
{ l.pp = "{ " ++ fe.pp ++ os.pp ++ " }" ; }


attribute pp occurs on OptName2_c ;
aspect production with_OptName2_c
op::OptName2_c ::= id::ID { op.pp = id.lexeme; }
aspect production without_OptName2_c
op::OptName2_c ::= { op.pp = ""; }

attribute pp occurs on LTL_expr_c ;

aspect production until_c
ltl::LTL_expr_c ::= l::Expr_c op::UNTIL_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
aspect production release_c
ltl::LTL_expr_c ::= l::Expr_c op::RELEASE_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
aspect production weak_until_c
ltl::LTL_expr_c ::= l::Expr_c op::WEAK_UNTIL_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
aspect production implies_c
ltl::LTL_expr_c ::= l::Expr_c op::IMPLIES_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
aspect production equiv_c
ltl::LTL_expr_c ::= l::Expr_c op::EQUIV_t r::Expr_c 
{ ltl.pp = l.pp ++ op.lexeme ++ r.pp ; }
aspect production next_c
ltl::LTL_expr_c ::= op::NEXT_t r::Expr_c 
{ ltl.pp = op.lexeme ++ r.pp ; }
aspect production always_c
ltl::LTL_expr_c ::= op::ALWAYS_t r::Expr_c 
{ ltl.pp = op.lexeme ++ r.pp ; }
aspect production eventually_c
ltl::LTL_expr_c ::= op::EVENTUALLY_t r::Expr_c 
{ ltl.pp = op.lexeme ++ r.pp ; }
