grammar edu:umn:cs:melt:ableP:concretesyntax;

--notation is bit of confusing from given grammar notation
--Expr represents expr
--Expression represents Expr

--FullExpr
nonterminal FullExpr_c with pp;   -- same as in v4.2.9 and v6
-- full_expr in spin.y

--synthesized attribute ast_Expr::Expr occurs on Expr_c, Expression_c, FullExpr_c;
--synthesized attribute ast_Probe::Probe occurs on Probe_c;

concrete production fe_expr
fe::FullExpr_c ::= e1::Expr_c
{ fe.pp = e1.pp;
-- fe.ast_Expr = e1.ast_Expr;
}

concrete production fe_exp
fe::FullExpr_c ::= e1::Expression_c
{ fe.pp = e1.pp;
-- fe.ast_Expr = e1.ast_Expr;
}


--Expression
nonterminal Expression_c with pp ;     -- same as in v4.2.9 and v6
-- Expr in spin.y
concrete production expr_probe_c
exp::Expression_c ::= pr::Probe_c
{ exp.pp = pr.pp;
-- exp.ast_Expr = exp_probe(pr.ast_Probe);
}

concrete production expression_paren_c
exp1::Expression_c ::= '(' exp2::Expression_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
--  exp1.ast_Expr = paren_expr(exp2.ast_Expr);
}

concrete production and_expression_c
exp::Expression_c ::= lhs::Expression_c a::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
-- exp.ast_Expr = andexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production and_expr_c
exp::Expression_c ::= lhs::Expression_c a::AND rhs::Expr_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
-- exp.ast_Expr = andexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production and_expr_expression_c
exp::Expression_c ::= lhs::Expr_c a::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
-- exp.ast_Expr = andexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production or_expression_c
exp::Expression_c ::= lhs::Expression_c o::OR rhs::Expression_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
-- exp.ast_Expr = orexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production or_expr_c
exp::Expression_c ::= lhs::Expression_c o::OR rhs::Expr_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
-- exp.ast_Expr = orexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production expr_or_c
exp::Expression_c ::= lhs::Expr_c o::OR rhs::Expression_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
-- exp.ast_Expr = orexpr(lhs.ast_Expr,rhs.ast_Expr);
}


--Expr
nonterminal Expr_c with pp; -- same as v4.2.9 and v6 (except for fixable CHARLIT and LTL)
-- expr in spin.y

concrete production paren_expr_c
exp1::Expr_c ::= '(' exp2::Expr_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
-- exp1.ast_Expr = paren_expr(exp2.ast_Expr);
}

--Mathematical expressions

