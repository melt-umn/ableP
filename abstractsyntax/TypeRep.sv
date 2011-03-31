grammar edu:umn:cs:melt:ableP:abstractsyntax;

synthesized attribute typerep::TypeRep;

nonterminal TypeRep with tag, host<TypeRep> ;

synthesized attribute tag::String;
synthesized attribute isCompatible::Boolean;
attribute isCompatible occurs on TypeRep;
attribute pp occurs on TypeRep;

--synthesized attribute var_ref_p :: Production (Expr ::= ID TypeRep ) ;

abstract production intTypeRep
t::TypeRep ::=
{ t.pp = "int";
  t.host = intTypeRep();

  t.tag = "int";
  t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production mtypeTypeRep
t::TypeRep ::=
{ t.pp = "mtype";
  t.host = mtypeTypeRep();

  t.tag = "mtype";
  t.isCompatible = false;
  --t.var_ref_p = promela_bound_var_ref ;
}


--- below are not updated.

abstract production unsignedTypeRep
t::TypeRep ::=
{ t.pp = "unsigned";
  t.host = unsignedTypeRep();

  t.tag = "unsigned";
  t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production shortTypeRep
t::TypeRep ::=
{ t.pp = "short";
  t.host = shortTypeRep();

  t.tag = "short";
  t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production bitTypeRep
t::TypeRep ::=
{ t.pp = "bit";
  t.host = bitTypeRep();

  t.tag = "bit";
  t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production byteTypeRep
t::TypeRep ::=
{ t.pp = "byte";
  t.host = byteTypeRep() ;

  t.tag = "byte";
  t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production chanTypeRep
t::TypeRep ::= 
{ t.pp = "chan " ;
  t.host = chanTypeRep();

  t.tag = "chan";
  t.isCompatible = false;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production userType
t::TypeRep ::= fields::Env
{ t.tag = "user";
  t.pp = "user";
  t.isCompatible = false;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production pidTypeRep
t::TypeRep ::=
{ t.pp = "pid";
  t.host = pidTypeRep();

  t.tag = "pid";
  t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production boolTypeRep
t::TypeRep ::=
{ t.pp = "boolean";
  t.host = boolTypeRep();

  t.tag = "boolean";
   t.isCompatible = true;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production procType
t::TypeRep ::=
{ t.tag = "proc type";
  t.pp = "proc type";
  t.isCompatible = false;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production array_type
t::TypeRep ::= ct::TypeRep
{ t.tag = "array type" ;
  t.pp = "array of " ++ ct.pp ;
  t.isCompatible = false;
  --t.var_ref_p = promela_bound_var_ref ;
}

abstract production error_type
t::TypeRep ::=
{ t.tag = "error";
  t.pp = "error";
  t.isCompatible = false;
  --t.var_ref_p = error_var_ref ;
}



-- TypeRep used in checking and expanding 'inline' statements  --
{-
abstract production inline_type
t::TypeRep ::= n::ID args::Inline_Args stmt::Stmt
{ t.tag = "inline " ++ n.lexeme ;
  t.pp =  "inline " ++ n.lexeme ;
  t.isCompatible = false;
}
-}

abstract production inline_arg_type
t::TypeRep ::= 
{ t.tag = "inline";
  t.pp = "inline";
  t.isCompatible = false;
  --t.var_ref_p = inline_var_ref ;
}

abstract production substitute_varref_with_expr_type
t::TypeRep ::= replacement::Expr
{ t.tag = "inline-sub";
  t.pp = "inline-sub";
  t.isCompatible = false;
  --t.var_ref_p = substitute_var_ref ;
}


function Compatible
Boolean ::= t1::TypeRep t2::TypeRep
{ return if (t1.pp == t2.pp)
         then true
         else false;
}
