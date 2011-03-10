grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal Expr with basepp,pp;

nonterminal Aname with basepp,pp;
nonterminal Probe with basepp,pp;


attribute typerep occurs on Expr,Probe;

synthesized attribute is_var_ref :: Boolean occurs on Expr ;

abstract production exp_probe
exp::Expr ::= pr::Probe
{
 exp.basepp = pr.basepp;
 exp.pp = pr.pp;
 exp.errors = pr.errors;
 exp.typerep = pr.typerep;
 exp.is_var_ref = false ; 
}


abstract production paren_expr
exp1::Expr ::= exp2::Expr
{
 exp1.basepp = "( " ++ exp2.basepp ++ " )";
 exp1.pp = "( " ++ exp2.pp ++ " )";
 exp1.errors = exp2.errors;
 exp1.typerep = exp2.typerep;
}

abstract production plus_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
 exp.basepp = lhs.basepp ++ " + " ++ rhs.basepp;
 exp.pp = lhs.pp ++ " + " ++ rhs.pp;
-- exp.errors = if (lhs.typerep.isCompatible && rhs.typerep.isCompatible)
--              then lhs.errors ++ rhs.errors
--              else ["Error : lhs and rhs are not compatible"] ++ lhs.errors ++ rhs.errors ;
-- exp.typerep = if lhs.typerep.isCompatible && rhs.typerep.isCompatible
--                then lhs.typerep
--                else error_type();
 exp.is_var_ref = false;


 production attribute transforms :: [Expr] with ++;

 transforms := [];
 
 forwards to if length(transforms) == 1
             then head(transforms)
             else if !null(lhs.errors ++ rhs.errors)
                  then exprWithErrors(exp,lhs.errors ++ rhs.errors)
                  else if length(transforms) > 1
                       then exprWithErrors(exp,["Internal Compiler Error:\n Types " ++ lhs.typerep.pp ++ " and " ++
                                                rhs.typerep.pp ++ " compatible on addition(+) on multiple ways "])
                       else exprWithErrors(exp,[" Incompatible types: " ++ lhs.typerep.pp ++ " and " ++ rhs.typerep.pp 
                                                ++ " on addition " ]);


}

aspect production plus_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  transforms <- if match(lhs.typerep,int_type()) && match(rhs.typerep,int_type())
                then [add_int(lhs,rhs)]
                else [];


}

abstract production exprWithErrors
e1::Expr ::= e2::Expr errs::[String]
{ 
  e1.pp = "/* Erroneous Expression */" ++ e2.pp;
  e1.errors = errs;
  e1.typerep = error_type();


}

abstract production add_int
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.pp = lhs.pp ++ " + " ++ rhs.pp;
  exp.typerep = int_type();
  exp.errors = lhs.errors ++ rhs.errors;

}

abstract production minus_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " - " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " - " ++ rhs.pp;

  exp.errors = if(lhs.typerep.isCompatible && rhs.typerep.isCompatible)
               then lhs.errors ++ rhs.errors
               else ["Error : lhs and rhs are not compatible"] ++ lhs.errors ++ rhs.errors;
  exp.typerep = if lhs.typerep.isCompatible && rhs.typerep.isCompatible
                then lhs.typerep
                else error_type();
  exp.is_var_ref = false;
 
}

abstract production mult_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " * " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " * " ++ rhs.pp;


 exp.errors = if(lhs.typerep.isCompatible && rhs.typerep.isCompatible)
              then lhs.errors ++ rhs.errors
              else ["Error : lhs and rhs are not compatible"] ++ lhs.errors ++ rhs.errors;

  exp.typerep = if lhs.typerep.isCompatible && rhs.typerep.isCompatible
                then lhs.typerep
                else error_type();

  exp.is_var_ref = false;
}

abstract production div_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " / " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " / " ++ rhs.pp;

  exp.errors = if(lhs.typerep.isCompatible && rhs.typerep.isCompatible)
               then lhs.errors ++ rhs.errors
               else ["Error : lhs and rhs are not compatible"] ++ lhs.errors ++ rhs.errors;

 
  exp.typerep = if lhs.typerep.isCompatible && rhs.typerep.isCompatible
                then lhs.typerep
                else error_type();

  exp.is_var_ref = false;
}

