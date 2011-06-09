grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;


-- The following adds a transformation to be run when generating the
-- 'host' program that rewrites any 'in' identifiers so that the
-- program is acceptable to SPIN which doesn't allow this.
aspect production programWithNewUnits
p::Program ::= u::Unit
{ transformations <- [ applyInRenameTransformation ] ;
}

function applyInRenameTransformation
Program ::= p::Program
{
 local lp::Program = p ;

 lp.rwrules_Program = [ ] ;
 lp.rwrules_Unit = [ ] ;
 lp.rwrules_Decls = [ ] ;
 lp.rwrules_Declarator = [ inRenameDeclarator() ] ;
 lp.rwrules_Stmt = [ ] ;
 lp.rwrules_Expr = [ inRenameExpr() ] ;
 lp.rwrules_Options = [ ] ;
 lp.rwrules_Exprs = [ ] ;
 lp.rwrules_MArgs = [ ] ;
 lp.rwrules_RArgs = [ ] ;
 lp.rwrules_RArg = [ ] ;
 lp.rwrules_Vis = [ ] ;
 lp.rwrules_TypeExpr = [ ] ;
 lp.rwrules_TypeExprs = [ ] ;
 lp.rwrules_IDList = [ ] ;
 lp.rwrules_Op = [ ] ;
 lp.rwrules_ChInit = [ ] ;
 lp.rwrules_ProcType = [ ] ;
 lp.rwrules_Inst = [ ] ;
 lp.rwrules_Priority = [ ] ;
 lp.rwrules_Enabler = [ ] ;


 return lp.transformed ;
}


abstract production inRenameDeclarator
r::RewriteRule<Declarator  Decorated Declarator> ::= 
{
 r.matched = pieces.isJust ;
 r.rewrite
   = case pieces of
                 just(d) -> new(d)
               | _ -> error ("accessing rewrite on failed match")
               end ;

 local attribute pieces::Maybe<Declarator> ;
 pieces = case r.tree_to_match of 
            vd_id(idx) 
            -> if idx.lexeme == "in"
               then just(  vd_id(inRenameID(idx)) ) else nothing()
          | vd_idconst(idx,c) 
            -> if idx.lexeme == "in"
               then just(  vd_idconst(inRenameID(idx),c) ) else nothing()
          | vd_array(idx,c) 
            -> if idx.lexeme == "in"
               then just(  vd_array(inRenameID(idx),c) ) else nothing()
          | _ -> nothing()
          end ;
}

abstract production inRenameExpr
r::RewriteRule<Expr Decorated Expr> ::= 
{
 r.matched = pieces.isJust ;
 r.rewrite
   = case pieces of
                 just(e) -> new(e)
               | _ -> error ("accessing rewrite on failed match")
               end ;

 local attribute pieces::Maybe<Expr> ;
 pieces = case r.tree_to_match of 
            varInRefExpr(idx, eres)
            -> just( varRefExpr( inRenameID(idx), eres ) )
          | varRefExpr(idx, eres)
            -> if   idx.lexeme == "in"
               then just( varRefExpr( 
                            terminal(ID, 
                                     if   eres.found 
                                     then eres.dcl.inRename
                                     else idx.lexeme, 
                                     idx.line, idx.column)  ,
                            eres ) )
               else nothing()
          | _ -> nothing()
          end ;
}


function inRenameID
ID ::= id::ID
{ return
    terminal( ID, id.lexeme ++ "_" ++ toString(id.line) ++
                               "_" ++ toString(id.column) ,
              id.line, id.column) ;
}

