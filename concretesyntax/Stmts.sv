grammar edu:umn:cs:melt:ableP:concretesyntax;

--Stmt is stmnt in the given promela grammar
--Stmt 
-- Stmt = stmnt
-- Statement = Stmnt

nonterminal Stmt_c with pp, ppi, ast<Stmt> ;    -- same as in v4.2.9 and v6

concrete production special_stmt_c
stmt::Stmt_c ::= sc::Special_c
{ stmt.pp = sc.pp;
  sc.ppi = stmt.ppi;
  stmt.ast = sc.ast;
}

concrete production statement_stmt_c
stmt::Stmt_c ::= st::Statement_c
{ stmt.pp = st.pp;
  st.ppi = stmt.ppi;
  stmt.ast = st.ast;
}


--Special
nonterminal Special_c  -- same as in v4.2.9, needs for and select exts for v6
  with pp, ppi, ast<Stmt>;

concrete production rcv_special_c
sc::Special_c ::= vref::Varref_c '?' ra::RArgs_c
{ sc.pp = vref.pp ++ "?" ++ ra.pp;
  sc.ast = rcvStmt(vref.ast, "?", ra.ast);   }

concrete production snd_special_c
sc::Special_c ::= vref::Varref_c '!' ma::MArgs_c
{ sc.pp = vref.pp ++ "!" ++ ma.pp;
  sc.ast = sndStmt (vref.ast, "!", ma.ast);   }

concrete production if_special_c
sc::Special_c ::= i::IF op::Options_c fi::FI
{ sc.pp = "if\n" ++ op.pp ++ "\n" ++ sc.ppi ++ "fi";
  op.ppi = sc.ppi;
  sc.ast = ifStmt(op.ast);
}

concrete production do_special_c
sc::Special_c ::= d::DO op::Options_c o::OD
{ sc.pp = "do\n" ++ op.pp ++ "\n" ++ sc.ppi ++ "od";
  op.ppi = sc.ppi;
  sc.ast = doStmt(op.ast);
}

concrete production break_special_c
sc::Special_c ::= b::BREAK
{ sc.pp = "break";
  sc.ast = breakStmt();
}

concrete production goto_special_c
sc::Special_c ::= g::GOTO id::ID
{ sc.pp = "goto " ++ id.lexeme;
  sc.ast = gotoStmt(id);
}

concrete production stmt_special_c
sc::Special_c ::= id::ID ':' st::Stmt_c
{ sc.pp = id.lexeme ++ ":" ++ st.ppi ++ st.pp;
 st.ppi = sc.ppi;
 sc.ast = labeledStmt(id,st.ast);
}

--
--Statement
nonterminal Statement_c with pp, ppi, ast<Stmt> ;   -- same as v4.2.9 and v6

concrete production assign_stmt_c
st::Statement_c ::= vref::Varref_c '=' exp::Expr_c
{ st.pp = vref.pp ++ "=" ++ exp.pp ;
  st.ast = assign(vref.ast, exp.ast) ;
}

concrete production incr_stmt_c
st::Statement_c ::= vref::Varref_c inc::INCR
{ st.pp = vref.pp ++ "++";
--  st.ast_Stmt = incr_stmt(vref.ast_Expr);
}

concrete production decr_stmt_c
st::Statement_c ::= vref::Varref_c de::DECR
{ st.pp = vref.pp ++ "--";
--  st.ast_Stmt = decr_stmt(vref.ast_Expr);
}

concrete production print_stmt_c
st::Statement_c ::= pr::PRINTF '(' str::STRING par::PrArgs_c ')'
{ st.pp = "printf" ++ "(" ++ str.lexeme ++ par.pp  ++ ")";
  st.ast = printStmt (str.lexeme ,par.ast);
}

concrete production printm_stmt_c
st::Statement_c ::= pr::PRINTM '(' vref::Varref_c ')'
{ st.pp = "printm" ++ "(" ++ vref.pp ++ ")" ;
  st.ast = printmStmt(vref.ast);
}

concrete production printm_const_c
st::Statement_c ::= pr::PRINTM '(' cn::CONST ')'
{ st.pp = "printm" ++ "(" ++ cn.lexeme ++ ")";
  st.ast = printmConstStmt(cn);
}

concrete production assert_stmt_c
st::Statement_c ::= ast::ASSERT fe::FullExpr_c
{ st.pp = "assert " ++ fe.pp;
-- st.ast_Stmt = assert_stmt(fe.ast_Expr);
}

