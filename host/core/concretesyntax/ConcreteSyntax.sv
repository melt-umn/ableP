{- 
The concrete syntax grammar for Promela in ableP is derived from the
Yacc grammar in the SPIN distribution.  Since SPIN is copyrighted by
Lucent Technologies and Bell Laboratories we do not distribute these
derivations under the GNU LGPL.  These files retain the original
licensing and copyright designations, given below:

/* Copyright (c) 1989-2003 by Lucent Technologies, Bell Laboratories.     */
/* All Rights Reserved.  This software is for educational purposes only.  */
/* No guarantee whatsoever is expressed or implied by the distribution of */
/* this code.  Permission is given to distribute this code provided that  */
/* this introductory message is not removed and no monies are exchanged.  */
/* Software written by Gerard J. Holzmann.  For tool documentation see:   */
/*             http://spinroot.com/                                       */
-}

grammar edu:umn:cs:melt:ableP:host:core:concretesyntax ;

imports edu:umn:cs:melt:ableP:host:core:terminals ;

-- All productions in this file are derived from the spin.y grammar
-- and have the same form as in v4.2.9 and v6.

nonterminal Program_c ;  -- program
concrete productions p::Program_c
(program_c) | u::Units_c  { }
 
nonterminal Units_c ;   -- units
concrete productions us::Units_c
(units_one_c)  | u::Unit_c  { }
(units_snoc_c) | us2::Units_c u::Unit_c   { }

nonterminal Unit_c ; -- unit
concrete productions u::Unit_c
(unit_proc_c)     | p::Proc_c   { } action { usedProcess = 0; }
(unit_init_c)     | i::Init_c   { }
(unit_claim_c)    | c::Claim_c   { }
-- Unit_c production for LTL formulas in host:extensions:v6 grammar
(unit_events_c)   | e::Events_c  { }
(unit_one_decl_c) | dec::OneDecl_c  { }
(unit_utype_c)    | ut::Utype_c  { }
(unit_ns_c)       | ns::NS_c  { } action { usedInline = 1; }
(unit_semi_c)     | se::SEMI  { }

nonterminal Proc_c ; -- proc
concrete production proc_decl_c
proc::Proc_c ::= i::Inst_c procty::ProcType_c nm::ID 
                 '(' dcl::Decl_c ')'
                 optpri::OptPriority_c optena::OptEnabler_c b::Body_c
{ } action { pnames = addToList( nm.lexeme, pnames);  usedProcess = 1; }

nonterminal ProcType_c ;  -- proctype
concrete productions procty::ProcType_c
(just_procType_c) | pt::PROCTYPE  { }
(d_procType_c)    | dpt::D_PROCTYPE  { }


nonterminal Inst_c ;  -- inst
concrete productions i::Inst_c
(empty_inst_c)       | {-empty-}  { }
(active_inst_c)      | a::ACTIVE  { }
(activeconst_inst_c) | a::ACTIVE '[' ct::CONST ']'  { }
(activename_inst_c)  | a::ACTIVE '[' id::ID ']'  { }


nonterminal Init_c ;   -- init
concrete productions i::Init_c
(init_c) | it::INIT op::OptPriority_c body::Body_c  { }


-- LTL productions for spin.y nonterminals 'ltl' and 'ltl_body' are in
-- host:extensions:v6


nonterminal Claim_c ; -- claim
concrete productions c::Claim_c
(claim_c) | ck::CLAIM body::Body_c  { }  
-- This is the v4.2. version.  The named version is in
-- host:extensions:v6 to be v6 compatible


-- ToDo - missing optname and optname2 productions ???


nonterminal Events_c ;  --  events
concrete productions e::Events_c
(events_c) | tr::TRACE body::Body_c  { }


nonterminal Utype_c ;  -- utype
concrete productions u::Utype_c
(utype_dcllist_c) | td::TYPEDEF id::ID '{' dl::DeclList_c '}'  { }
    action { unames = addToList( id.lexeme, unames); }

