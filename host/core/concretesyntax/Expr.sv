grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

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
e::Expression_c ::= pr::Probe_c
{ e.pp = pr.pp;
  e.ast = pr.ast ;
}

concrete production expression_paren_c
exp1::Expression_c ::= '(' exp2::Expression_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
  exp1.ast = exp2.ast;
}

concrete production and_expression_c
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production and_expr_c
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expr_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production and_expr_expression_c
exp::Expression_c ::= lhs::Expr_c op::AND rhs::Expression_c
{ exp.pp = lhs.pp ++ "&&" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production or_expression_c
exp::Expression_c ::= lhs::Expression_c op::OR rhs::Expression_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production or_expr_c
exp::Expression_c ::= lhs::Expression_c op::OR rhs::Expr_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production expr_or_c
exp::Expression_c ::= lhs::Expr_c op::OR rhs::Expression_c
{ exp.pp = lhs.pp ++ "||" ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}


--Expr, (expr in spin.y)
nonterminal Expr_c with pp, ast<Expr> ; -- same as v4.2.9 and v6 (except for fixable CHARLIT and LTL)
synthesized attribute cst_Expr_c::Expr_c occurs on Expr ;

concrete production paren_expr_c
exp1::Expr_c ::= '(' exp2::Expr_c ')'
{ exp1.pp = "(" ++ exp2.pp ++ ")";
  exp1.ast = exp2.ast;
}

--Mathematical expressions

concrete production plus_expr_c
exp::Expr_c ::= lhs::Expr_c '+' rhs::Expr_c
{ exp.pp = lhs.pp ++ " + " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("+", intTypeExpr()), rhs.ast) ;
}

concrete production minus_expr_c
exp::Expr_c ::= lhs::Expr_c '-' rhs::Expr_c
{ exp.pp = lhs.pp ++ " - " ++ rhs.pp;
  exp.ast = minus(lhs.ast,rhs.ast);
}

concrete production mult_expr_c
exp::Expr_c ::= lhs::Expr_c '*' rhs::Expr_c
{ exp.pp = lhs.pp ++ " * " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("*", intTypeExpr()), rhs.ast) ;
}

concrete production div_expr_c
exp::Expr_c ::= lhs::Expr_c '/' rhs::Expr_c
{ exp.pp = lhs.pp ++ " / " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("/", intTypeExpr()), rhs.ast) ;
}

concrete production mod_expr_c
exp::Expr_c ::= lhs::Expr_c '%' rhs::Expr_c
{ exp.pp = lhs.pp ++ " % " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("%", intTypeExpr()), rhs.ast) ;
}


-- boolean expressions

concrete production singleand_c
exp::Expr_c ::= lhs::Expr_c '&' rhs::Expr_c
{ exp.pp = lhs.pp ++ " & " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("&", boolTypeExpr()), rhs.ast) ;
}

concrete production xor_expr_c
exp::Expr_c ::= lhs::Expr_c '^' rhs::Expr_c
{ exp.pp = lhs.pp ++ " ^ " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("^", boolTypeExpr()), rhs.ast) ;
}


concrete production singleor_c
exp::Expr_c ::= lhs::Expr_c '|' rhs::Expr_c
{ exp.pp = lhs.pp ++ " | " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("|", boolTypeExpr()), rhs.ast) ;
}

concrete production gt_expr_c
exp::Expr_c ::= lhs::Expr_c '>' rhs::Expr_c
{ exp.pp = lhs.pp ++ " > " ++ rhs.pp ;
  exp.ast = genericBinOp(lhs.ast, mkOp(">", boolTypeExpr()), rhs.ast) ;
}

concrete production lt_expr_c
exp::Expr_c ::= lhs::Expr_c '<' rhs::Expr_c
{ exp.pp = lhs.pp ++ " < " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("<", boolTypeExpr()), rhs.ast) ;
}

concrete production ge_expr_c
exp::Expr_c ::= lhs::Expr_c '>=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >= " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(">=", boolTypeExpr()), rhs.ast) ;
}

concrete production le_expr_c
exp::Expr_c ::= lhs::Expr_c '<=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " <= " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("<=", boolTypeExpr()), rhs.ast) ;
}


concrete production eq_expr_c
exp::Expr_c ::= lhs::Expr_c '==' rhs::Expr_c
{ exp.pp = lhs.pp ++ " == " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("==", boolTypeExpr()), rhs.ast) ;
}

concrete production ne_expr_c
exp::Expr_c ::= lhs::Expr_c '!=' rhs::Expr_c
{ exp.pp = lhs.pp ++ " != " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("!=", boolTypeExpr()), rhs.ast) ;
}

concrete production andexpr_c
exp::Expr_c ::= lhs::Expr_c '&&' rhs::Expr_c
{ exp.pp = lhs.pp ++ " && " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("&&", boolTypeExpr()), rhs.ast) ;
}

