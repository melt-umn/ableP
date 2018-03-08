grammar edu:umn:cs:melt:ableP:host:core:concretesyntax;

attribute pp, ppi, ast<Stmt> occurs on Stmt_c ;

aspect production special_stmt_c
stmt::Stmt_c ::= sc::Special_c
{ stmt.pp = sc.pp;
  sc.ppi = stmt.ppi;
  stmt.ast = sc.ast;
}

aspect production statement_stmt_c
stmt::Stmt_c ::= st::Statement_c
{ stmt.pp = st.pp;
  st.ppi = stmt.ppi;
  stmt.ast = st.ast;
}


--Special
attribute pp, ppi, ast<Stmt> occurs on Special_c ;

aspect production rcv_special_c
sc::Special_c ::= vref::Varref_c '?' ra::RArgs_c
{ sc.pp = vref.pp ++ "?" ++ ra.pp;
  sc.ast = rcvStmt(vref.ast, "?", ra.ast);   }

aspect production snd_special_c
sc::Special_c ::= vref::Varref_c '!' ma::MArgs_c
{ sc.pp = vref.pp ++ "!" ++ ma.pp;
  sc.ast = sndStmt (vref.ast, "!", ma.ast);   }

aspect production if_special_c
sc::Special_c ::= i::IF op::Options_c fi::FI
{ sc.pp =  "if " ++ op.pp ++ "\n" ++ sc.ppi ++ "fi";
  op.ppi = "   " ++ sc.ppi;
  sc.ast = ifStmt(op.ast);
}

aspect production do_special_c
sc::Special_c ::= d::DO op::Options_c o::OD
{ sc.pp =  "do " ++ op.pp ++ "\n" ++ sc.ppi ++ "od";
  op.ppi = "   " ++ sc.ppi;
  sc.ast = doStmt(op.ast);
}

aspect production break_special_c
sc::Special_c ::= b::BREAK
{ sc.pp = "break";
  sc.ast = breakStmt();
}

aspect production goto_special_c
sc::Special_c ::= g::GOTO id::ID
{ sc.pp = "goto " ++ id.lexeme;
  sc.ast = gotoStmt(id);
}

aspect production stmt_special_c
sc::Special_c ::= id::ID ':' st::Stmt_c
{ sc.pp = id.lexeme ++ ":" ++ st.ppi ++ st.pp;
  st.ppi = sc.ppi;
  sc.ast = labeledStmt(id,st.ast);
}

-- Statement
attribute pp, ppi, ast<Stmt> occurs on Statement_c ;

aspect production assign_stmt_c
st::Statement_c ::= vref::Varref_c op::'=' exp::Expr_c
{ st.pp = vref.pp ++ " = " ++ exp.pp ;
  st.ast = assign(vref.ast, op, exp.ast) ;
}

aspect production incr_stmt_c
st::Statement_c ::= vref::Varref_c inc::INCR
{ st.pp = vref.pp ++ " ++";
  st.ast = incrStmt(vref.ast);
}

aspect production decr_stmt_c
st::Statement_c ::= vref::Varref_c de::DECR
{ st.pp = vref.pp ++ " --";
  st.ast = decrStmt(vref.ast);
}

aspect production print_stmt_c
st::Statement_c ::= pr::PRINTF '(' str::STRING par::PrArgs_c ')'
{ st.pp = "printf" ++ "(" ++ str.lexeme ++ par.pp  ++ ")";
  st.ast = printStmt (str.lexeme ,par.ast);
}

aspect production printm_stmt_c
st::Statement_c ::= pr::PRINTM '(' vref::Varref_c ')'
{ st.pp = "printm" ++ "(" ++ vref.pp ++ ")" ;
  st.ast = printmStmt(vref.ast);
}

aspect production printm_const_c
st::Statement_c ::= pr::PRINTM '(' cn::CONST ')'
{ st.pp = "printm" ++ "(" ++ cn.lexeme ++ ")";
  st.ast = printmConstStmt(cn);
}

aspect production assert_stmt_c
st::Statement_c ::= ast::ASSERT fe::FullExpr_c
{ st.pp = "assert " ++ fe.pp;
  st.ast = assertStmt(fe.ast);
}

