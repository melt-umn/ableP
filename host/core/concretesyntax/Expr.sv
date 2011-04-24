grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

--FullExpr
attribute pp, ast<Expr> occurs on FullExpr_c ;

aspect production fe_expr
fe::FullExpr_c ::= e::Expr_c
{ fe.pp = e.pp;
  fe.ast = e.ast ;
}

aspect production fe_exp
fe::FullExpr_c ::= e::Expression_c
{ fe.pp = e.pp;
  fe.ast = e.ast;
}

--Expression
attribute pp, ast<Expr> occurs on Expression_c ;

-- Expr in spin.y
aspect production expr_probe_c
e::Expression_c ::= pr::Probe_c
{ e.pp = pr.pp;
  e.ast = pr.ast ;
}

aspect production expression_paren_c
exp1::Expression_c ::= '(' exp2::Expression_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
  exp1.ast = exp2.ast;
}

aspect production and_expression_c
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production and_expr_c
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expr_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production and_expr_expression_c
exp::Expression_c ::= lhs::Expr_c op::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production or_expression_c
exp::Expression_c ::= lhs::Expression_c op::OR rhs::Expression_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production or_expr_c
exp::Expression_c ::= lhs::Expression_c op::OR rhs::Expr_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production expr_or_c
exp::Expression_c ::= lhs::Expr_c op::OR rhs::Expression_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}


--Expr, (expr in spin.y)
attribute pp, ast<Expr> occurs on Expr_c ;

aspect production paren_expr_c
exp1::Expr_c ::= '(' exp2::Expr_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
  exp1.ast = exp2.ast;
}

--Mathematical expressions

aspect production plus_expr_c
exp::Expr_c ::= lhs::Expr_c '+' rhs::Expr_c
{ exp.pp = lhs.pp ++ " + " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("+", intTypeExpr()), rhs.ast) ;
}

aspect production minus_expr_c
exp::Expr_c ::= lhs::Expr_c '-' rhs::Expr_c
{ exp.pp = lhs.pp ++ " - " ++ rhs.pp;
  exp.ast = minus(lhs.ast,rhs.ast);
}

aspect production mult_expr_c
exp::Expr_c ::= lhs::Expr_c '*' rhs::Expr_c
{ exp.pp = lhs.pp ++ " * " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("*", intTypeExpr()), rhs.ast) ;
}

aspect production div_expr_c
exp::Expr_c ::= lhs::Expr_c '/' rhs::Expr_c
{ exp.pp = lhs.pp ++ " / " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("/", intTypeExpr()), rhs.ast) ;
}

aspect production mod_expr_c
exp::Expr_c ::= lhs::Expr_c '%' rhs::Expr_c
{ exp.pp = lhs.pp ++ " % " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("%", intTypeExpr()), rhs.ast) ;
}


-- boolean expressions

aspect production singleand_c
exp::Expr_c ::= lhs::Expr_c '&' rhs::Expr_c
{ exp.pp = lhs.pp ++ " & " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("&", boolTypeExpr()), rhs.ast) ;
}

aspect production xor_expr_c
exp::Expr_c ::= lhs::Expr_c '^' rhs::Expr_c
{ exp.pp = lhs.pp ++ " ^ " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("^", boolTypeExpr()), rhs.ast) ;
}


aspect production singleor_c
exp::Expr_c ::= lhs::Expr_c '|' rhs::Expr_c
{ exp.pp = lhs.pp ++ " | " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("|", boolTypeExpr()), rhs.ast) ;
}

aspect production gt_expr_c
exp::Expr_c ::= lhs::Expr_c '>' rhs::Expr_c
{ exp.pp = lhs.pp ++ " > " ++ rhs.pp ;
  exp.ast = genericBinOp(lhs.ast, mkOp(">", boolTypeExpr()), rhs.ast) ;
}

aspect production lt_expr_c
exp::Expr_c ::= lhs::Expr_c '<' rhs::Expr_c
{ exp.pp = lhs.pp ++ " < " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("<", boolTypeExpr()), rhs.ast) ;
}

aspect production ge_expr_c
exp::Expr_c ::= lhs::Expr_c '>=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >= " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(">=", boolTypeExpr()), rhs.ast) ;
}

aspect production le_expr_c
exp::Expr_c ::= lhs::Expr_c '<=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " <= " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("<=", boolTypeExpr()), rhs.ast) ;
}