concrete production orexpr_c
exp::Expr_c ::= lhs::Expr_c '||' rhs::Expr_c
{ exp.pp = lhs.pp ++ " || " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp("||", boolTypeExpr()), rhs.ast) ;
}

concrete production lshift_expr_c
exp::Expr_c ::= lhs::Expr_c op::'<<' rhs::Expr_c
{ exp.pp = lhs.pp ++ " << " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production rshift_expr_c
exp::Expr_c ::= lhs::Expr_c op::'>>' rhs::Expr_c
{ exp.pp = lhs.pp ++ " >> " ++ rhs.pp;
  exp.ast = genericBinOp(lhs.ast, mkOp(op.lexeme, boolTypeExpr()), rhs.ast) ;
}

concrete production tild_expr_c
exp::Expr_c ::= '~' lhs::Expr_c 
{ exp.pp = "~" ++ lhs.pp ;
  exp.ast = tildeExpr(lhs.ast);
}

concrete production neg_expr_c
exp::Expr_c ::= '-' lhs::Expr_c
precedence = 45
{ exp.pp = "-" ++ lhs.pp ;
  exp.ast = negExpr(lhs.ast);
}


-- promela expressions 

concrete production snd_expr_c
exp::Expr_c ::= '!' lhs::Expr_c
precedence = 45
{ exp.pp = "!" ++ lhs.pp;
  exp.ast = sndNotExpr(lhs.ast);
}

concrete production expr_expr_c
e::Expr_c ::= '(' c::Expr_c s1::SEMI thenexp::Expr_c ':' elseexp::Expr_c ')'
{ e.pp = "(" ++ c.pp ++ s1.lexeme ++ thenexp.pp ++ ":" ++ elseexp.pp ++ ")";
  e.ast = condExpr(c.ast, thenexp.ast, elseexp.ast);
}

concrete production run_expr_c
exp::Expr_c ::= r::RUN an::Aname_c '(' args::Args_c ')' p::OptPriority_c
{ exp.pp = "run " ++ an.pp ++ "(" ++ args.pp ++ ")" ++ p.pp;
  exp.ast = run(an.ast, args.ast, p.ast);
}

concrete production length_expr_c
exp::Expr_c ::= l::LEN '(' vref::Varref_c ')'
{ exp.pp = "len" ++ "(" ++ vref.pp ++ ")";
  exp.ast = lengthExpr( vref.ast );
}

concrete production enabled_expr_c
exp::Expr_c ::= e::ENABLED '(' ex::Expr_c ')'
{ exp.pp = "enabled" ++ "(" ++ ex.pp ++ ")";
  exp.ast = enabledExpr( ex.ast );
}

concrete production rcv_expr_c
exp::Expr_c ::= vref::Varref_c r::RCV '[' ra::RArgs_c ']'
{ exp.pp = vref.pp ++ "?" ++ "[" ++ ra.pp ++ "]";
  exp.ast = rcvExpr( vref.ast, ra.ast );
}

concrete production rrcv_expr_c
exp::Expr_c ::= vref::Varref_c rr::R_RCV '[' ra::RArgs_c ']'
{ exp.pp = vref.pp ++ "??" ++ "[" ++ ra.pp ++ "]";
  exp.ast = rrcvExpr( vref.ast, ra.ast );
}

concrete production varref_expr_c
exp::Expr_c ::= vref::Varref_c
{ exp.pp = vref.pp;
  exp.ast = vref.ast ;
}

concrete production constExpr_c
exp::Expr_c ::= c::CONST
{ exp.pp = c.lexeme ;
  exp.ast = constExpr(c);
}

concrete production to_expr_c
e::Expr_c ::= tm::TIMEOUT
{ e.pp = "timeout";
  e.ast = timeoutExpr();
}

concrete production np_expr_c
e::Expr_c ::= np::NONPROGRESS
{ e.pp = "nonprogress";
  e.ast = noprogressExpr();
}

concrete production pcval_expr_c
e::Expr_c ::= pv::PC_VALUE '(' pc::Expr_c ')'
{ e.pp = "pc_value" ++ "(" ++ pc.pp ++ ")";
  e.ast = pcvalExpr(pc.ast);
}

concrete production pname_expr_c
e::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' '@' n::ID
{ e.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]"  ++ "@" ++ n.lexeme;
  e.ast = pnameExprIdExpr( pn,ex.ast,n);
}

concrete production name_expr_c
e::Expr_c ::= pn::PNAME '@' n::ID
{ e.pp = pn.lexeme ++ "@" ++ n.lexeme;
  e.ast = pnameIdExpr(pn,n);
}

