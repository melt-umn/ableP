grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

{- This hand-coded attempt at translations does not work well with
forwarding.  This version does not do rewriting on productions that
forward.

 -}

-- Over specified occurrences. Note how we must write out each individually here
synthesized attribute transformed<a> :: a;

attribute transformed<Program>    occurs on Program ;
attribute transformed<Unit>       occurs on Unit ;
attribute transformed<Declarator> occurs on Declarator ;
attribute transformed<Decls>      occurs on Decls ;
attribute transformed<Stmt>       occurs on Stmt ;
attribute transformed<Options>    occurs on Options ;
attribute transformed<Expr>       occurs on Expr ;
attribute transformed<Exprs>      occurs on Exprs ;
attribute transformed<MArgs>      occurs on MArgs ;
attribute transformed<RArgs>      occurs on RArgs ;
attribute transformed<RArg>       occurs on RArg ;
attribute transformed<Vis>        occurs on Vis ;
attribute transformed<TypeExpr>   occurs on TypeExpr ;
attribute transformed<TypeExprs>  occurs on TypeExprs ;
attribute transformed<IDList>     occurs on IDList ;
attribute transformed<Op>         occurs on Op ;
attribute transformed<ChInit>     occurs on ChInit ;
attribute transformed<ProcType>   occurs on ProcType ;
attribute transformed<Inst>       occurs on Inst ;
attribute transformed<Priority>   occurs on Priority ;
attribute transformed<Enabler>    occurs on Enabler ;


-- this is because, well, how do you specify what specialized type otherwise?
-- BUT, if these occurrences were part of the nonterminal declaration it's okay
-- nonterminal Root with transformed<Root>

-- Unless we do this more intelligently, this whole thing is still necessary.

autocopy attribute rwrules_Program
  :: [ RewriteRule<Program Decorated Program> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Unit    
  :: [ RewriteRule<Unit Decorated Unit> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Decls
  :: [ RewriteRule<Decls Decorated Decls> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Declarator 
  :: [ RewriteRule<Declarator Decorated Declarator> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Stmt
  :: [ RewriteRule<Stmt Decorated Stmt> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Options
  :: [ RewriteRule<Options Decorated Options> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Expr
  :: [ RewriteRule<Expr Decorated Expr> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Exprs
  :: [ RewriteRule<Exprs Decorated Exprs> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_MArgs
  :: [ RewriteRule<MArgs Decorated MArgs> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_RArgs
  :: [ RewriteRule<RArgs Decorated RArgs> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_RArg
  :: [ RewriteRule<RArg Decorated RArg> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Vis
  :: [ RewriteRule<Vis Decorated Vis> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_TypeExpr
  :: [ RewriteRule<TypeExpr Decorated TypeExpr> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_TypeExprs
  :: [ RewriteRule<TypeExprs Decorated TypeExprs> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_IDList
  :: [ RewriteRule<IDList Decorated IDList> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Op
  :: [ RewriteRule<Op Decorated Op> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_ChInit
  :: [ RewriteRule<ChInit Decorated ChInit> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_ProcType
  :: [ RewriteRule<ProcType Decorated ProcType> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Inst
  :: [ RewriteRule<Inst Decorated Inst> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Priority
  :: [ RewriteRule<Priority Decorated Priority> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;

autocopy attribute rwrules_Enabler
  :: [ RewriteRule<Enabler Decorated Enabler> ]
  occurs on Program, Unit, Decls, Declarator, Stmt, Options, Expr, Exprs,
            MArgs, RArgs, RArg, Vis, TypeExpr, TypeExprs, IDList, Op, ChInit,
            ProcType, Inst, Priority, Enabler ;


-- RULE: decnt === Decorated nt -- we just don't currently permit that type,
-- So we have to write both...
nonterminal RewriteRule< nt  decnt > 
            with matched, rewrite<nt>, tree_to_match<decnt>;

synthesized attribute matched :: Boolean;
synthesized attribute rewrite<nt>  :: nt;
inherited attribute tree_to_match<decnt> :: decnt;


-- This function could be written no matter what, but to create any useful
-- RewriteRule productions, GADTs are necessary.
function applyARewriteRule
nt ::= rrs::[RewriteRule<nt decnt>]  tomatch::decnt  nomatch::nt
{
  local rr :: RewriteRule<nt decnt> = head(rrs);
  rr.tree_to_match = tomatch ;

  return if null(rrs) then nomatch
    else if rr.matched then rr.rewrite
    else applyARewriteRule( tail(rrs), tomatch, nomatch );

-- Should we consider applying the rewrite rules to what tomatch forwards to
-- if the match here fails?
-- Maybe write an alternative version?
}


{-

-- Root.sv
aspect production root
r::Root ::= e::Expr
{ r.transformed = applyARewriteRule(r.rwrules_Root, r, root(e.transformed));
}

-- Expr.sv
aspect production idRef
e::Expr ::= i::Id_t
{ e.transformed = applyARewriteRule(e.rwrules_Expr, e, e);
}

aspect production trueConst
e::Expr ::= b::True_t
{ e.transformed = applyARewriteRule(e.rwrules_Expr, e, e);
}

aspect production falseConst
e::Expr ::= b::False_t
{ e.transformed = applyARewriteRule(e.rwrules_Expr, e, e);
}

aspect production intConst
e::Expr ::= i::DecimalConstant_t
{ e.transformed = applyARewriteRule(e.rwrules_Expr, e, e);
}

aspect production add
e::Expr ::= l::Expr r::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                          add ( l.transformed, r.transformed ) ) ;
}

aspect production app
e::Expr ::= f::Expr a::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                          app ( f.transformed, a.transformed ) ) ;
}

aspect production abs
e::Expr ::= i::Id_t b::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                          abs ( i, b.transformed ) ) ;
}

aspect production cond
e::Expr ::= c::Expr th::Expr el::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
     cond ( c.transformed, th.transformed, el.transformed ) ) ;
}

aspect production tuple
e::Expr ::= e1::Expr e2::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                 tuple ( e1.transformed, e2.transformed ) ) ;
}

aspect production tuplefst
e::Expr ::= e1::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                                    tuplefst ( e1.transformed ) ) ;
}

aspect production tuplesnd
e::Expr ::= e1::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                                   tuplefst ( e1.transformed ) ) ;
}

aspect production cons_list
e::Expr ::= h::Expr t::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                 cons_list ( h.transformed, t.transformed ) ) ;
}

aspect production nil_list
e::Expr ::=
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                                                      nil_list ( ) ) ;
}

aspect production ref
e::Expr ::= re::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                                           ref ( re.transformed ) ) ;
}

aspect production deref
e::Expr ::= de::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                                           deref ( de.transformed ) ) ;
}

