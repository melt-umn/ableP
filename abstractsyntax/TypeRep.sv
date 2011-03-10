grammar edu:umn:cs:melt:ableP:abstractsyntax;
import edu:umn:cs:melt:ableP:terminals;

synthesized attribute typerep::TypeRep;

nonterminal TypeRep with var_ref_p, tag;

synthesized attribute tag::String;
synthesized attribute pp::String;
synthesized attribute isCompatible::Boolean;
attribute isCompatible occurs on TypeRep;
attribute pp occurs on TypeRep;

synthesized attribute var_ref_p :: Production (Expr ::= ID TypeRep ) ;


abstract production int_type
t::TypeRep ::=
{
  t.tag = "int";
  t.pp = "int";
  t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production unsigned_type
t::TypeRep ::=
{
  t.tag = "unsigned";
  t.pp = "unsigned";
  t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production short_type
t::TypeRep ::=
{
  t.tag = "short";
  t.pp = "short";
  t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production bit_type
t::TypeRep ::=
{
 t.tag = "bit";
 t.pp = "bit";
 t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production byte_type
t::TypeRep ::=
{
 t.tag = "byte";
 t.pp = "byte";
 t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production chan_type
t::TypeRep ::= 
{
 t.tag = "chan";
 t.pp = "chan " ;
 t.isCompatible = false;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production user_type
t::TypeRep ::= fields::Env
{
 t.tag = "user";
 t.pp = "user";
 t.isCompatible = false;
 t.var_ref_p = promela_bound_var_ref ;
}

abstract production mtype_type
t::TypeRep ::=
{
 t.tag = "mtype";
 t.pp = "mtype";
 t.isCompatible = false;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production pid_type
t::TypeRep ::=
{
 t.tag = "pid";
 t.pp = "pid";
 t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production boolean_type
t::TypeRep ::=
{
 t.tag = "boolean";
 t.pp = "boolean";
 t.isCompatible = true;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production proc_type
 t::TypeRep ::=
{
 t.tag = "proc type";
 t.pp = "proc type";
 t.isCompatible = false;
  t.var_ref_p = promela_bound_var_ref ;
}

abstract production array_type
t::TypeRep ::= ct::TypeRep
{
 t.tag = "array type" ;
 t.pp = "array of " ++ ct.pp ;
 t.isCompatible = false;
 t.var_ref_p = promela_bound_var_ref ;
}

abstract production error_type
t::TypeRep ::=
{
 t.tag = "error";
 t.pp = "error";
 t.isCompatible = false;
 t.var_ref_p = error_var_ref ;
}



-- TypeRep used in checking and expanding 'inline' statements  --
abstract production inline_type
t::TypeRep ::= n::ID args::Inline_Args stmt::Stmt
{
 t.tag = "inline " ++ n.lexeme ;
 t.pp =  "inline " ++ n.lexeme ;
 t.isCompatible = false;
}

abstract production inline_arg_type
t::TypeRep ::= 
{
 t.tag = "inline";
 t.pp = "inline";
 t.isCompatible = false;
 t.var_ref_p = inline_var_ref ;
}

abstract production substitute_varref_with_expr_type
t::TypeRep ::= replacement::Expr
{
 t.tag = "inline-sub";
 t.pp = "inline-sub";
 t.isCompatible = false;
 t.var_ref_p = substitute_var_ref ;
}


function Compatible
Boolean ::= t1::TypeRep t2::TypeRep
{
 return if (t1.pp == t2.pp)
        then true
        else false;
}