concrete production pfld_expr_c
e::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' ':' pf::Pfld_c
{ e.pp = pn.lexeme ++ "[" ++ ex.pp ++ "]" ++ ":" ++ pf.pp;
  pf.context = nothing() ;
  e.ast = pnameExprExpr(pn, ex.ast, pf.ast) ;
}

concrete production fld_expr_c
e::Expr_c ::= pn::PNAME ':' pf::Pfld_c
{ e.pp = pn.lexeme ++ ":" ++ pf.pp;
  pf.context = nothing() ;
  e.ast = pnameExpr(pn, pf.ast) ;
}




-- Varref
--------------------------------------------------

nonterminal Varref_c with pp, ast<Expr> ;  -- same as in v4.2.9 and v6
-- So, varref, cmpnd, and sfld in spin.y are represented correctly here.
inherited attribute context::Maybe<Expr> ;

concrete production varref_cmpnd_c
v::Varref_c ::= c::Cmpnd_c
{ v.pp = c.pp ;   v.ast = c.ast ; 
  c.context = nothing() ;  
  -- treat c as an expression, there is no inherited expression for it to use.
} 

nonterminal Cmpnd_c with pp, ast<Expr>, context ;  -- same as in v4.2.9 and v6
synthesized attribute cst_Cmpnd_c::Cmpnd_c occurs on Expr ;

concrete production cmpnd_pfld_c
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
nonterminal Sfld_c with pp, ast<Expr>, context ;  -- same as in v4.2.9 and v6
synthesized attribute cst_Sfld_c::Sfld_c occurs on Expr ;

concrete production empty_sfld_c
sf::Sfld_c ::= 
{ sf.pp =  "" ; 
  sf.ast = case sf.context of 
             nothing() -> error ("Should not ask for ast on empty_sfld_c!") 
           | just(e) -> new(e)   -- seem to require the use of new here!
           end ;
}

concrete production dot_sfld_c
sf::Sfld_c ::= d::STOP c::Cmpnd_c 
precedence = 45
{ sf.pp = "." ++ c.pp ; 
  sf.ast = c.ast ;
  c.context = sf.context ; 
}

--Pfld
-- Here, ID may be a field name (of type array) or an expression that names an array.
nonterminal Pfld_c with pp, ast<Expr>, context ;   -- same as in v4.2.9 and v6
synthesized attribute cst_Pfld_c::Pfld_c occurs on Expr ;

concrete production name_pfld_c
pf::Pfld_c ::= id::ID
{ pf.pp = id.lexeme;
  pf.ast = case pf.context of
             nothing() -> varRefExprAll(id)
           | just(e) -> dotAccess(e, id) 
           end ;
}
concrete production expr_pfld_c
pf::Pfld_c ::= id::ID '[' ex::Expr_c ']'
{ pf.pp = id.lexeme ++ "[" ++ ex.pp ++ "]";
  pf.ast = case pf.context of
             nothing() -> arrayAccess(varRefExprAll(id), ex.ast)
           | just(e) -> arrayAccess(dotAccess(e,id), ex.ast)
           end ;
}



--Aname
nonterminal Aname_c with pp, ast<ID> ;   -- same as v4.2.9 and v6
synthesized attribute cst_Aname_c::Aname_c occurs on Expr ; -- really ID !!

concrete production aname_pname_c
an::Aname_c ::= pn::PNAME
{ an.pp = pn.lexeme ;
  an.ast = terminal(ID, pn.lexeme, pn.line, pn.column) ;
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
  an.ast = id ;
}
action
{ -- not sure why we add this to the list either - does this define ID as a PNAME???
  local attribute procid::String;
  procid = id.lexeme;
  pnames = if (!listContains(procid,pnames))
           then [procid] ++ pnames
           else pnames;
}




--Probe
nonterminal Probe_c with pp, ast<Expr> ;   -- same as in v4.2.9 and v6

concrete production full_probe_c
pr::Probe_c ::= fl::FULL '(' vref::Varref_c ')'
{ pr.pp = "full" ++ "(" ++ vref.pp ++ ")";
  pr.ast = fullProbe(vref.ast);
}

concrete production nfull_probe_c
pr::Probe_c ::= nfl::NFULL '(' vref::Varref_c ')'
{ pr.pp = "nfull" ++ "(" ++ vref.pp ++ ")";
  pr.ast = nfullProbe(vref.ast);
}

concrete production empty_probe_c
pr::Probe_c ::= et::EMPTY '(' vref::Varref_c ')' 
{ pr.pp = "empty" ++ "(" ++ vref.pp ++ ")";
  pr.ast = emptyProbe(vref.ast);
}

concrete production nempty_probe_c
pr::Probe_c ::= net::NEMPTY '(' vref::Varref_c ')'
{ pr.pp = "nempty" ++ "(" ++ vref.pp ++ ")";
  pr.ast = nemptyProbe(vref.ast);
}