{- We do things differently because the Spin parser actually reads the
   statements in the definition of an inlined unit using a procedure
   so that the Statements aren't seen in the parse rule of the
   definition.  This text is then inserted into the input stream so
   that they can be parsed by the Statements nonterminal that is in
   the inline use.

   We do not use this technique and include the statements in the
   inline declaratin as part of the production for the declaration.
   This is a more traditional solution.

   This grammar also differs from spin.y in that we use InlineArgc_s
   below and not 'args' as in spin.y.  This new nonterminal and its
   productions below ensure that only names occur in this list.

-}
nonterminal NM_c ;  -- nm
parser attribute stringOnNM :: String action { stringOnNM = "" ; } ;
concrete productions nm::NM_c
(nameNM_c)  | n::ID     { }  action { stringOnNM = n.lexeme ; } 
(unameNM_c) | n::UNAME  { }  action { stringOnNM = n.lexeme ; } 


nonterminal NS_c ;  -- ns  
concrete production inline_dcl_iname_c
ns::NS_c ::= il::INLINE nm::NM_c '(' args::InlineArgs_c ')' stmt::Statement_c
{ } action { inames = addToList( stringOnNM, inames); }

nonterminal InlineArgs_c ;
concrete productions a::InlineArgs_c
(inline_args_none_c) |  { }
(inline_args_one_c)  | id::ID  { }
(inline_args_cons_c) | id::ID ',' rest::InlineArgs_c  { }


-- Productions for embedding C code for spin.y nonterminals 'c_fcts',
-- 'cstate', 'ccode' and 'cexpr' are in host:extensions:embeddedC


nonterminal Body_c ; -- body
concrete productions b::Body_c
(body_statements_c) | '{' s::Sequence_c os::OS_c '}'  { }


nonterminal Sequence_c ;   -- sequence
concrete productions s::Sequence_c
(single_step_c) | st::Step_c  { }
(cons_step_c)   | s2::Sequence_c ms::MS_c st::Step_c  { }


nonterminal Step_c ;  -- step
concrete productions s::Step_c
(one_decl_c) | od::OneDecl_c  { }
(step_stamt_c) | st::Stmt_c  { }
(vref_lst_c) | xu::XU vlst::VrefList_c  { }
(name_od_c)  | id::ID ':' od::OneDecl_c  { }
(name_xu_c)  | id::ID ':' xu::XU  { }
(unless_c)   | st1::Stmt_c un::UNLESS st2::Stmt_c  { }


nonterminal Vis_c ;  -- vis
concrete productions v::Vis_c
(vis_empty_c)   | {-empty-}   { }
(vis_hidden_c)  | h::HIDDEN   { }
(vis_show_c)    | s::SHOW     { }
(vis_islocal_c) | i::ISLOCAL  { }


nonterminal Asgn_c ;    -- asgn
concrete productions a::Asgn_c
(oneAsgn_c) | at::ASGN    { }
(noAsgn_c)  | {-empty-}    { }


nonterminal OneDecl_c ;   -- one_decl
concrete productions d::OneDecl_c
(varDcls_c)      | v::Vis_c t::Type_c vars::VarList_c  { }
(typeDclUNAME_c) | v::Vis_c u::UNAME vars::VarList_c  { }
(typenameDcl_c)  | v::Vis_c t::Type_c a::Asgn_c '{' names::IDList_c '}'  { }


nonterminal DeclList_c ;    -- decl_lst
concrete productions dcls::DeclList_c
(single_Decl_c) | dcl::OneDecl_c  { }
(multi_Decl_c)  | dcl::OneDecl_c s::SEMI rest::DeclList_c  { }


nonterminal Decl_c ;   -- decl
concrete productions dcl::Decl_c
(empty_Decl_c) | {-empty-}  { }
(decllist_c) | dcllist::DeclList_c  { }


nonterminal VrefList_c ;   -- vref_lst
concrete productions vrl::VrefList_c
(single_varref_c) | vref::Varref_c  { }
(comma_varref_c)  | vref::Varref_c ',' rest::VrefList_c  { }


nonterminal VarList_c ;   -- var_list
concrete productions vl::VarList_c
(one_var_c)  | iv::IVar_c    { }
(cons_var_c)  | iv::IVar_c ',' rest::VarList_c    { }

nonterminal IVar_c ;   -- ivar
concrete productions iv::IVar_c
(ivar_vardcl_c)                | vd::VarDcl_c   { }
(ivar_vardcl_assign_expr_c)    | vd::VarDcl_c a::ASGN e::Expr_c  { }
(ivar_vardcl_assign_ch_init_c) | vd::VarDcl_c a::ASGN ch::ChInit_c  { }


nonterminal ChInit_c ;   -- ch_init
concrete productions ch::ChInit_c
(ch_init_c) | '[' c::CONST ']' o::OF '{' tl::TypList_c '}'  { }

