grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal TypeExpr with pp, errors, host<TypeExpr>, typerep ;

abstract production intTypeExpr
t::TypeExpr ::=
{ t.pp = "int";
  t.typerep = intTypeRep();
  t.errors := [ ];
  t.host = intTypeExpr();
}

abstract production mtypeTypeExpr
t::TypeExpr ::=
{ t.pp = "mtype";
  t.typerep = mtypeTypeRep();
  t.errors := [];
  t.host = mtypeTypeExpr();
}

abstract production chanTypeExpr
t::TypeExpr ::=
{ t.pp = "chan";
 t.typerep = chanTypeRep();
 t.errors := [ ];
 t.host = chanTypeExpr();
}

abstract production bitTypeExpr
t::TypeExpr ::=
{ t.pp = "bit";
  t.typerep = bitTypeRep();
  t.errors := [ ];
  t.host = bitTypeExpr() ;
}

abstract production boolTypeExpr
t::TypeExpr ::=
{ t.pp = "bool";
  t.typerep = boolTypeRep();
  t.errors := [ ];
  t.host = boolTypeExpr() ;
}

abstract production byteTypeExpr
t::TypeExpr ::=
{ t.pp = "byte";
  t.typerep = byteTypeRep();
  t.errors := [ ];
  t.host = byteTypeExpr() ;
}

abstract production shortTypeExpr
t::TypeExpr ::=
{ t.pp = "short";
  t.typerep = shortTypeRep();
  t.errors := [ ];
  t.host = shortTypeExpr() ;
}

abstract production pidTypeExpr
t::TypeExpr ::=
{ t.pp = "pid";
  t.typerep = pidTypeRep();
  t.errors := [ ];
  t.host = pidTypeExpr() ;
}

abstract production unsignedTypeExpr
t::TypeExpr ::=
{ t.pp = "unsigned";
  t.typerep = unsignedTypeRep();
  t.errors := [ ];
  t.host = unsignedTypeExpr();
}

nonterminal TypeExprs with pp, errors, host<TypeExprs> ;

abstract production oneTypeExpr
tes::TypeExprs::= te::TypeExpr
{ tes.pp = te.pp;
  tes.errors := te.errors;
  tes.host = oneTypeExpr(te.host) ;
}

abstract production consTypeExpr
tes::TypeExprs ::= te::TypeExpr rest::TypeExprs
{ tes.pp = te.pp ++ "," ++ rest.pp ;
  tes.errors := te.errors ++ rest.errors;
  tes.host = consTypeExpr(te.host, rest.host);
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



-}
