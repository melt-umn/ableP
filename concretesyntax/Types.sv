grammar edu:umn:cs:melt:ableP:concretesyntax ;

--nonterminal Type_c with pp;

concrete production bitType_c
t::BaseType_c ::= 'bit'
{
  t.pp = "bit";
--  t.ast_Type = bitType();
--always commented out  t.typeexpr = bitType();
}

concrete production boolType_c
t::BaseType_c ::= 'bool'
{ t.pp = "bool";
-- t.ast_Type = boolType();
}

concrete production intType_c
t::BaseType_c ::= 'int'
{ t.pp = "int";
--  t.ast_Type = intType();
}

concrete production mtypeType_c
t::BaseType_c ::= 'mtype'
{ t.pp = "mtype";
--  t.ast_Type = mtypeType();
}

concrete production chanType_c
t::BaseType_c ::= 'chan'
{ t.pp = "chan";
--  t.ast_Type = chanType();
}

concrete production byteType_c
t::BaseType_c ::= 'byte'
{ t.pp = "byte";
--  t.ast_Type = byteType();
}

concrete production pidType_c
t::BaseType_c ::= 'pid'
{ t.pp = "pid";
--  t.ast_Type = pidType();
}

concrete production shortType_c
t::BaseType_c ::= 'short'
{ t.pp = "short";
--  t.ast_Type = shortType();
}

concrete production unsigned_c
t::BaseType_c ::= 'unsigned'
{ t.pp = "unsigned";
--  t.ast_Type = unsignedType();
}
