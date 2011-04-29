grammar edu:umn:cs:melt:ableP:host:extensions:typeChecking ;

nonterminal TypeRep with tag, pp, host<TypeRep> ;

synthesized attribute typerep::TypeRep;
synthesized attribute typereps::[TypeRep] ;
synthesized attribute tag::String;

{- Type checking currently boils down to a simple "compatibility"
   check between types.  Operations such as assignment and parameter
   passing check for this compatibility between the types of,
   respectively, the left and right hand sides of the assignment, and
   the actual and formal parameters.
 -}
synthesized attribute isCompatible::Boolean occurs on TypeRep;
synthesized attribute isArithmetic::Boolean occurs on TypeRep;

-- Arithmetic Types.
-- This is not-quite standard Promela type checking.

abstract production intTypeRep
t::TypeRep ::=
{ t.pp = "int";
  t.tag = "int";
  t.host = intTypeRep();
  t.isCompatible = t.trToCheck.isArithmetic ;
  t.isArithmetic = true;
}

abstract production unsignedTypeRep
t::TypeRep ::=
{ t.pp = "unsigned";
  t.tag = "unsigned";
  t.host = unsignedTypeRep();
  t.isCompatible = t.trToCheck.isArithmetic ;
  t.isArithmetic = true;
}

abstract production shortTypeRep
t::TypeRep ::=
{ t.pp = "short";
  t.tag = "short";
  t.host = shortTypeRep();
  t.isCompatible = t.trToCheck.isArithmetic ;
  t.isArithmetic = true;
}

abstract production bitTypeRep
t::TypeRep ::=
{ t.pp = "bit";
  t.tag = "bit";
  t.host = bitTypeRep();
  t.isCompatible = t.trToCheck.isArithmetic ;
  t.isArithmetic = true;
}

abstract production byteTypeRep
t::TypeRep ::=
{ t.pp = "byte";
  t.tag = "byte";
  t.host = byteTypeRep() ;
  t.isCompatible = t.trToCheck.isArithmetic ;
  t.isArithmetic = true;
}

abstract production boolTypeRep
t::TypeRep ::=
{ t.pp = "boolean";
  t.tag = "boolean";
  t.host = boolTypeRep();
  t.isCompatible = t.trToCheck.isArithmetic ;
  t.isArithmetic = true;
}


-- non arithmetic types are checked by pattern matching.
inherited attribute trToCheck :: TypeRep occurs on TypeRep ;

function areCompatible
Boolean ::= t1::TypeRep t2::TypeRep
{ return tr_1.isCompatible ;

  -- We have a local copy of t1 since we provide it with inherited
  -- attributes that are used to determine type compatibility.
  local tr_1::TypeRep = t1 ;
  tr_1.trToCheck = t2 ;
}

function allTrue
Boolean ::= bs::[Boolean]
{ return if null(bs) then true
         else head(bs) && allTrue(tail(bs)) ; }

abstract production chanTypeRep
t::TypeRep ::= 
{ t.pp = "chan " ;
  t.tag = "chan";
  t.host = chanTypeRep();
  t.isCompatible = case t.trToCheck of
                     chanTypeRep() -> true
                   | _ -> false end ;
  t.isArithmetic = false ;
}

abstract production mtypeTypeRep
t::TypeRep ::=
{ t.pp = "mtype";
  t.tag = "mtype";
  t.host = mtypeTypeRep();
  t.isCompatible = case t.trToCheck of
                     mtypeTypeRep() -> true
                   | _ -> false end ;
  t.isArithmetic = false ;
}

abstract production pidTypeRep
t::TypeRep ::=
{ t.pp = "pid";
  t.tag = "pid";
  t.host = pidTypeRep();
  t.isCompatible = case t.trToCheck of
                     pidTypeRep() -> true
                   | _ -> false end ;
  t.isArithmetic = false ;
}

abstract production procTypeRep
t::TypeRep ::= ts::[TypeRep]
{ t.tag = "proc type";
  t.pp = "proc type";
  t.host = procTypeRep(ts);
  t.isCompatible 
    = case t.trToCheck of
        procTypeRep(ts_in) -> length(ts) == length(ts_in) &&
                              allTrue(zipWith(ts, ts_in, areCompatible))
      | _ -> false end ;
  t.isArithmetic = false ;
}

abstract production arrayTypeRep
t::TypeRep ::= ct::TypeRep
{ t.pp = "array of " ++ ct.pp ;
  t.tag = "array type" ;
  t.isCompatible = case t.trToCheck of
                     arrayTypeRep(ct2) -> true
                   | _ -> false end ;
  t.isArithmetic = false ;
}

abstract production errorTypeRep
t::TypeRep ::=
{ t.pp = "error";
  t.tag = "error";
  t.host = errorTypeRep();
  -- All type reps are compatibile with errorTypeRep.  We assume that an error
  -- message has been generated for the reason that this error-type exists.
  t.isCompatible = true;
  t.isArithmetic = true ;
}


-- TODO - complete the following types.
abstract production userType
t::TypeRep ::= fields::[ Pair<String TypeRep> ]
{ t.tag = "user";
  t.pp = "user";
  t.isCompatible = false;
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
}

abstract production substitute_varref_with_expr_type
t::TypeRep ::= replacement::Expr
{ t.tag = "inline-sub";
  t.pp = "inline-sub";
  t.isCompatible = false;
}