nonterminal VarDcl_c ;   -- vardcl
concrete productions vd::VarDcl_c
(vd_id_c)      | id::ID  { }
(vd_idconst_c) | id::ID ':' cnt::CONST  { }
(vd_array_c)   | id::ID '[' cnt::CONST ']'  { }


nonterminal Varref_c ;  -- varref
concrete productions v::Varref_c
(varref_cmpnd_c) | c::Cmpnd_c  { } 


nonterminal Pfld_c ;   -- pfld
concrete productions pf::Pfld_c
(name_pfld_c) | id::ID  { }
(expr_pfld_c) | id::ID '[' ex::Expr_c ']'  { }


nonterminal Cmpnd_c ;  -- cmpdn
concrete productions c::Cmpnd_c
(cmpnd_pfld_c) | p::Pfld_c s::Sfld_c  { }


nonterminal Sfld_c ;  -- sfld
concrete productions sf::Sfld_c
(empty_sfld_c) | {-empty-}  { }
(dot_sfld_c)   | d::STOP c::Cmpnd_c  precedence = 45 { }


nonterminal Stmt_c ;    -- stmnt
concrete productions stmt::Stmt_c
(special_stmt_c)   | sc::Special_c  { }
(statement_stmt_c) | st::Statement_c  { }


-- Productions in spin.y for nonterminals 'for_pre' and 'for_post' are
-- in host:extensions:v6


nonterminal Special_c ;  -- Special
concrete productions sc::Special_c
(rcv_special_c)   | vref::Varref_c '?' ra::RArgs_c  { }
(snd_special_c)   | vref::Varref_c '!' ma::MArgs_c  { }
-- Productions for the for-loop and select statements in spin.y for
-- nonterminal 'Special' are in host:extensions:v6
(if_special_c)    | i::IF op::Options_c f::FI  { }
(do_special_c)    | d::DO op::Options_c o::OD  { }
(break_special_c) | b::BREAK  { }
(goto_special_c)  | g::GOTO id::ID  { }
(stmt_special_c)  | id::ID ':' st::Stmt_c  { }


nonterminal Statement_c ;   -- Stmnt
concrete productions st::Statement_c
(assign_stmt_c) | vref::Varref_c '=' exp::Expr_c  { }
(incr_stmt_c)   | vref::Varref_c inc::INCR  { }
(decr_stmt_c)   | vref::Varref_c de::DECR  { }
(print_stmt_c)  | pr::PRINTF '(' str::STRING par::PrArgs_c ')'  { }
(printm_stmt_c) | pr::PRINTM '(' vref::Varref_c ')'  { }
(printm_const_c)| pr::PRINTM '(' cn::CONST ')'  { }
(assert_stmt_c) | ast::ASSERT fe::FullExpr_c  { }
-- Production for embedded C code (deriving ccode) is in the
-- host:extensions:embeededC grammar
(rrcv_stmt_c)   | vref::Varref_c r::R_RCV ra::RArgs_c  { }
(rcv_stmt_c)    | vref::Varref_c r::RCV '<' ra::RArgs_c '>'  { }
(rrcv_poll_c)   | vref::Varref_c rr::R_RCV '<' ra::RArgs_c '>'  { }
(snd_stmt_c)    | vref::Varref_c '!!' ma::MArgs_c  { }
(fullexpr_stmt_c) | fe::FullExpr_c  { }
(else_stmt_c)   | 'else'  { }
(atomic_stmt_c) | 'atomic' '{' seq::Sequence_c os::OS_c '}'  { }
(step_stmt_c)   | 'd_step' '{' seq::Sequence_c os::OS_c '}'  { }
(seq_stmt_c)    | '{' seq::Sequence_c os::OS_c '}'  { }
(inline_stmt_c) | ina::INAME '(' args::Args_c ')'   { }
-- ableP parses inlined statements differently from Spin, see the disucssion 
-- for nonterminals NS_c regarding this
(skip_stmt_c)   | sk::SKIP  { }


nonterminal Options_c ;   -- options
concrete productions ops::Options_c
(single_option_c) | op::Option_c   { }
(cons_option_c)   | op::Option_c rest::Options_c  { }

nonterminal Option_c ;    -- option
concrete productions op::Option_c
(op_seq_c) | '::' seq::Sequence_c os::OS_c  { }


nonterminal OS_c ;  -- OS
concrete productions os::OS_c
(os_no_semi_c) | {-empty-}  { }
(os_semi_c)    | s::SEMI   { }


