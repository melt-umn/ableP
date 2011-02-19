grammar edu:umn:cs:melt:ableP:concretesyntax;

import edu:umn:cs:melt:ableC:terminals 
 only pp
 with pp as ansi_c_pp ;
--syntax edu:umn:cs:melt:ableC:terminals ;

import edu:umn:cs:melt:ableC:concretesyntax 
 only Expr_c, DeclarationList_c, StmtList_c, Root_c
 with Expr_c as Ansi_C_Expr ,
      DeclarationList_c as Ansi_C_DeclarationList ,
      StmtList_c as Ansi_C_StmtList  ; 

--syntax edu:umn:cs:melt:sandbox:ansi_c:concretesyntax ;


-- Productions the embed C code into Promela, the 
-- following have promela nonterminals on the LHS 
-- of the production.
--------------------------------------------------
nonterminal C_Fcts_c with pp ;    -- same in v4.2.9 and v6
concrete production global_ccode_c
st::C_Fcts_c ::= cc::Ccode_c 
{ st.pp = cc.pp ;
-- st.ast_Unit = unit_ccode ( cc.ast_Ccode ) ;
}

concrete production global_cstate_c
st::C_Fcts_c ::= cc::Cstate_c
{ st.pp = cc.pp ;
-- st.ast_Unit = unit_cstate ( cc.ast_CState ) ;
}

-- Cstate 
nonterminal Cstate_c with pp;   -- same as in v4.2.9 and v6
-- cstate in spin.y
--synthesized attribute ast_CState::Cstate occurs on Cstate_c;

concrete production cstate_c
cs::Cstate_c ::= ca::C_STATE str1::STRING str2::STRING
{ cs.pp = "c_state " ++ str1.lexeme ++ str2.lexeme;
-- cs.ast_CState = cstate(str1,str2);
}

concrete production ctrack_c
cs::Cstate_c ::= ct::C_TRACK str1::STRING str2::STRING
{ cs.pp = "c_track " ++ str1.lexeme ++ str2.lexeme;
-- cs.ast_CState = ctrack(str1,str2);
}

concrete production cs_string_c
cs::Cstate_c ::= ca::C_STATE str1::STRING str2::STRING str3::STRING
{ cs.pp = "c_state " ++ str1.lexeme ++ str2.lexeme ++ str3.lexeme;
-- cs.ast_CState = cs_string(str1,str2,str3);
}

concrete production ct_string_c
cs::Cstate_c ::= ct::C_TRACK str1::STRING str2::STRING str3::STRING
{ cs.pp = "c_track " ++ str1.lexeme ++ str2.lexeme ++ str3.lexeme;
-- cs.ast_CState = ct_string(str1,str2,str3);
}


-- Ccode_c
nonterminal Ccode_c  with pp ;    -- same as in v4.2.9 and v6
-- ccode  in spin.y

concrete production ccode_stmt_unit_c
cc::Ccode_c ::= ccode::C_CODE_nt_c
{ cc.pp = ccode.pp ;
-- cc.ast_Ccode = ccode.ast_Ccode ;
}

concrete production ccode_decl_unit_c
cc::Ccode_c ::= cdecl::C_DECL_nt_c
{ cc.pp = cdecl.pp ;
-- cc.ast_Ccode = cdecl.ast_Ccode ;
}


-- Cexpr_c
nonterminal Cexpr_c  with pp ;    -- same as in v4.2.9 and v6
-- cexpr  in spin.y
concrete production cexpr_expr_unit_c 
st::Cexpr_c ::= cc::C_EXPR_nt_c
{ st.pp = cc.pp;
-- st.ast_Cexpr = cc.ast_Cexpr ;
}


-- Embedded C code                              --
--------------------------------------------------
-- Since we parse the embedded C code, we introduce new nonterminals
-- and terminals not found in the spin.y specification.  The new
-- nonterminals are named to keep this specifiation somewhat similar
-- to the original in spin.y.

-- In spin.y, C_CODE, C_DECL, and C_EXPR are terminals.  Here,
-- we create a terminal and nonterminal for each of these
-- For C_CODE, we create 
--   the terminal    C_CODE, which matches /c_code/
--   the nonterminal C_CODE_nt_c which derives strings such as
--       "c_code { int *x; int *y; }"
-- Similar terminals and nonterminals are created for C_DECL and C_EXPR.