aspect production eq_expr_c
exp::Expr_c ::= lhs::Expr_c '==' rhs::Expr_c
{ exp.pp = lhs.pp ++ " == " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("==", boolTypeExpr()), rhs.ast) ;
}

aspect production ne_expr_c
exp::Expr_c ::= lhs::Expr_c '!=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " != " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("!=", boolTypeExpr()), rhs.ast) ;
}

aspect production andexpr_c
exp::Expr_c ::= lhs::Expr_c '&&' rhs::Expr_c
{ exp.pp = lhs.pp ++ " && " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("&&", boolTypeExpr()), rhs.ast) ;
}

aspect production orexpr_c
exp::Expr_c ::= lhs::Expr_c '||' rhs::Expr_c
{ exp.pp = lhs.pp ++ " || " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("||", boolTypeExpr()), rhs.ast) ;
}

aspect production lshift_expr_c
exp::Expr_c ::= lhs::Expr_c op::'<<' rhs::Expr_c
{ exp.pp = lhs.pp ++ " << " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production rshift_expr_c
exp::Expr_c ::= lhs::Expr_c op::'>>' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >> " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

aspect production tild_expr_c
exp::Expr_c ::= '~' lhs::Expr_c 
{ exp.pp = "~" ++ lhs.pp ;
  exp.ast = tildeExpr(lhs.ast);
}

aspect production neg_expr_c
exp::Expr_c ::= '-' lhs::Expr_c
{ exp.pp = "-" ++ lhs.pp ;
  exp.ast = negExpr(lhs.ast);
}


-- promela expressions 

aspect production snd_expr_c
exp::Expr_c ::= '!' lhs::Expr_c
{ exp.pp = "!" ++ lhs.pp;
  exp.ast = sndNotExpr(lhs.ast);
}

aspect production expr_expr_c
e::Expr_c ::= '(' c::Expr_c s1::SEMI thenexp::Expr_c ':' elseexp::Expr_c ')'
{ e.pp = "(" ++ c.pp ++ s1.lexeme ++ thenexp.pp ++ ":" ++ elseexp.pp ++ ")";
  e.ast = condExpr(c.ast, thenexp.ast, elseexp.ast);
}

aspect production run_expr_c
exp::Expr_c ::= r::RUN an::Aname_c '(' args::Args_c ')' p::OptPriority_c
{ exp.pp = "run " ++ an.pp ++ "(" ++ args.pp ++ ")" ++ p.pp;
  exp.ast = run(an.ast, args.ast, p.ast);
}

aspect production length_expr_c
exp::Expr_c ::= l::LEN '(' vref::Varref_c ')'
{ exp.pp = "len" ++ "(" ++ vref.pp ++ ")";
  exp.ast = lengthExpr( vref.ast );
}

aspect production enabled_expr_c
exp::Expr_c ::= e::ENABLED '(' ex::Expr_c ')'
{ exp.pp = "enabled" ++ "(" ++ ex.pp ++ ")";
  exp.ast = enabledExpr( ex.ast );
}

aspect production rcv_expr_c
exp::Expr_c ::= vref::Varref_c r::RCV '[' ra::RArgs_c ']'
{ exp.pp = vref.pp ++ "?" ++ "[" ++ ra.pp ++ "]";
  exp.ast = rcvExpr( vref.ast, ra.ast );
}

aspect production rrcv_expr_c
exp::Expr_c ::= vref::Varref_c rr::R_RCV '[' ra::RArgs_c ']'
{ exp.pp = vref.pp ++ "??" ++ "[" ++ ra.pp ++ "]";
  exp.ast = rrcvExpr( vref.ast, ra.ast );
}

aspect production varref_expr_c
exp::Expr_c ::= vref::Varref_c
{ exp.pp = vref.pp;
  exp.ast = vref.ast ;
}

aspect production constExpr_c
exp::Expr_c ::= c::CONST
{ exp.pp = c.lexeme ;
  exp.ast = constExpr(c);
}

aspect production to_expr_c
e::Expr_c ::= tm::TIMEOUT
{ e.pp = "timeout";
  e.ast = timeoutExpr();
}

aspect production np_expr_c
e::Expr_c ::= np::NONPROGRESS
{ e.pp = "nonprogress";
  e.ast = noprogressExpr();
}

aspect production pcval_expr_c
e::Expr_c ::= pv::PC_VALUE '(' pc::Expr_c ')'
{ e.pp = "pc_value" ++ "(" ++ pc.pp ++ ")";
  e.ast = pcvalExpr(pc.ast);
}

aspect production pname_expr_c
e::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' '@' n::ID
{ e.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]"  ++ "@" ++ n.lexeme;
  e.ast = pnameExprIdExpr( pn,ex.ast,n);
}

