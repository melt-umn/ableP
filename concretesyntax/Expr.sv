grammar edu:umn:cs:melt:ableP:concretesyntax;

--notation is bit of confusing from given grammar notation
--Expr represents expr
--Expression represents Expr

--FullExpr
nonterminal FullExpr_c with pp, ast<Expr> ;   -- same as in v4.2.9 and v6
-- full_expr in spin.y

concrete production fe_expr
fe::FullExpr_c ::= e::Expr_c
{ fe.pp = e.pp;
  fe.ast = e.ast ;
}

concrete production fe_exp
fe::FullExpr_c ::= e::Expression_c
{ fe.pp = e.pp;
  fe.ast = e.ast;
}

--Expression
nonterminal Expression_c with pp, ast<Expr> ;     -- same as in v4.2.9 and v6
-- Expr in spin.y
concrete production expr_probe_c
exp::Expression_c ::= pr::Probe_c
{ exp.pp = pr.pp;
-- exp.ast_Expr = exp_probe(pr.ast_Probe);
}

concrete production expression_paren_c
exp1::Expression_c ::= '(' exp2::Expression_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
  exp1.ast = exp2.ast;
}

concrete production and_expression_c
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, booleanTypeRep()), rhs.ast) ;
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
nonterminal Expr_c with pp, ast<Expr> ; -- same as v4.2.9 and v6 (except for fixable CHARLIT and LTL)
-- expr in spin.y

concrete production paren_expr_c
exp1::Expr_c ::= '(' exp2::Expr_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
  exp1.ast = exp2.ast;
}

--Mathematical expressions

concrete production plus_expr_c
exp::Expr_c ::= lhs::Expr_c '+' rhs::Expr_c
{ exp.pp = lhs.pp ++ " + " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("+", intTypeRep()), rhs.ast) ;
}

concrete production minus_expr_c
exp::Expr_c ::= lhs::Expr_c '-' rhs::Expr_c
{ exp.pp = lhs.pp ++ " - " ++ rhs.pp;
-- exp.ast_Expr = minus_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production mult_expr_c
exp::Expr_c ::= lhs::Expr_c '*' rhs::Expr_c
{ exp.pp = lhs.pp ++ " * " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("*", intTypeRep()), rhs.ast) ;
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
  exp.ast = genericBinOp(lhs.ast, mkOp("<", booleanTypeRep()), rhs.ast) ;
}

concrete production ge_expr_c
exp::Expr_c ::= lhs::Expr_c '>=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >= " ++ rhs.pp;
-- exp.ast_Expr = ge_expr(lhs.ast_Expr,rhs.ast_Expr);
}

concrete production le_expr_c
exp::Expr_c ::= lhs::Expr_c '<=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " <= " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("<=", booleanTypeRep()), rhs.ast) ;
}


concrete production eq_expr_c
exp::Expr_c ::= lhs::Expr_c '==' rhs::Expr_c
{ exp.pp = lhs.pp ++ " == " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("==", booleanTypeRep()), rhs.ast) ;
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
  exp.ast = genericBinOp(lhs.ast, mkOp("||", booleanTypeRep()), rhs.ast) ;
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
  exp.ast = vref.ast ;
}

concrete production c_expr_c
e::Expr_c ::= ce::Cexpr_c
{ e.pp = ce.pp ;
-- e.ast_Expr = expr_ccode(ce.ast_Cexpr) ;
}

concrete production const_expr_c
exp::Expr_c ::= c::CONST
{ exp.pp = c.lexeme ;
  exp.ast = constExpr(c);
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
-- So, varref, cmpnd, and sfld in spin.y are represented correctly here.
nonterminal Varref_c with pp, ast<Expr> ;  -- same as in v4.2.9 and v6
inherited attribute context::Maybe<Expr> ;

concrete production varref_cmpnd_c
v::Varref_c ::= c::Cmpnd_c
{ v.pp = c.pp ;   v.ast = c.ast ; 
  c.context = nothing() ;  
  -- treat c as an expression, there is no inherited expression for it to use.
} 

nonterminal Cmpnd_c with pp, ast<Expr>, context ;  -- same as in v4.2.9 and v6
concrete production cmpnd_pfld_c
c::Cmpnd_c ::= p::Pfld s::Sfld 
{ c.pp = p.pp ++ s.pp ;  
  c.ast = s.ast ;
          --case s of
          --  empty_sfld_c() -> p.ast
          --| _ -> s.ast
          --end ;
  p.context = c.context ;
  s.context = just(p.ast) ;
}

--Sfld
nonterminal Sfld with pp, ast<Expr>, context ;  -- same as in v4.2.9 and v6
concrete production empty_sfld_c
sf::Sfld ::= 
{ sf.pp =  "" ; 
  sf.ast = case sf.context of 
             nothing() -> error ("Should not ask for ast on empty_sfld_c!") 
           | just(e) -> new(e)   -- seem to require the use of new here!
           end ;
}

concrete production dot_sfld_c
sf::Sfld ::= d::STOP c::Cmpnd_c 
precedence = 45
{ sf.pp = "." ++ c.pp ; 
  sf.ast = c.ast ;
  c.context = sf.context ; 
}

--Pfld
-- Here, ID may be a field name (of type array) or an expression that names an array.
nonterminal Pfld with pp, ast<Expr>, context ;   -- same as in v4.2.9 and v6
concrete production name_pfld_c
pf::Pfld ::= id::ID
{ pf.pp = id.lexeme;
  pf.ast = case pf.context of
             nothing() -> varRef(id)
           | just(e) -> dotAccess(e, id) 
           end ;
}
concrete production expr_pfld_c
pf::Pfld ::= id::ID '[' ex::Expr_c ']'
{ pf.pp = id.lexeme ++ "[" ++ ex.pp ++ "]";
  pf.ast = case pf.context of
             nothing() -> arrayAccess(varRef(id), ex.ast)
           | just(e) -> arrayAccess(dotAccess(e,id), ex.ast)
           end ;
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

