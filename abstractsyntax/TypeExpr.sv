grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal TypeExpr with pp, errors, host<TypeExpr>, inlined<TypeExpr>, env ;

abstract production intTypeExpr
t::TypeExpr ::=
{ t.pp = "int";
  t.errors := [ ];
  t.host = intTypeExpr();
  t.inlined = intTypeExpr();
}

abstract production mtypeTypeExpr
t::TypeExpr ::=
{ t.pp = "mtype";
  t.errors := [];
  t.host = mtypeTypeExpr();
  t.inlined = mtypeTypeExpr();
}

abstract production chanTypeExpr
t::TypeExpr ::=
{ t.pp = "chan";
  t.errors := [ ];
  t.host = chanTypeExpr();
  t.inlined = chanTypeExpr();
}

abstract production bitTypeExpr
t::TypeExpr ::=
{ t.pp = "bit";
  t.errors := [ ];
  t.host = bitTypeExpr() ;
  t.inlined = bitTypeExpr() ;
}

abstract production boolTypeExpr
t::TypeExpr ::=
{ t.pp = "bool";
  t.errors := [ ];
  t.host = boolTypeExpr() ;
  t.inlined = boolTypeExpr() ;
}

abstract production byteTypeExpr
t::TypeExpr ::=
{ t.pp = "byte";
  t.errors := [ ];
  t.host = byteTypeExpr() ;
  t.inlined = byteTypeExpr() ;
}

abstract production shortTypeExpr
t::TypeExpr ::=
{ t.pp = "short";
  t.errors := [ ];
  t.host = shortTypeExpr() ;
  t.inlined = shortTypeExpr() ;
}

abstract production pidTypeExpr
t::TypeExpr ::=
{ t.pp = "pid";
  t.errors := [ ];
  t.host = pidTypeExpr() ;
  t.inlined = pidTypeExpr() ;
}

abstract production unsignedTypeExpr
t::TypeExpr ::=
{ t.pp = "unsigned";
  t.errors := [ ];
  t.host = unsignedTypeExpr();
  t.inlined = unsignedTypeExpr();
}

abstract production unameTypeExpr
t::TypeExpr ::= un::UNAME
{ t.pp = un.lexeme;

 production res::EnvResult = lookup_name(un.lexeme, t.env) ;
 t.errors := if res.found then [ ]
             else [ mkError ( "Type \"" ++ un.lexeme ++ "\" not declared, line " ++
                              toString(un.line) ++ ", column " ++ toString(un.column) ) ] ;

 t.host = unameTypeExpr(un) ;
 t.inlined = unameTypeExpr(un) ;
--  t.typerep = case res.typerep of
--                error_type() ->  error ("ERROR In Type Lookup " ++ un.lexeme ++
--                                        " env is " ++ envDisplay(t.env.bindings) )
--             |  _ -> res.typerep
--            end ;
}

nonterminal TypeExprs with pp, errors, host<TypeExprs>, inlined<TypeExprs> ;

abstract production oneTypeExpr
tes::TypeExprs::= te::TypeExpr
{ tes.pp = te.pp;
  tes.errors := te.errors;
  tes.host = oneTypeExpr(te.host) ;
  tes.inlined = oneTypeExpr(te.inlined) ;
}

abstract production consTypeExpr
tes::TypeExprs ::= te::TypeExpr rest::TypeExprs
{ tes.pp = te.pp ++ "," ++ rest.pp ;
  tes.errors := te.errors ++ rest.errors;
  tes.host = consTypeExpr(te.host, rest.host);
  tes.inlined = consTypeExpr(te.inlined, rest.inlined);
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


abstract production abs_bt_error
t::Type ::= er::Error
{
 t.basepp = er.basepp;
 t.pp = er.basepp;
 t.errors = [] ;  
}



-}