abstract production mod_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
 exp.basepp = lhs.basepp ++ " % " ++ rhs.basepp;
 exp.pp = lhs.pp ++ " % " ++ rhs.pp;

 exp.errors = if(lhs.typerep.isCompatible && rhs.typerep.isCompatible)
               then lhs.errors ++ rhs.errors
               else ["Error : lhs and rhs are not compatible"] ++ lhs.errors ++ rhs.errors;

 exp.typerep = if lhs.typerep.isCompatible && rhs.typerep.isCompatible
                then lhs.typerep
                else error_type();

 exp.is_var_ref = false;
}


abstract production singleand
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " & " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " & " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type();
  
  exp.is_var_ref = false;
}

abstract production xor_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " ^ " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " ^ " ++ rhs.pp;

  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type();
  exp.is_var_ref = false;
}

abstract production singleor
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " | " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " | " ++ rhs.pp;

  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type();

  exp.is_var_ref = false;
}



abstract production gt_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " > " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " > " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type();

  exp.is_var_ref = false;
}

abstract production lt_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " < " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " < " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 

  exp.is_var_ref = false;
}

abstract production ge_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " >= " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " >= " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 

  exp.is_var_ref = false;
}

abstract production le_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " <= " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " <= " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 

  exp.is_var_ref = false;
}

abstract production eq_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " == " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " == " ++ rhs.pp; 
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 

  exp.is_var_ref = false;
}

abstract production ne_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " != " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " != " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 
}

abstract production andexpr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " && " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " && " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 

  exp.is_var_ref = false;
}
abstract production orexpr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " || " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " || " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = boolean_type(); 

  exp.is_var_ref = false;
}

abstract production lshift_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " << " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " << " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;

  exp.typerep = lhs.typerep ; 

  exp.is_var_ref = false;
}

abstract production rshift_expr
exp::Expr ::= lhs::Expr rhs::Expr
{
  exp.basepp = lhs.basepp ++ " >> " ++ rhs.basepp;
  exp.pp = lhs.pp ++ " >> " ++ rhs.pp;
  exp.errors = lhs.errors ++ rhs.errors;
  exp.typerep = lhs.typerep ; 
 
  exp.is_var_ref = false;
}
abstract production tild_expr
exp::Expr ::= lhs::Expr
{
  exp.basepp = "~" ++ lhs.basepp;
  exp.pp = "~" ++ lhs.pp;
  exp.errors = lhs.errors;
  exp.typerep = lhs.typerep;

  exp.is_var_ref = false;
}


abstract production neg_expr
exp::Expr ::= lhs::Expr
{
  exp.basepp = "-" ++ lhs.basepp ;
  exp.pp = "-" ++ lhs.pp ;
  exp.errors = lhs.errors;
  exp.typerep = lhs.typerep;

  exp.is_var_ref = false;
}


abstract production snd_expr
exp::Expr ::= lhs::Expr
{
  exp.basepp = "!" ++ lhs.basepp; 
  exp.pp = "!" ++ lhs.pp;
  exp.errors = lhs.errors;
  exp.typerep = boolean_type();
  exp.is_var_ref = false;
}

abstract production expr_expr
exp::Expr ::= exp1::Expr exp2::Expr exp3::Expr
{
  exp.basepp = "(" ++ exp1.basepp ++ "->" ++ exp2.basepp ++ ":" ++ exp3.basepp ++ ")";
  exp.pp = "(" ++ exp1.pp ++ "->" ++ exp2.pp ++ ":" ++ exp3.pp ++ ")";
  exp.errors = exp1.errors ++ exp2.errors ++ exp3.errors;
  exp.typerep = exp2.typerep;

  exp.is_var_ref = false;
}

abstract production run_expr
exp::Expr ::= an::Aname args::Args op::OptPriority
{
  exp.basepp = "run " ++ an.basepp ++ "(" ++ args.basepp ++ ")" ++ op.basepp;
  exp.pp = "run " ++ an.pp ++ "(" ++ args.pp ++ ")" ++ op.pp;
  exp.errors = args.errors;
  exp.typerep = pid_type();

  exp.is_var_ref = false;
}

