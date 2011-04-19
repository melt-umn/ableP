grammar edu:umn:cs:melt:ableP:extensions:typeChecking ;

attribute typerep occurs on TypeExpr ;

aspect production intTypeExpr
t::TypeExpr ::=
{ t.typerep = intTypeRep();
}
aspect production mtypeTypeExpr
t::TypeExpr ::=
{ t.typerep = mtypeTypeRep();
}
aspect production chanTypeExpr
t::TypeExpr ::=
{ t.typerep = chanTypeRep();
}
aspect production bitTypeExpr
t::TypeExpr ::=
{ t.typerep = bitTypeRep();
}
aspect production boolTypeExpr
t::TypeExpr ::=
{ t.typerep = boolTypeRep();
}
aspect production byteTypeExpr
t::TypeExpr ::=
{ t.typerep = byteTypeRep();
}
aspect production shortTypeExpr
t::TypeExpr ::=
{ t.typerep = shortTypeRep();
}
aspect production pidTypeExpr
t::TypeExpr ::=
{ t.typerep = pidTypeRep();
}
aspect production unsignedTypeExpr
t::TypeExpr ::=
{ t.typerep = unsignedTypeRep();
}

