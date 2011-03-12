grammar edu:umn:cs:melt:ableP:abstractsyntax ;

synthesized attribute host<a>::a ;

{-

How do we nicely generate the tree that is the host language-only AST?

We need some attribute that is defined only on the "host" productions.

Generic transformations are defined on all productions to be a sort of
no-op if nothing is specified.  We'd like the rewrite rule that is
passed down to somehow ensure that the transformed tree is taken from
the forwarded-to tree...

The rewrite rule can pattern match the tree to see if it is one of the designated host language productions.

 r.match =
  case r.tree_to_match of
      genericBinOp(_,_) -> false
   |  all other host prods ...
   |  _ -> true

 r.rewrite = forwards.transformed ;


-}