concrete production plus_expr_c
exp::Expr_c ::= lhs::Expr_c '+' rhs::Expr_c
{ exp.pp = lhs.pp ++ " + " ++ rhs.pp;
-- exp.ast_Expr = plus_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production minus_expr_c
exp::Expr_c ::= lhs::Expr_c '-' rhs::Expr_c
{ exp.pp = lhs.pp ++ " - " ++ rhs.pp;
-- exp.ast_Expr = minus_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production mult_expr_c
exp::Expr_c ::= lhs::Expr_c '*' rhs::Expr_c
{ exp.pp = lhs.pp ++ " * " ++ rhs.pp;
-- exp.ast_Expr = mult_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production div_expr_c
exp::Expr_c ::= lhs::Expr_c '/' rhs::Expr_c
{ exp.pp = lhs.pp ++ " / " ++ rhs.pp;
-- exp.ast_Expr = div_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production mod_expr_c
exp::Expr_c ::= lhs::Expr_c '%' rhs::Expr_c
{ exp.pp = lhs.pp ++ " % " ++ rhs.pp;
-- exp.ast_Expr = mod_expr(lhs.ast_Expr,rhs.ast_Expr);
}


-- boolean expressions

concrete production singleand_c
exp::Expr_c ::= lhs::Expr_c '&' rhs::Expr_c
{ exp.pp = lhs.pp ++ " & " ++ rhs.pp;
-- exp.ast_Expr = singleand(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production xor_expr_c
exp::Expr_c ::= lhs::Expr_c '^' rhs::Expr_c
{ exp.pp = lhs.pp ++ " ^ " ++ rhs.pp;
-- exp.ast_Expr = xor_expr(lhs.ast_Expr,rhs.ast_Expr);
}


concrete production singleor_c
exp::Expr_c ::= lhs::Expr_c '|' rhs::Expr_c
{ exp.pp = lhs.pp ++ " | " ++ rhs.pp;
-- exp.ast_Expr = singleor(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production gt_expr_c
exp::Expr_c ::= lhs::Expr_c '>' rhs::Expr_c
{ exp.pp = lhs.pp ++ " > " ++ rhs.pp ;
-- exp.ast_Expr = gt_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production lt_expr_c
exp::Expr_c ::= lhs::Expr_c '<' rhs::Expr_c
{ exp.pp = lhs.pp ++ " < " ++ rhs.pp;
-- exp.ast_Expr = lt_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production ge_expr_c
exp::Expr_c ::= lhs::Expr_c '>=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >= " ++ rhs.pp;
-- exp.ast_Expr = ge_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production le_expr_c
exp::Expr_c ::= lhs::Expr_c '<=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " <= " ++ rhs.pp;
-- exp.ast_Expr = le_expr(lhs.ast_Expr,rhs.ast_Expr);
}


concrete production eq_expr_c
exp::Expr_c ::= lhs::Expr_c '==' rhs::Expr_c
{ exp.pp = lhs.pp ++ " == " ++ rhs.pp;
-- exp.ast_Expr = eq_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production ne_expr_c
exp::Expr_c ::= lhs::Expr_c '!=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " != " ++ rhs.pp;
-- exp.ast_Expr = ne_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production andexpr_c
exp::Expr_c ::= lhs::Expr_c '&&' rhs::Expr_c
{ exp.pp = lhs.pp ++ " && " ++ rhs.pp;
-- exp.ast_Expr = andexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production orexpr_c
exp::Expr_c ::= lhs::Expr_c '||' rhs::Expr_c
{ exp.pp = lhs.pp ++ " || " ++ rhs.pp;
-- exp.ast_Expr = orexpr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production lshift_expr_c
exp::Expr_c ::= lhs::Expr_c '<<' rhs::Expr_c
{ exp.pp = lhs.pp ++ " << " ++ rhs.pp;
-- exp.ast_Expr = lshift_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production rshift_expr_c
exp::Expr_c ::= lhs::Expr_c '>>' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >> " ++ rhs.pp;
-- exp.ast_Expr = rshift_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production tild_expr_c
exp::Expr_c ::= '~' lhs::Expr_c 
{ exp.pp = "~" ++ lhs.pp ;
-- exp.ast_Expr = tild_expr(lhs.ast_Expr);
}

concrete production neg_expr_c
exp::Expr_c ::= '-' lhs::Expr_c
precedence = 45
{ exp.pp = "-" ++ lhs.pp ;
-- exp.ast_Expr = neg_expr(lhs.ast_Expr);
}


-- promela expressions 

concrete production snd_expr_c
exp::Expr_c ::= '!' lhs::Expr_c
precedence = 45
{ exp.pp = "!" ++ lhs.pp;
-- exp.ast_Expr = snd_expr(lhs.ast_Expr);
}

concrete production expr_expr_c
exp::Expr_c ::= '(' exp1::Expr_c s1::SEMI exp2::Expr_c ':' exp3::Expr_c ')'
{ exp.pp = "(" ++ exp1.pp ++ s1.lexeme ++ exp2.pp ++ ":" ++ exp3.pp ++ ")";
-- exp.ast_Expr = expr_expr(exp1.ast_Expr,exp2.ast_Expr,exp3.ast_Expr);
}

concrete production run_expr_c
exp::Expr_c ::= r::RUN an::Aname_c '(' args::Args_c ')' op::OptPriority_c
{ exp.pp = "run " ++ an.pp ++ "(" ++ args.pp ++ ")" ++ op.pp;
-- exp.ast_Expr = run_expr(an.ast_Aname,args.ast_Args,op.ast_OptPriority);
}



concrete production length_expr_c
exp::Expr_c ::= l::LEN '(' vref::Varref_c ')'
{ exp.pp = "len" ++ "(" ++ vref.pp ++ ")";
-- exp.ast_Expr = length_expr(vref.ast_Expr);
}

concrete production enabled_expr_c
exp::Expr_c ::= e::ENABLED '(' ex::Expr_c ')'
{ exp.pp = "enabled" ++ "(" ++ ex.pp ++ ")";
-- exp.ast_Expr = enabled_expr(ex.ast_Expr);
}

concrete production rcv_expr_c
exp::Expr_c ::= vref::Varref_c r::RCV '[' ra::RArgs_c ']'
{ exp.pp = vref.pp ++ "?" ++ "[" ++ ra.pp ++ "]";
-- exp.ast_Expr = rcv_expr(vref.ast_Expr,ra.ast_RArgs);
}

concrete production rrcv_expr_c
exp::Expr_c ::= vref::Varref_c rr::R_RCV '[' ra::RArgs_c ']'
{ exp.pp = vref.pp ++ "??" ++ "[" ++ ra.pp ++ "]";
-- exp.ast_Expr = rrcv_expr(vref.ast_Expr,ra.ast_RArgs);
}


concrete production varref_expr_c
exp::Expr_c ::= vref::Varref_c
{ exp.pp = vref.pp;
-- exp.ast_Expr = varref_expr(vref.ast_Expr);
}

concrete production c_expr_c
e::Expr_c ::= ce::Cexpr_c
{ e.pp = ce.pp ;
-- e.ast_Expr = expr_ccode(ce.ast_Cexpr) ;
}

concrete production const_expr_c
exp::Expr_c ::= c::CONST
{ exp.pp = c.lexeme ;
-- exp.ast_Expr = const_expr(c);
}

concrete production to_expr_c
exp::Expr_c ::= tm::TIMEOUT
{ exp.pp = "timeout";
-- exp.ast_Expr = to_expr();
}

concrete production np_expr_c
exp::Expr_c ::= np::NONPROGRESS
{ exp.pp = "nonprogress";
-- exp.ast_Expr = np_expr();
}

concrete production pcval_expr_c
exp::Expr_c ::= pv::PC_VALUE '(' ex::Expr_c ')'
{ exp.pp = "pc_value" ++ "(" ++ ex.pp ++ ")";
-- exp.ast_Expr = pcval_expr(ex.ast_Expr);
}

concrete production pname_expr_c
exp::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' '@' n::ID
{ exp.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]"  ++ "@" ++ n.lexeme;
-- exp.ast_Expr = pname_expr(pn,ex.ast_Expr,n);
}

concrete production pfld_expr_c
exp::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' ':' pf::Pfld
{ exp.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]" ++ ":" ++ pf.pp;
}

concrete production name_expr_c
exp::Expr_c ::= pn::PNAME '@' n::ID
{ exp.pp = pn.lexeme ++ "@" ++ n.lexeme;
-- exp.ast_Expr = name_expr(pn,n);
}

concrete production fld_expr_c
exp::Expr_c ::= pn::PNAME ':' pf::Pfld
{ exp.pp = pn.lexeme ++ ":" ++ pf.pp;
}

-- could combine CHARLIT into CONST to remove this to be like v4.2.9 and v6
concrete production const_expr_charlit_c
exp::Expr_c ::= c::CHARLIT
{ exp.pp = c.lexeme ;
-- exp.ast_Expr = const_expr(terminal(CONST,c.lexeme,c.line,c.column));
}





-- Varref
--------------------------------------------------
nonterminal Varref_c with pp;  -- same as in v4.2.9 and v6
--attribute ast_Expr occurs on Varref_c;

{-
-- These three are not as in v4.2.9 nor as in v6
concrete production varref_name_only_c
v::Varref_c ::= a::ID 
{ v.pp = a.lexeme ;
-- v.ast_Expr = expr_name(a);
}

concrete production varref_array_c
v::Varref_c ::= va::Varref_c ls::LSQUARE index::Expr_c  rs::RSQUARE
{ v.pp = va.pp ++ "[" ++ index.pp ++ "]" ;
-- v.ast_Expr = arrayref( va.ast_Expr, ls, index.ast_Expr, rs) ;
}

concrete production varref_field_c
v::Varref_c ::= vr::Varref_c d::STOP f::ID
{ v.pp = vr.pp ++ "." ++ f.lexeme  ;
-- v.ast_Expr = expr_dot(vr.ast_Expr, d, f);
}
-}

-- These are as in v4.2.9 and v6
-- So, varref, cmpnd, and sfld in spin.y are not represented correctly here.
concrete production varref_cmpnd_c
v::Varref_c ::= c::Cmpnd_c
{ v.pp = c.pp ; } 

nonterminal Cmpnd_c with pp ;
concrete production cmpnd_pfld_c
c::Cmpnd_c ::= p::Pfld  s::Sfld 
{ c.pp = p.pp ++ s.pp ; }

--Sfld
nonterminal Sfld with pp;

concrete production empty_sfld_c
sf::Sfld ::= 
{ sf.pp =  "" ; }

concrete production dot_sfld_c
sf::Sfld ::= d::STOP c::Cmpnd_c 
precedence = 45
{ sf.pp = "." ++ c.pp ; 
}

---  }


-- from before

--Pfld
nonterminal Pfld with pp;
--attribute ast_Expr occurs on Pfld;

concrete production name_pfld_c
pf::Pfld ::= id::ID
{ pf.pp = id.lexeme;
-- pf.ast_Expr = expr_name(id);
}

concrete production expr_pfld_c
pf::Pfld ::= id::ID '[' ex::Expr_c ']'
{ pf.pp = id.lexeme ++ "[" ++ ex.pp ++ "]";
-- pf.ast_Expr = arrayref(expr_name(id),'[',ex.ast_Expr,']');
}



--Aname
nonterminal Aname_c with pp;   -- same as v4.2.9 and v6

--synthesized attribute ast_Aname::Aname occurs on Aname_c;

concrete production aname_pname_c
an::Aname_c ::= pn::PNAME
{ an.pp = pn.lexeme ;
-- an.ast_Aname = aname_pname(pn);
}
action
{ -- not clear to me why we add pnames to the list - it must already be here?
  local attribute procname::String;
  procname = pn.lexeme;
  pnames = if (!listContains(procname,pnames))
           then [procname] ++ pnames
           else pnames;
}



concrete production aname_name_c
an::Aname_c ::= id::ID
{ an.pp = id.lexeme ;
--  an.ast_Aname = aname_name(id);
}
action
{ -- not sure why we add this to the list either - does this define ID as a PNAME???
  local attribute procid::String;
  procid = id.lexeme;
  pnames = if (!listContains(procid,pnames))
           then [procid] ++ pnames
           else pnames;
}



--
--Probe
nonterminal Probe_c with pp;   -- same as in v4.2.9 and v6

concrete production full_probe_c
pr::Probe_c ::= fl::FULL '(' vref::Varref_c ')'
{ pr.pp = "full" ++ "(" ++ vref.pp ++ ")";
-- pr.ast_Probe = full_probe(vref.ast_Expr);
}

concrete production nfull_probe_c
pr::Probe_c ::= nfl::NFULL '(' vref::Varref_c ')'
{ pr.pp = "nfull" ++ "(" ++ vref.pp ++ ")";
-- pr.ast_Probe = nfull_probe(vref.ast_Expr);
}

concrete production empty_probe_c
pr::Probe_c ::= et::EMPTY '(' vref::Varref_c ')' 
{ pr.pp = "empty" ++ "(" ++ vref.pp ++ ")";
-- pr.ast_Probe = empty_probe(vref.ast_Expr);
}

concrete production nempty_probe_c
pr::Probe_c ::= net::NEMPTY '(' vref::Varref_c ')'
{ pr.pp = "nempty" ++ "(" ++ vref.pp ++ ")";
-- pr.ast_Probe = nempty_probe(vref.ast_Expr);
}