nonterminal MS_c ;   -- MS
concrete productions ms::MS_c
(ms_one_semi_c)  | s::SEMI   { }
(ms_many_semi_c) | ms2::MS_c  s::SEMI  { }


nonterminal Aname_c ;   -- aname
concrete productions an::Aname_c
(aname_pname_c) | pn::PNAME  { }
    action { pnames = addToList( pn.lexeme, pnames) ; }
(aname_name_c)  | id::ID   { }
    action { pnames = addToList( id.lexeme, pnames) ; }


nonterminal Expr_c ; -- expr
concrete productions exp::Expr_c
(paren_expr_c) | '(' exp2::Expr_c ')'   { }
(plus_expr_c) | lhs::Expr_c '+' rhs::Expr_c    { }
(minus_expr_c) | lhs::Expr_c '-' rhs::Expr_c   { }
(mult_expr_c) | lhs::Expr_c '*' rhs::Expr_c    { }
(div_expr_c) | lhs::Expr_c '/' rhs::Expr_c     { }
(mod_expr_c) | lhs::Expr_c '%' rhs::Expr_c     { }
(singleand_c) | lhs::Expr_c '&' rhs::Expr_c    { }
(xor_expr_c) | lhs::Expr_c '^' rhs::Expr_c     { }
(singleor_c) | lhs::Expr_c '|' rhs::Expr_c     { }
(gt_expr_c) | lhs::Expr_c '>' rhs::Expr_c      { }
(lt_expr_c) | lhs::Expr_c '<' rhs::Expr_c      { }
(ge_expr_c) | lhs::Expr_c '>=' rhs::Expr_c     { }
(le_expr_c) | lhs::Expr_c '<=' rhs::Expr_c     { }
(eq_expr_c) | lhs::Expr_c '==' rhs::Expr_c     { }
(ne_expr_c) | lhs::Expr_c '!=' rhs::Expr_c     { }
(andexpr_c) | lhs::Expr_c '&&' rhs::Expr_c     { }
(orexpr_c) | lhs::Expr_c '||' rhs::Expr_c      { }
(lshift_expr_c) | lhs::Expr_c op::'<<' rhs::Expr_c  { }
(rshift_expr_c) | lhs::Expr_c op::'>>' rhs::Expr_c  { }
(tild_expr_c) | '~' lhs::Expr_c  { }
(neg_expr_c) | '-' lhs::Expr_c   precedence = 45 { }
(snd_expr_c) | '!' lhs::Expr_c   precedence = 45 { }
(expr_expr_c) | '(' c::Expr_c s1::SEMI thenexp::Expr_c ':' elseexp::Expr_c ')'
               { }
(run_expr_c) | r::RUN an::Aname_c '(' args::Args_c ')' p::OptPriority_c
                 { }
(length_expr_c) | l::LEN '(' vref::Varref_c ')'  { }
(enabled_expr_c) | e::ENABLED '(' ex::Expr_c ')'  { }
(rcv_expr_c) | vref::Varref_c r::RCV '[' ra::RArgs_c ']'  { }
(rrcv_expr_c) | vref::Varref_c rr::R_RCV '[' ra::RArgs_c ']'  { }
(varref_expr_c) | vref::Varref_c  { }
(constExpr_c) | c::CONST  { }
(to_expr_c) | tm::TIMEOUT  { }
(np_expr_c) | np::NONPROGRESS  { }
(pcval_expr_c) | pv::PC_VALUE '(' pc::Expr_c ')'  { }
(pname_expr_c) | pn::PNAME '[' ex::Expr_c ']' '@' n::ID  { }
(name_expr_c) | pn::PNAME '@' n::ID  { }
(pfld_expr_c) | pn::PNAME '[' ex::Expr_c ']' ':' pf::Pfld_c  { }
(fld_expr_c) | pn::PNAME ':' pf::Pfld_c  { }
-- The production for LTL expressions (deriving 'ltl') is in the
-- host:extensions:v6 grammar


nonterminal OptPriority_c ; -- Opt_priority
concrete productions op::OptPriority_c
(none_priority_c) | {-empty-}  { }
(num_priority_c)  | p::PRIORITY ct::CONST  { }


nonterminal FullExpr_c ;   -- full_expr
concrete productions fe::FullExpr_c
(fe_expr) | e::Expr_c  { }
(fe_exp)  | e::Expression_c  { }


