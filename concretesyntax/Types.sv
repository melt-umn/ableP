grammar edu:umn:cs:melt:ableP:concretesyntax ;

nonterminal BaseType_c with pp, ppi;   -- same as v4.2.9 and v6

concrete production bt_uname_c
bt::BaseType_c ::= un::UNAME   -- was Type_c on lhs
{ bt.pp = un.lexeme;
--  bt.ast_Type = named_type(un);
}

concrete production bt_type_c
bt::BaseType_c ::= t::Type_c   -- new 
{ bt.pp = t.pp;
}


nonterminal Type_c with pp;   -- is a terminal in spin.y, but has same effect

concrete production bitType_c
t::Type_c ::= 'bit'
{
  t.pp = "bit";
--  t.ast_Type = bitType();
--always commented out  t.typeexpr = bitType();
}

concrete production boolType_c
t::Type_c ::= 'bool'
{ t.pp = "bool";
-- t.ast_Type = boolType();
}

concrete production intType_c
t::Type_c ::= 'int'
{ t.pp = "int";
--  t.ast_Type = intType();
}

concrete production mtypeType_c
t::Type_c ::= 'mtype'
{ t.pp = "mtype";
--  t.ast_Type = mtypeType();
}

concrete production chanType_c
t::Type_c ::= 'chan'
{ t.pp = "chan";
--  t.ast_Type = chanType();
}

concrete production byteType_c
t::Type_c ::= 'byte'
{ t.pp = "byte";
--  t.ast_Type = byteType();
}

concrete production pidType_c
t::Type_c ::= 'pid'
{ t.pp = "pid";
--  t.ast_Type = pidType();
}

concrete production shortType_c
t::Type_c ::= 'short'
{ t.pp = "short";
--  t.ast_Type = shortType();
}

concrete production unsigned_c
t::Type_c ::= 'unsigned'
{ t.pp = "unsigned";
--  t.ast_Type = unsignedType();
}


--TypList
nonterminal  TypList_c with pp, ppi ;   --- same as v4.2.9 and v6

concrete production tl_basetype_c
tl::TypList_c ::= bt::BaseType_c
{ tl.pp = bt.pp;
--  tl.ast_TypList = tl_basetype(bt.ast_Type);
}


--comma seperated type list
concrete production tl_comma_c
tl::TypList_c ::= bt::BaseType_c ',' tyl::TypList_c
{ tl.pp = bt.pp ++ "," ++ tyl.pp;
--  tl.ast_TypList = tl_comma(bt.ast_Type,tyl.ast_TypList);
}


{- ALWAYS COMMENTED OUT
--concrete production bt_type_c
--bt::Type_c ::= ty::TYPE
-- {
-- bt.pp = ty.lexeme;
-- bt.ast_Type = promela_typeexpr(ty);
-- }
-}




{- Commenting this out on Feb 18 as it is useless. Why? We do something different
   with types and basetypes.... ???
concrete production type_base_type_c
t::Type_c ::= bt::Type_c  -- one of thse was basetype...
{ t.pp = bt.pp ;
-- t.ast_Type = bt.ast_Type ;
}
-}