aspect production name_expr_c
e::Expr_c ::= pn::PNAME '@' n::ID
{ e.pp = pn.lexeme ++ "@" ++ n.lexeme;
  e.ast = pnameIdExpr(pn,n);
}

aspect production pfld_expr_c
e::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' ':' pf::Pfld_c
{ e.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]" ++ ":" ++ pf.pp;
  pf.context = nothing() ;
  e.ast = pnameExprExpr(pn, ex.ast, pf.ast) ;
}

aspect production fld_expr_c
e::Expr_c ::= pn::PNAME ':' pf::Pfld_c
{ e.pp = pn.lexeme ++ ":" ++ pf.pp;
  pf.context = nothing() ;
  e.ast = pnameExpr(pn, pf.ast) ;
}




-- Varref
--------------------------------------------------
attribute pp, ast<Expr> occurs on Varref_c ;
inherited attribute context::Maybe<Expr> ;

aspect production varref_cmpnd_c
v::Varref_c ::= c::Cmpnd_c
{ v.pp = c.pp ;   v.ast = c.ast ; 
  c.context = nothing() ;  
  -- treat c as an expression, there is no inherited expression for it to use.
} 

attribute pp, ast<Expr>, context occurs on Cmpnd_c ;

aspect production cmpnd_pfld_c
c::Cmpnd_c ::= p::Pfld_c s::Sfld_c 
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
attribute pp, ast<Expr>, context occurs on Sfld_c ;

aspect production empty_sfld_c
sf::Sfld_c ::= 
{ sf.pp =  "" ; 
  sf.ast = case sf.context of 
             nothing() -> error ("Should not ask for ast on empty_sfld_c!") 
           | just(e) -> new(e)   -- seem to require the use of new here!
           end ;
}

aspect production dot_sfld_c
sf::Sfld_c ::= d::STOP c::Cmpnd_c 
{ sf.pp = "." ++ c.pp ; 
  sf.ast = c.ast ;
  c.context = sf.context ; 
}

--Pfld
attribute pp, ast<Expr>, context occurs on Pfld_c ;

aspect production name_pfld_c
pf::Pfld_c ::= id::ID
{ pf.pp = id.lexeme;
  pf.ast = case pf.context of
             nothing() -> varRefExprAll(id)
           | just(e) -> dotAccess(e, id) 
           end ;
}
aspect production expr_pfld_c
pf::Pfld_c ::= id::ID '[' ex::Expr_c ']'
{ pf.pp = id.lexeme ++ "[" ++ ex.pp ++ "]";
  pf.ast = case pf.context of
             nothing() -> arrayAccess(varRefExprAll(id), ex.ast)
           | just(e) -> arrayAccess(dotAccess(e,id), ex.ast)
           end ;
}



--Aname
attribute pp, ast<ID> occurs on Aname_c ;

aspect production aname_pname_c
an::Aname_c ::= pn::PNAME
{ an.pp = pn.lexeme ;
  an.ast = terminal(ID, pn.lexeme, pn.line, pn.column) ;
}
aspect production aname_name_c
an::Aname_c ::= id::ID
{ an.pp = id.lexeme ;
  an.ast = id ;
}



--Probe
attribute pp, ast<Expr> occurs on Probe_c ;

aspect production full_probe_c
pr::Probe_c ::= fl::FULL '(' vref::Varref_c ')'
{ pr.pp = "full" ++ "(" ++ vref.pp ++ ")";
  pr.ast = fullProbe(vref.ast);
}

aspect production nfull_probe_c
pr::Probe_c ::= nfl::NFULL '(' vref::Varref_c ')'
{ pr.pp = "nfull" ++ "(" ++ vref.pp ++ ")";
  pr.ast = nfullProbe(vref.ast);
}

aspect production empty_probe_c
pr::Probe_c ::= et::EMPTY '(' vref::Varref_c ')' 
{ pr.pp = "empty" ++ "(" ++ vref.pp ++ ")";
  pr.ast = emptyProbe(vref.ast);
}

aspect production nempty_probe_c
pr::Probe_c ::= net::NEMPTY '(' vref::Varref_c ')'
{ pr.pp = "nempty" ++ "(" ++ vref.pp ++ ")";
  pr.ast = nemptyProbe(vref.ast);
}