concrete production ccode_stmt_new_c
st::Statement_c ::= cc::Ccode_c 
{ st.pp = cc.pp ;
-- st.ast_Stmt = stmt_ccode(cc.ast_Ccode) ;
-- st.ifordo = false;
}

concrete production rrcv_stmt_c
st::Statement_c ::= vref::Varref_c r::R_RCV ra::RArgs_c
{ st.pp = vref.pp ++ "??" ++ ra.pp;
  st.ast = rcvStmt(vref.ast, "??", ra.ast);   }

concrete production rcv_stmt_c
st::Statement_c ::= vref::Varref_c r::RCV '<' ra::RArgs_c '>'
{ st.pp = vref.pp ++ "? <" ++ ra.pp ++ ">";
  st.ast = rcvStmt(vref.ast, "?<>", ra.ast);   }

concrete production rrcv_poll_c
st::Statement_c ::= vref::Varref_c rr::R_RCV '<' ra::RArgs_c '>' 
{ st.pp = vref.pp ++ "?? <" ++ ra.pp ++ ">";
  st.ast = rcvStmt(vref.ast, "??<>", ra.ast);   }

concrete production snd_stmt_c
st::Statement_c ::= vref::Varref_c '!!' ma::MArgs_c
{ st.pp = vref.pp ++ "!!" ++ ma.pp;
  st.ast = sndStmt(vref.ast, "!!", ma.ast);   }


concrete production fullexpr_stmt_c
st::Statement_c ::= fe::FullExpr_c
{ st.pp = fe.pp ;
  st.ast = exprStmt(fe.ast);
}

concrete production else_stmt_c
st::Statement_c ::= el::ELSE
{ st.pp = "else";
  st.ast = elseStmt();
}

concrete production atomic_stmt_c
st::Statement_c ::= at::ATOMIC '{' seq::Sequence_c os::OS_c '}'
{ st.pp = "atomic" ++ "\n{\n " ++ seq.ppi ++ seq.pp ++ os.pp ++ " \n}";
  seq.ppi = st.ppi;
-- st.ast_Stmt = atomic_stmt( body_stmts(seq.ast_Stmt));
}

concrete production step_stmt_c
st::Statement_c ::= ds::D_STEP '{' seq::Sequence_c os::OS_c '}'
{ st.pp =  "d_step" ++ "\n{\n " ++ seq.ppi ++ seq.pp ++ os.pp ++ " \n}";
  seq.ppi = st.ppi;
-- st.ast_Stmt = dstep_stmt( body_stmts(seq.ast_Stmt));
}

concrete production seq_stmt_c
st::Statement_c ::= '{' seq::Sequence_c os::OS_c '}'
{ st.pp = "{\n " ++ seq.ppi ++ seq.pp ++ os.pp ++ " \n}";
  seq.ppi = st.ppi;
-- st.ast_Stmt = stmt_block( body_stmts( seq.ast_Stmt ) ) ;
}


-- OK for v6 and v4.2.9, but see discussion of the screwy way Spin does this.
concrete production inline_stmt_c
st::Statement_c ::= ina::INAME '(' args::Args_c ')' 
{ st.pp = ina.lexeme ++ "(" ++ args.pp ++ ")" ;
-- st.ast_Stmt = inline_stmt(ina,args.ast_Args);
}

concrete production skip_stmt_c
st::Statement_c ::= sk::SKIP
{ st.pp = "skip";
  st.ast = skipStmt();
}

--Options
nonterminal Options_c with pp, ppi, ast<Options> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_Options_c::Options_c occurs on Options ;

concrete production single_option_c
ops::Options_c ::= op::Option_c
{ ops.pp =  ops.ppi ++ op.pp;
  op.ppi = ops.ppi ;
  ops.ast = oneOption(op.ast);
}

concrete production cons_option_c
ops::Options_c ::= op::Option_c rest::Options_c
{ ops.pp =  ops.ppi ++  op.pp ++ "\n" ++ rest.pp;
  op.ppi = ops.ppi;
  rest.ppi = ops.ppi;
  ops.ast = consOption(op.ast,rest.ast);
}


--Option
nonterminal Option_c with pp, ppi, ast<Stmt> ;    -- same as in v4.2.9 and v6
synthesized attribute cst_Option_c::Option_c occurs on Stmt ;

concrete production op_seq_c
op::Option_c ::= '::' seq::Sequence_c os::OS_c
{ op.pp =  "::" ++ seq.ppi ++ seq.pp ++ os.pp;
  seq.ppi = op.ppi ++ "";
  op.ast = seq.ast ;
}