aspect production letrec
e::Expr ::= ds::Decls b::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                      letrec ( ds.transformed, b.transformed ) ) ;
}

aspect production decl
d::Decl ::= i::Id_t e::Expr
{ d.transformed = applyARewriteRule ( d.rwrules_Decl, d,
                                   decl ( i, e.transformed ) ) ;
}

aspect production decl_with_type
d::Decl ::= i::Id_t t::Type e::Expr
{ d.transformed = applyARewriteRule ( d.rwrules_Decl, d,
                 decl_with_type (i, t.transformed, e.transformed ) ) ;
}

aspect production declsOne
ds::Decls ::= d::Decl
{ ds.transformed = applyARewriteRule ( ds.rwrules_Decls, ds,
                                 declsOne ( d.transformed ) );
}

aspect production declsCons
ds::Decls ::= d::Decl rest::Decls
{ ds.transformed = applyARewriteRule ( ds.rwrules_Decls, ds,
                  declsCons ( d.transformed, rest.transformed ) ) ;
}

-- Function declarations - from abstractsyntax:FuncDecls.sv
aspect production declFunc
d::Decl ::= i::Id_t params::Ids e::Expr
{ d.transformed = applyARewriteRule ( d.rwrules_Decl, d,
                         declFunc (i, params, e.transformed ) ) ;
}

aspect production declFunc_with_type
d::Decl ::= i::Id_t params::Ids t::Type e::Expr
{ d.transformed = applyARewriteRule ( d.rwrules_Decl, d,
     declFunc_with_type (i, params, t.transformed, e.transformed ) ) ;
}

aspect production idsOne
ids::Ids ::= id::Id_t
{
}
aspect production idsCons
ids::Ids ::= id::Id_t rest::Ids
{
}

-- Arrays.sv
aspect production genArray
e::Expr ::= size::Integer init::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                                 genArray ( size, init.transformed ) ) ;
}

aspect production printArray
e::Expr ::= arr::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                             printArray ( arr.transformed ) ) ;
}

aspect production zipWith
e::Expr ::= f::Expr a1::Expr a2::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
    zipWith ( f.transformed, a1.transformed, a2.transformed ) ) ;
}

aspect production mapArray
e::Expr ::= f::Expr a::Expr
{ e.transformed = applyARewriteRule ( e.rwrules_Expr, e,
                       mapArray ( f.transformed, a.transformed ) ) ;
}

-}