abstract production length_expr
exp::Expr ::= vref::Expr
{
  exp.basepp = "len" ++ "(" ++ vref.basepp ++ ")";
  exp.pp = "len" ++ "(" ++ vref.pp ++ ")";
  exp.errors = vref.errors;
  exp.typerep = int_type();

  exp.is_var_ref = false;
}

abstract production enabled_expr
exp::Expr ::= ex::Expr
{
  exp.basepp = "enabled" ++ "(" ++ ex.basepp ++ ")";
  exp.pp = "enabled" ++ "(" ++ ex.pp ++ ")";
  exp.errors = ex.errors;
  exp.typerep = boolean_type();

  exp.is_var_ref = false;
}


abstract production rcv_expr
exp::Expr ::= vref::Expr ra::RArgs
{
  exp.basepp = vref.basepp ++ "?" ++ "[" ++ ra.basepp ++ "]";
  exp.pp = vref.pp ++ "?" ++ "[" ++ ra.pp ++ "]";
  exp.errors = vref.errors ++ ra.errors;
  exp.typerep = boolean_type();

  exp.is_var_ref = false;
  
}

abstract production rrcv_expr
exp::Expr ::= vref::Expr ra::RArgs
{
  exp.basepp = vref.basepp ++ "??" ++ "[" ++ ra.basepp ++ "]";
  exp.pp = vref.pp ++ "??" ++ "[" ++ ra.pp ++ "]";
  exp.errors = vref.errors ++ ra.errors;
  exp.typerep = boolean_type();

  exp.is_var_ref = false;
}

abstract production varref_expr
exp::Expr ::= vref::Expr
{
  exp.basepp = vref.basepp;
  exp.pp = vref.pp;
  exp.errors = vref.errors;
  exp.typerep = vref.typerep;
  exp.is_var_ref = vref.is_var_ref;
}

abstract production abs_cexpr_expr
exp::Expr ::= ce::Cexpr
{
  exp.basepp = ce.basepp;
  exp.pp = ce.pp;
  exp.errors = ce.errors;
  exp.is_var_ref = false;
}

abstract production const_expr
exp::Expr ::= c::CONST
{
  exp.basepp = c.lexeme;
  exp.pp = c.lexeme;
  exp.errors = [];
  exp.typerep = if (c.lexeme == "true" || c.lexeme == "false")
                then boolean_type()
                else int_type();

  exp.is_var_ref = false;
}

abstract production to_expr
exp::Expr ::=
{
  exp.basepp = "timeout";
  exp.pp = "timeout";
  exp.errors = [];
  exp.typerep = boolean_type();
  exp.is_var_ref = false;
}

abstract production np_expr
exp::Expr ::=
{
  exp.basepp = "nonprogress";
  exp.pp = "nonprogress";
  exp.errors = [];
  exp.typerep = unsigned_type();
  exp.is_var_ref = false;
}

abstract production pcval_expr
exp::Expr ::= ex::Expr
{
  exp.basepp = "pc_value" ++ "(" ++ ex.basepp ++ ")";
  exp.pp = "pc_value" ++ "(" ++ ex.pp ++ ")";
  exp.errors = ex.errors;
  exp.typerep = ex.typerep;
  exp.is_var_ref = false;
}
abstract production pname_expr
exp::Expr ::= pn::PNAME ex::Expr n::ID
{
  exp.basepp = pn.lexeme ++ "[" ++ ex.basepp ++ "]" ++ "@" ++ n.lexeme; 
  exp.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]" ++ "@" ++ n.lexeme; 
  exp.errors = ex.errors;
  exp.typerep = ex.typerep;
  exp.is_var_ref = false;
}


abstract production name_expr
exp::Expr ::= pn::PNAME id::ID
{
  exp.basepp = pn.lexeme ++ "@" ++ id.lexeme ;
  exp.pp = pn.lexeme ++ "@" ++ id.lexeme ;
  exp.errors = [];
  exp.is_var_ref = false;
}

