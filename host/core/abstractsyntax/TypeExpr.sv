grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

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
