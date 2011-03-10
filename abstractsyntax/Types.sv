grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

abstract production intType
t::Type ::=
{
 t.pp = "int";
 t.basepp = "int";
 t.typerep = int_type();
 t.errors = [];
}

abstract production bitType
t::Type ::=
{
 t.pp = "bit";
 t.basepp = "bit";
 t.typerep = bit_type();
 t.errors = [];
}

abstract production boolType
t::Type ::=
{
 t.pp = "bool";
 t.basepp = "bool";
 t.typerep = boolean_type();
 t.errors = [];
}

abstract production byteType
t::Type ::=
{
 t.pp = "byte";
 t.basepp = "byte";
 t.typerep = byte_type();
 t.errors = [];
}

abstract production shortType
t::Type ::=
{
 t.pp = "short";
 t.basepp = "short";
 t.typerep = short_type();
 t.errors = [];
}

abstract production chanType
t::Type ::=
{
 t.pp = "chan";
 t.basepp = "chan";
 t.typerep = chan_type();
 t.errors = [];
}

abstract production pidType
t::Type ::=
{
 t.pp = "pid";
 t.basepp = "pid";
 t.typerep = pid_type();
 t.errors = [];
}

abstract production mtypeType
t::Type ::=
{
 t.pp = "mtype";
 t.basepp = "mtype";
 t.typerep = mtype_type();
 t.errors = [];
}

abstract production unsignedType
t::Type ::=
{
 t.pp = "unsigned";
 t.basepp = "unsigned";
 t.typerep = unsigned_type();
 t.errors = [];
}