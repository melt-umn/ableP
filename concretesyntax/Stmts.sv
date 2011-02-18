grammar edu:umn:cs:melt:ableP:concretesyntax;

--Stmt is stmnt in the given promela grammar
--Stmt 
-- Stmt = stmnt
-- Statement = Stmnt

nonterminal Stmt_c with pp, ppi;

--synthesized attribute ast_Stmt :: Stmt ;
--attribute ast_Stmt occurs on Stmt_c,Special_c;


concrete production special_stmt_c
stmt::Stmt_c ::= sc::Special_c
{ stmt.pp = sc.pp;
  sc.ppi = stmt.ppi;
--  stmt.ast_Stmt = sc.ast_Stmt;
}

concrete production statement_stmt_c
stmt::Stmt_c ::= st::Statement_c
{ stmt.pp = st.pp;
  st.ppi = stmt.ppi;
--  stmt.ast_Stmt = st.ast_Stmt;
}


--Special

nonterminal Special_c with pp, ppi;

concrete production rcv_special_c
sc::Special_c ::= vref::Varref_c '?' ra::RArgs_c
{ sc.pp = vref.pp ++ "?" ++ ra.pp;
--  sc.ast_Stmt = rcv_special(vref.ast_Expr,ra.ast_RArgs);
}

concrete production snd_special_c
sc::Special_c ::= vref::Varref_c '!' ma::MArgs_c
{ sc.pp = vref.pp ++ "!" ++ ma.pp;
-- sc.ast_Stmt = snd_special(vref.ast_Expr,ma.ast_MArgs);
}



concrete production if_special_c
sc::Special_c ::= i::IF op::Options_c fi::FI
{ sc.pp = "if\n" ++ op.pp ++ "\n" ++ sc.ppi ++ "fi";
  op.ppi = sc.ppi;
--  sc.ast_Stmt = if_special(op.ast_Options);
}


concrete production do_special_c
sc::Special_c ::= d::DO op::Options_c o::OD
{ sc.pp = "do\n" ++ op.pp ++ "\n" ++ sc.ppi ++ "od";
  op.ppi = sc.ppi;
--  sc.ast_Stmt = do_special(op.ast_Options);
}

concrete production break_special_c
sc::Special_c ::= b::BREAK
{ sc.pp = "break";
--  sc.ast_Stmt = break_special();
}

concrete production goto_special_c
sc::Special_c ::= g::GOTO id::ID
{ sc.pp = "goto " ++ id.lexeme;
--  sc.ast_Stmt = goto_special(id);
}

concrete production stmt_special_c
sc::Special_c ::= id::ID ':' st::Stmt_c
{ sc.pp = id.lexeme ++ ":" ++ st.ppi ++ st.pp;
 st.ppi = sc.ppi;
-- sc.ast_Stmt = stmt_special(id,st.ast_Stmt);
}

--
--Statement

nonterminal Statement_c with pp, ppi;

concrete production assign_stmt_c
st::Statement_c ::= vref::Varref_c a1::ASGN exp::Expr_c
{ st.pp = vref.pp ++ "=" ++ exp.pp;
--  st.ast_Stmt = assign_stmt(vref.ast_Expr,a1,exp.ast_Expr);
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
-- st.ast_Stmt = print_stmt(str,par.ast_Args);
}

concrete production printm_stmt_c
st::Statement_c ::= pr::PRINTM '(' vref::Varref_c ')'
{ st.pp = "printm" ++ "(" ++ vref.pp ++ ")" ;
-- st.ast_Stmt = printm_stmt(vref.ast_Expr);
}

concrete production printm_const_c
st::Statement_c ::= pr::PRINTM '(' cn::CONST ')'
{ st.pp = "printm" ++ "(" ++ cn.lexeme ++ ")";
-- st.ast_Stmt = printm_const(cn);
}

concrete production assert_stmt_c
st::Statement_c ::= ast::ASSERT fe::FullExpr_c
{ st.pp = "assert " ++ fe.pp;
-- st.ast_Stmt = assert_stmt(fe.ast_Expr);
}


concrete production rrcv_stmt_c
st::Statement_c ::= vref::Varref_c r::R_RCV ra::RArgs_c
{ st.pp = vref.pp ++ "??" ++ ra.pp;
-- st.ast_Stmt = rrcv_stmt(vref.ast_Expr,ra.ast_RArgs);
}

concrete production rcv_stmt_c
st::Statement_c ::= vref::Varref_c r::RCV '<' ra::RArgs_c '>'
{ st.pp = vref.pp ++ "? <" ++ ra.pp ++ ">";
-- st.ast_Stmt = rcv_stmt(vref.ast_Expr,ra.ast_RArgs);
}

concrete production rrcv_poll_c
st::Statement_c ::= vref::Varref_c rr::R_RCV '<' ra::RArgs_c '>' 
{ st.pp = vref.pp ++ "?? <" ++ ra.pp ++ ">";
-- st.ast_Stmt = rrcv_poll(vref.ast_Expr,ra.ast_RArgs);
}

concrete production snd_stmt_c
st::Statement_c ::= vref::Varref_c '!!' ma::MArgs_c
{ st.pp = vref.pp ++ "!!" ++ ma.pp;
-- st.ast_Stmt = snd_stmt(vref.ast_Expr,ma.ast_MArgs);
}


concrete production fullexpr_stmt_c
st::Statement_c ::= fe::FullExpr_c
{ st.pp = fe.pp ;
-- st.ast_Stmt = fullexpr_stmt(fe.ast_Expr);
}

concrete production else_stmt_c
st::Statement_c ::= el::ELSE
{ st.pp = "else";
-- st.ast_Stmt = else_stmt();
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

concrete production inline_stmt_c
st::Statement_c ::= ina::INAME '(' args::Args_c ')' 
{ st.pp = ina.lexeme ++ "(" ++ args.pp ++ ")" ;
-- st.ast_Stmt = inline_stmt(ina,args.ast_Args);
}


--Options

nonterminal Options_c with pp, ppi ;
--synthesized attribute ast_Options::Options occurs on Options_c;

concrete production single_option_c
ops::Options_c ::= op::Option_c
{ ops.pp =  ops.ppi ++ op.pp;
  op.ppi = ops.ppi ;
-- ops.ast_Options = single_option(op.ast_Stmt);
}

concrete production cons_option_c
ops1::Options_c ::= op::Option_c ops2::Options_c
{ ops1.pp =  ops1.ppi ++  op.pp ++ "\n" ++ ops2.pp;
  op.ppi = ops1.ppi;
  ops2.ppi = ops1.ppi;
-- ops1.ast_Options = cons_option(op.ast_Stmt,ops2.ast_Options);
}


--Option

nonterminal Option_c with pp, ppi; --, ast_Stmt ;

concrete production op_seq_c
op::Option_c ::= '::' seq::Sequence_c os::OS_c
{ op.pp =  "::" ++ seq.ppi ++ seq.pp ++ os.pp;
  seq.ppi = op.ppi ++ "";
-- op.ast_Stmt = seq.ast_Stmt;
}

