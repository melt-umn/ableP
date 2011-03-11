grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal TypeExpr with pp, typerep, errors ;

abstract production intTypeExpr
t::TypeExpr ::=
{ t.pp = "int";
  t.typerep = intTypeRep();
  t.errors := [ ];
}


{-
nonterminal Type with pp, basepp, defs, env, errors, typerep ;
nonterminal TypList with pp, basepp, defs, env, errors  ;

abstract production promela_typeexpr
t::Type ::= str::String
{
  t.pp = str;
  t.basepp = str;
  t.typerep = tr;
  t.errors = [];

  local attribute tr :: TypeRep;
  tr =     if str == "bit"  then bit_type()
      else if str == "bool" then boolean_type()
      else if str == "byte" then byte_type()
      else if str == "int"  then int_type()
      else if str == "chan" then chan_type()
      else if str == "short" then short_type()
      else if str == "mtype" then mtype_type()
      else if str == "pid"   then pid_type()
      else if str == "unsigned" then unsigned_type()
      else error_type();

}

abstract production named_type
t::Type ::= un::UNAME
{
 t.pp = un.lexeme;
 t.basepp = un.lexeme;

 t.typerep = case res.typerep of
                error_type() ->  error ("ERROR In Type Lookup " ++ un.lexeme ++ " env is " ++ envDisplay(t.env.bindings) )
             |  _ -> res.typerep
            end ;

 local attribute res :: EnvResult ;
 res = lookup_name(un.lexeme, t.env) ;
 
 t.errors = case res.typerep of
              user_type(_) -> [ ]
            | _ -> mkError (un.line, un.column, "type " ++ un.lexeme ++ " not declared.")
            end ;
}

abstract production abs_bt_error
t::Type ::= er::Error
{
 t.basepp = er.basepp;
 t.pp = er.basepp;
 t.errors = [] ;  
}


abstract production tl_basetype
tl::TypList ::= bt::Type
{
 tl.basepp = bt.basepp;
 tl.pp = bt.pp;
 tl.errors = bt.errors;
}

abstract production tl_comma
tl::TypList ::= bt::Type tyl::TypList
{
 tl.basepp = bt.basepp ++ "," ++ tyl.basepp;
 tl.pp = bt.pp ++ "," ++ tyl.pp;
 tl.errors = bt.errors ++ tyl.errors;

}

-}

{-

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

-}