abstract production aname_name
an::Aname ::= id::ID
{
 an.basepp = id.lexeme;
 an.pp = id.lexeme;
}

abstract production aname_pname
an::Aname ::= pn::PNAME
{
 an.basepp = pn.lexeme;
 an.pp = pn.lexeme;
}
abstract production full_probe
pr::Probe ::= vref::Expr
{
  pr.basepp = "full" ++ "(" ++ vref.basepp ++ ")";
  pr.pp = "full" ++ "(" ++ vref.pp ++ ")";
  pr.errors = vref.errors;
  pr.typerep = boolean_type();
}

abstract production nfull_probe
pr::Probe ::= vref::Expr
{
  pr.basepp = "nfull" ++ "(" ++ vref.basepp ++ ")";
  pr.pp = "nfull" ++ "(" ++ vref.pp ++ ")";
  pr.errors = vref.errors;
  pr.typerep = boolean_type();
}

abstract production empty_probe
pr::Probe ::= vref::Expr
{
  pr.basepp = "empty" ++ "(" ++ vref.basepp ++ ")";
  pr.pp = "empty" ++ "(" ++ vref.pp ++ ")";
  pr.errors = vref.errors;
  pr.typerep = boolean_type();
}

abstract production nempty_probe
pr::Probe ::= vref::Expr
{
  pr.basepp = "nempty" ++ "(" ++ vref.basepp ++ ")";
  pr.pp = "nempty" ++ "(" ++ vref.pp ++ ")";
  pr.errors = vref.errors;
  pr.typerep = boolean_type();
}


abstract production expr_dot
exp::Expr ::= rec::Expr dot::STOP id::ID
{
 exp.pp = rec.pp ++ "." ++ id.lexeme;
 exp.basepp = rec.basepp ++ "." ++ id.lexeme ;
 exp.is_var_ref = true ;

 exp.typerep = field_res.typerep ;
 exp.errors = rec.errors  ++
              case rec.typerep of
                user_type(_) -> field_not_found_errors
              | _ -> mkError (id.line, id.column, "expression to left of '.' is not a record.")
              end ;

 local attribute field_not_found_errors :: [ String ] ;
 field_not_found_errors = if field_res.found then [ ]
                          else mkError(id.line, id.column, "field \"" ++ id.lexeme ++ "\" not defined.") ;

 local attribute field_res :: EnvResult ;
 field_res = lookup_name(id.lexeme, field_defs) ;

 local attribute field_defs :: Env ;
 field_defs = case rec.typerep of
                user_type(f) -> f.type
              | _ -> emptyDefs() 
              end ;
}

abstract production arrayref
exp::Expr ::= arr::Expr ls::LSQUARE  index::Expr  rs::RSQUARE
{
 exp.pp = arr.pp ++ "[" ++ index.pp ++ "]";
 exp.basepp = arr.basepp ++ "[" ++ index.basepp ++ "]";
 exp.is_var_ref = true ;

 exp.typerep = case arr.typerep of
                 array_type(ct) -> ct.type
               | _ -> error_type() 
               end ;

 
 exp.errors = arr.errors ++ index.errors ++ 
              case arr.typerep of
                array_type(_) -> [ ] 
              | _ -> mkError (ls.line, ls.column, "expression to left of '[' is not an array.")  
              end ;
}


abstract production abs_expr_chinit
exp::Expr ::= ci::ChInit
{
 exp.basepp = ci.basepp;
 exp.pp = ci.pp;
 exp.errors = ci.errors;
 exp.is_var_ref = false;


}

abstract production abs_blank_expr
exp::Expr ::=
{
 exp.basepp = "";
 exp.pp = "";
 exp.errors = [];
 exp.is_var_ref = false;


}


abstract production ch_init
ch::ChInit ::= c::CONST tl::TypList
{
 ch.basepp = "[ " ++ c.lexeme ++ " ] of { " ++ tl.basepp ++ " }";
 ch.pp = "[ " ++ c.lexeme ++ " ] of { " ++ tl.pp ++ " }";
 ch.errors = tl.errors;

}
