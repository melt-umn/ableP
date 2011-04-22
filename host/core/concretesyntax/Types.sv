grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

nonterminal BaseType_c with pp, ppi, ast<TypeExpr> ;   -- same as v4.2.9 and v6

concrete production bt_uname_c
bt::BaseType_c ::= un::UNAME   -- was Type_c on lhs
{ 

} -- bt.ast = named_type(un); }

concrete production bt_type_c
bt::BaseType_c ::= t::Type_c   -- new 
{ bt.pp = t.pp; bt.ast = t.ast; }


nonterminal Type_c with pp, ast<TypeExpr> ; -- is a terminal in spin.y, but has same effect

concrete productions
t::Type_c ::= 'bit'  (bitType_c)
  { t.pp = "bit";      t.ast = bitTypeExpr(); }
t::Type_c ::= 'bool'  (boolType_c)
  { t.pp = "bool";     t.ast = boolTypeExpr(); }
t::Type_c ::= 'int'   (intType_c)
  { t.pp = "int";      t.ast = intTypeExpr(); }
t::Type_c ::= 'mtype' (mtypeType_c)
  { t.pp = "mtype";    t.ast = mtypeTypeExpr(); }
t::Type_c ::= 'chan' (chanType_c)
  { t.pp = "chan";     t.ast = chanTypeExpr(); }
t::Type_c ::= 'byte' (byteType_c)
  { t.pp = "byte";     t.ast = byteTypeExpr(); }
t::Type_c ::= 'pid'  (pidType_c)
  { t.pp = "pid";      t.ast = pidTypeExpr(); }
t::Type_c ::= 'short' (shortType_c)
  { t.pp = "short";    t.ast = shortTypeExpr(); }
t::Type_c ::= 'unsigned'  (unsignedType_c)
  { t.pp = "unsigned"; t.ast = unsignedTypeExpr(); }


--TypList
nonterminal TypList_c with pp, ppi, ast<TypeExprs> ;   --- same as v4.2.9 and v6

concrete production tl_basetype_c
tl::TypList_c ::= bt::BaseType_c
{ tl.pp = bt.pp; tl.ast = oneTypeExpr(bt.ast);  }


concrete production tl_comma_c
tl::TypList_c ::= bt::BaseType_c ',' tyl::TypList_c
{ tl.pp = bt.pp ++ ", " ++ tyl.pp ;
  tl.ast = consTypeExpr( bt.ast, tyl.ast); }




{- ToDo Commenting this out on Feb 18 as it is useless. Why? We do something different
   with types and basetypes.... ???
concrete production type_base_type_c
t::Type_c ::= bt::Type_c  -- one of thse was basetype...
{ t.pp = bt.pp ;
-- t.ast_Type = bt.ast_Type ;
}
-}