nonterminal C_CODE_nt_c with pp ;
nonterminal C_DECL_nt_c with pp ;
nonterminal C_EXPR_nt_c with pp ;
nonterminal Ansi_C_code with pp ;
--synthesized attribute ast_Ccode  ::Ccode  occurs on Ccode_c, C_CODE_nt_c, C_DECL_nt_c;
--synthesized attribute ast_Cstate ::Cstate occurs on Cstate_c;
--synthesized attribute ast_Cexpr  ::Cexpr  occurs on Cexpr_c, C_EXPR_nt_c;
--synthesized attribute ast_Cstuff ::Cstuff occurs on Ansi_C_code ;
--attribute ast_Unit occurs on C_Fcts_c ;



-- The following are introduced because the above two rules in spin.y
-- use the same prep_inline function that the inlining productions use
-- to read the code by some hand-coded method.  We can do better.
concrete production ccode_code_c
st::C_CODE_nt_c ::= kwd::C_CODE '{' cs::Ansi_C_code '}'
{ st.pp = kwd.lexeme ++ " {\n " ++ cs.pp ++ "\n}" ;
-- st.ast_Ccode = ccode_code(kwd, cs.ast_Cstuff ) ;
}

concrete production ccode_expr_code_c
st::C_CODE_nt_c ::= kwd::C_CODE '[' ce::Ansi_C_Expr ']' '{' ccode::Ansi_C_code '}'
{ st.pp = kwd.lexeme ++ " [ " ++ ce.ansi_c_pp ++ " ] { " ++ ccode.pp ++ "}" ;
-- st.ast_Ccode = ccode_expr_code (kwd, cstuff(ce.ansi_c_pp), ccode.ast_Cstuff) ;
}

concrete production ccode_decl_c
st::C_DECL_nt_c ::= kwd::C_DECL '{' cd::Ansi_C_DeclarationList '}' 
{ st.pp = kwd.lexeme ++ " {\n " ++ cd.ansi_c_pp ++ "\n}" ;
-- st.ast_Ccode = ccode_decl(kwd, cstuff(cd.ansi_c_pp) );
}






-- as above, the prev. production uses the prep_inline function to
-- read the C code using hand written code, so it is not in the rules.
-- We have the following rules to do a better job.
concrete production cexpr_code_c
ce::C_EXPR_nt_c ::= kwd::C_EXPR '{' code::Ansi_C_code  '}'
{ ce.pp = kwd.lexeme ++ " { " ++ code.pp ++ " } " ;
-- ce.ast_Cexpr = cexpr_code (kwd, code.ast_Cstuff ) ;
}

concrete production cexpr_code_expr_c
ce::C_EXPR_nt_c ::= kwd::C_EXPR '{' e::Ansi_C_Expr  '}'
{ ce.pp = kwd.lexeme ++ " { " ++ e.ansi_c_pp ++ " } " ;
-- ce.ast_Cexpr = cexpr_code (kwd, cstuff(e.ansi_c_pp) ) ;
}

concrete production cexpr_expr_code_c
ce::C_EXPR_nt_c ::= kwd::C_EXPR '[' e::Ansi_C_Expr ']' '{' code::Ansi_C_code '}'
{ ce.pp     = kwd.lexeme ++ " [ " ++ e.ansi_c_pp ++ " ] { " ++ code.pp ++ "}";
-- ce.ast_Cexpr = cexpr_expr_code (kwd, cstuff(e.ansi_c_pp), code.ast_Cstuff ) ;
}


-- I think the following are define in the C concrete syntax but
-- I need to verify that.

-- Ansi C code                                  --
--------------------------------------------------
concrete production ansi_ccode_decl_stmt_c
c::Ansi_C_code ::= dcls::Ansi_C_DeclarationList stmt::Ansi_C_StmtList
{ c.pp = dcls.ansi_c_pp  ++ " " ++ stmt.ansi_c_pp ;
-- c.ast_Cstuff = cstuff (c.pp);
}

concrete production ansi_ccode_decl_c
c::Ansi_C_code ::= dcls::Ansi_C_DeclarationList
{ c.pp = dcls.ansi_c_pp ;
-- c.ast_Cstuff = cstuff (c.pp);
}

concrete production ansi_ccode_stmt_c
c::Ansi_C_code ::= stmt::Ansi_C_StmtList
{ c.pp = stmt.ansi_c_pp ;
-- c.ast_Cstuff = cstuff (c.pp);
}

concrete production ansi_ccode_empty_c
c::Ansi_C_code ::=
{ c.pp = "" ;
-- c.ast_Cstuff = cstuff(c.pp);
}


--- To avoid useless production errors!
terminal BOGUS_C_ROOT_t '!!!!!!BOGUSCROOT' ;
concrete production bogus_C_Root
p::Program_c ::= t::BOGUS_C_ROOT_t cr::Root_c
{ p.pp = "BOGUS C ROOT" ; }