aspect production rrcv_stmt_c
st::Statement_c ::= vref::Varref_c r::R_RCV ra::RArgs_c
{ st.pp = vref.pp ++ " ?? " ++ ra.pp;
  st.ast = rcvStmt(vref.ast, "??", ra.ast);   }

aspect production rcv_stmt_c
st::Statement_c ::= vref::Varref_c r::RCV '<' ra::RArgs_c '>'
{ st.pp = vref.pp ++ " ? <" ++ ra.pp ++ ">";
  st.ast = rcvStmt(vref.ast, "?<>", ra.ast);   }

aspect production rrcv_poll_c
st::Statement_c ::= vref::Varref_c rr::R_RCV '<' ra::RArgs_c '>' 
{ st.pp = vref.pp ++ " ?? <" ++ ra.pp ++ ">";
  st.ast = rcvStmt(vref.ast, "??<>", ra.ast);   }

aspect production snd_stmt_c
st::Statement_c ::= vref::Varref_c '!!' ma::MArgs_c
{ st.pp = vref.pp ++ " !! " ++ ma.pp;
  st.ast = sndStmt(vref.ast, "!!", ma.ast);   }


aspect production fullexpr_stmt_c
st::Statement_c ::= fe::FullExpr_c
{ st.pp = fe.pp ;
  st.ast = exprStmt(fe.ast);
}

aspect production else_stmt_c
st::Statement_c ::= el::ELSE
{ st.pp = "else";
  st.ast = elseStmt();
}

aspect production atomic_stmt_c
st::Statement_c ::= at::ATOMIC '{' seq::Sequence_c os::OS_c '}'
{ st.pp = "atomic {\n" ++ seq.ppi ++ seq.pp ++ os.pp ++ "\n" ++ st.ppi ++ "}";
  seq.ppi = "  " ++ st.ppi;
  st.ast = atomicStmt( seq.ast );
}

aspect production step_stmt_c
st::Statement_c ::= ds::D_STEP '{' seq::Sequence_c os::OS_c '}'
{ st.pp =  "d_step {\n" ++ seq.ppi ++ seq.pp ++ os.pp ++ "\n" ++ st.ppi ++ "}";
  seq.ppi = "  " ++ st.ppi;
  st.ast = dstepStmt( seq.ast );
}

aspect production seq_stmt_c
st::Statement_c ::= '{' seq::Sequence_c os::OS_c '}'
{ st.pp =   "{ " ++ seq.pp ++ os.pp ++ "\n" ++ st.ppi ++ "}";
  seq.ppi = "  " ++ st.ppi;
  st.ast = blockStmt (seq.ast ) ;
}


-- OK for v6 and v4.2.9, but see discussion of the interesting way Spin does this.
aspect production inline_stmt_c
st::Statement_c ::= ina::INAME '(' args::Args_c ')' 
{ st.pp = ina.lexeme ++ "(" ++ args.pp ++ ")" ;
  st.ast = inlineStmt(ina, args.ast);
}

aspect production skip_stmt_c
st::Statement_c ::= sk::SKIP
{ st.pp = "skip";
  st.ast = skipStmt();
}

--Options
attribute pp, ppi, ast<Options> occurs on Options_c ;

aspect production single_option_c
ops::Options_c ::= op::Option_c
{ ops.pp =  op.pp;
  op.ppi = ops.ppi ;
  ops.ast = oneOption(op.ast);
}

aspect production cons_option_c
ops::Options_c ::= op::Option_c rest::Options_c
{ ops.pp =  op.pp ++ "\n" ++ ops.ppi ++ rest.pp;
  op.ppi = ops.ppi;
  rest.ppi = ops.ppi;
  ops.ast = consOption(op.ast,rest.ast);
}


--Option
attribute pp, ppi, ast<Stmt> occurs on Option_c ;

aspect production op_seq_c
op::Option_c ::= '::' seq::Sequence_c os::OS_c
{ op.pp =  ":: " ++ seq.pp ++ os.pp;
  seq.ppi = "   " ++ op.ppi ;
  op.ast = seq.ast ;
}