-- Productions for LTL formulas for spin.y nonterminal 'ltl_expr' are
-- in the host:extensions:v6 grammar.


nonterminal Expression_c ;     -- Expr
concrete productions exp::Expression_c
(expr_probe_c) | pr::Probe_c  { }
(expression_paren_c) | '(' exp2::Expression_c ')'  { }
(and_expression_c) | lhs::Expression_c op::AND rhs::Expression_c  { }
(and_expr_c) | lhs::Expression_c op::AND rhs::Expr_c  { }
(and_expr_expression_c) | lhs::Expr_c op::AND rhs::Expression_c  { }
(or_expression_c) | lhs::Expression_c op::OR rhs::Expression_c  { }
(or_expr_c) | lhs::Expression_c op::OR rhs::Expr_c  { }
(expr_or_c) | lhs::Expr_c op::OR rhs::Expression_c  { }


nonterminal Probe_c ;   -- Probe
concrete productions pr::Probe_c
(full_probe_c) | fl::FULL '(' vref::Varref_c ')'  { }
(nfull_probe_c) | nfl::NFULL '(' vref::Varref_c ')'  { }
(empty_probe_c) | et::EMPTY '(' vref::Varref_c ')'   { }
(nempty_probe_c) | net::NEMPTY '(' vref::Varref_c ')'  { }


nonterminal OptEnabler_c ; -- Opt_enabler
concrete productions oe::OptEnabler_c
(none_enabler_c) | {-empty-}  { }
(expr_enabler_c) | p::PROVIDED '(' fe::FullExpr_c ')'   { }


nonterminal BaseType_c ;   -- basetype
concrete productions bt::BaseType_c
(bt_type_c)  | t::Type_c    { }
(bt_uname_c) | un::UNAME   { }


nonterminal Type_c ; -- This is a terminal called 'TYPE' in spin.y, but 
                     -- these productions have the same effect.
concrete productions t::Type_c
(bitType_c) | 'bit'        { }
(boolType_c) | 'bool'       { }
(intType_c) | 'int'        { }
(mtypeType_c) | 'mtype'      { }
(chanType_c) | 'chan'       { }
(byteType_c) | 'byte'       { }
(pidType_c) | 'pid'        { }
(shortType_c) | 'short'      { }
(unsignedType_c) | 'unsigned'   { }


nonterminal TypList_c ;   --- typ_list
concrete productions tl::TypList_c
(tl_basetype_c) | bt::BaseType_c  { }
(tl_comma_c) | bt::BaseType_c ',' tyl::TypList_c  { }


nonterminal Args_c ;  -- args
concrete productions args::Args_c
(empty_args_c) | {-empty-}  { }
(one_args_c)   | a::Arg_c   { }


nonterminal PrArgs_c ;   -- prargs
concrete productions pa::PrArgs_c
(empty_prargs_c)| {-empty-}     { }
(one_prargs_c)  | ',' a::Arg_c  { }


nonterminal MArgs_c ;      -- margs
concrete productions ma::MArgs_c
(one_margs_c)  | a::Arg_c  { }
(expr_margs_c) | exp::Expr_c '(' a::Arg_c ')'  { }


nonterminal Arg_c ;    -- arg
concrete productions a::Arg_c
(arg_expr_c) | exp::Expr_c  { }
(expr_args_c) | exp::Expr_c ',' a2::Arg_c  { }


nonterminal RArg_c ;    -- rarg
concrete productions ra::RArg_c
(var_rarg_c) | vr::Varref_c  { }
(eval_expr_c) | ev::EVAL '(' exp::Expr_c ')'  { }
(const_rarg_c) | cst::CONST  { }
(neg_const_c) | '-' cst::CONST  precedence = 20 { }


nonterminal RArgs_c ;      -- rargs
concrete productions ras1::RArgs_c
(one_rargs_c)   | ra::RArg_c  { }
(cons_rargs_c)  | ra::RArg_c ',' ras2::RArgs_c  { }
(cons_rpargs_c)  | ra::RArg_c '(' ras2::RArgs_c ')'  { }
(paren_rargs_c) | '(' ras2::RArgs_c ')'  { }


nonterminal IDList_c ;   -- nlst
concrete productions nlst::IDList_c
(singleName_c)| n::ID  { }
(snocNames_c)| some::IDList_c n::ID  { }
(commaNames_c)| nlst2::IDList_c ','  { }

