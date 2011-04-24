grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

attribute pp, ppi, ast<TypeExpr> occurs on BaseType_c ;

aspect production bt_uname_c
bt::BaseType_c ::= un::UNAME
{ bt.pp = un.lexeme;  bt.ast = unameTypeExpr(un) ; }

aspect production bt_type_c
bt::BaseType_c ::= t::Type_c
{ bt.pp = t.pp; bt.ast = t.ast; }


attribute pp, ast<TypeExpr> occurs on Type_c ;

aspect production bitType_c
t::Type_c ::= 'bit'
{ t.pp = "bit";      t.ast = bitTypeExpr(); }

aspect production boolType_c
t::Type_c ::= 'bool'
{ t.pp = "bool";     t.ast = boolTypeExpr(); }

aspect production intType_c
t::Type_c ::= 'int'
{ t.pp = "int";      t.ast = intTypeExpr(); }

aspect production mtypeType_c
t::Type_c ::= 'mtype'
{ t.pp = "mtype";    t.ast = mtypeTypeExpr(); }

aspect production chanType_c
t::Type_c ::= 'chan'
{ t.pp = "chan";     t.ast = chanTypeExpr(); }

aspect production byteType_c
t::Type_c ::= 'byte'
{ t.pp = "byte";     t.ast = byteTypeExpr(); }

aspect production pidType_c
t::Type_c ::= 'pid'
{ t.pp = "pid";      t.ast = pidTypeExpr(); }

aspect production shortType_c
t::Type_c ::= 'short'
{ t.pp = "short";    t.ast = shortTypeExpr(); }

aspect production unsignedType_c
t::Type_c ::= 'unsigned' 
{ t.pp = "unsigned"; t.ast = unsignedTypeExpr(); }


--TypList
attribute pp, ppi, ast<TypeExprs> occurs on TypList_c ;

aspect production tl_basetype_c
tl::TypList_c ::= bt::BaseType_c
{ tl.pp = bt.pp; tl.ast = oneTypeExpr(bt.ast);  }


aspect production tl_comma_c
tl::TypList_c ::= bt::BaseType_c ',' tyl::TypList_c
{ tl.pp = bt.pp ++ ", " ++ tyl.pp ;
  tl.ast = consTypeExpr( bt.ast, tyl.ast); }

