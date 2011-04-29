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
concrete productions
p::Program_c ::= u::Units_c   (program_c)  { }
 
nonterminal Units_c ;   -- units
concrete productions 
us::Units_c ::= u::Unit_c (units_one_c) { }
us::Units_c ::= us2::Units_c u::Unit_c  (units_snoc_c) { }

nonterminal Unit_c ; -- unit
concrete productions
u::Unit_c ::= p::Proc_c (unit_proc_c)  { } action { usedProcess = 0; }
u::Unit_c ::= i::Init_c (unit_init_c)  { }
u::Unit_c ::= c::Claim_c (unit_claim_c)  { }
-- Unit_c production for LTL formulas in host:extensions:v6 grammar
u::Unit_c ::= e::Events_c (unit_events_c) { }
u::Unit_c ::= dec::OneDecl_c (unit_one_decl_c) { }
u::Unit_c ::= ut::Utype_c (unit_utype_c) { }
u::Unit_c ::= ns::NS_c (unit_ns_c) { } action { usedInline = 1; }
u::Unit_c ::= se::SEMI (unit_semi_c) { }

nonterminal Proc_c ; -- proc
concrete production proc_decl_c
proc::Proc_c ::= i::Inst_c procty::ProcType_c nm::ID 
                 '(' dcl::Decl_c ')'
                 optpri::OptPriority_c optena::OptEnabler_c b::Body_c
{ } action { pnames = addToList( nm.lexeme, pnames);  usedProcess = 1; }

nonterminal ProcType_c ;  -- proctype
concrete productions
procty::ProcType_c ::= pt::PROCTYPE (just_procType_c) { }
procty::ProcType_c ::= dpt::D_PROCTYPE (d_procType_c) { }


nonterminal Inst_c ;  -- inst
concrete productions
i::Inst_c ::= {-empty-} (empty_inst_c) { }
i::Inst_c ::= a::ACTIVE (active_inst_c) { }
i::Inst_c ::= a::ACTIVE '[' ct::CONST ']' (activeconst_inst_c) { }
i::Inst_c ::= a::ACTIVE '[' id::ID ']' (activename_inst_c) { }


nonterminal Init_c ;   -- init
concrete productions
i::Init_c ::= it::INIT op::OptPriority_c body::Body_c (init_c) { }


-- LTL productions for spin.y nonterminals 'ltl' and 'ltl_body' are in
-- host:extensions:v6


nonterminal Claim_c ; -- claim
concrete productions  
c::Claim_c ::= ck::CLAIM body::Body_c (claim_c) { }  
-- This is the v4.2. version.  The named version is in
-- host:extensions:v6 to be v6 compatible


-- ToDo - missing optname and optname2 productions ???


nonterminal Events_c ;  --  events
concrete productions
e::Events_c ::= tr::TRACE body::Body_c (events_c) { }


nonterminal Utype_c ;  -- utype
concrete productions
u::Utype_c ::= td::TYPEDEF id::ID '{' dl::DeclList_c '}' (utype_dcllist_c) { }
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
concrete productions 
nm::NM_c ::= n::ID    (nameNM_c)  { }  action { stringOnNM = n.lexeme ; } 
nm::NM_c ::= n::UNAME (unameNM_c) { }  action { stringOnNM = n.lexeme ; } 


nonterminal NS_c ;  -- ns  
concrete production inline_dcl_iname_c
ns::NS_c ::= il::INLINE nm::NM_c '(' args::InlineArgs_c ')' stmt::Statement_c
{ } action { inames = addToList( stringOnNM, inames); }

nonterminal InlineArgs_c ;
concrete productions
a::InlineArgs_c ::= (inline_args_none_c) { }
a::InlineArgs_c ::= id::ID (inline_args_one_c) { }
a::InlineArgs_c ::= id::ID ',' rest::InlineArgs_c (inline_args_cons_c) { }


-- Productions for embedding C code for spin.y nonterminals 'c_fcts',
-- 'cstate', 'ccode' and 'cexpr' are in host:extensions:embeddedC


nonterminal Body_c ; -- body
concrete productions
b::Body_c ::= '{' s::Sequence_c os::OS_c '}' (body_statements_c) { }


nonterminal Sequence_c ;   -- sequence
concrete productions
s::Sequence_c ::= st::Step_c (single_step_c) { }
s::Sequence_c ::= s2::Sequence_c ms::MS_c st::Step_c (cons_step_c) { }


nonterminal Step_c ;  -- step
concrete productions
s::Step_c ::= od::OneDecl_c (one_decl_c) { }
s::Step_c ::= st::Stmt_c (step_stamt_c) { }
s::Step_c ::= xu::XU vlst::VrefList_c (vref_lst_c) { }
s::Step_c ::= id::ID ':' od::OneDecl_c (name_od_c) { }
s::Step_c ::= id::ID ':' xu::XU (name_xu_c) { }
s::Step_c ::= st1::Stmt_c un::UNLESS st2::Stmt_c (unless_c) { }


nonterminal Vis_c ;  -- vis
concrete productions
v::Vis_c ::= {-empty-}  (vis_empty_c) { }
v::Vis_c ::= h::HIDDEN  (vis_hidden_c) { }
v::Vis_c ::= s::SHOW    (vis_show_c) { }
v::Vis_c ::= i::ISLOCAL (vis_islocal_c) { }


nonterminal Asgn_c ;    -- asgn
concrete productions
a::Asgn_c ::= at::ASGN  (oneAsgn_c)  { }
a::Asgn_c ::= {-empty-} (noAsgn_c)   { }


nonterminal OneDecl_c ;   -- one_decl
concrete productions
d::OneDecl_c ::= v::Vis_c t::Type_c vars::VarList_c (varDcls_c) { }
d::OneDecl_c ::= v::Vis_c u::UNAME vars::VarList_c (typeDclUNAME_c) { }
d::OneDecl_c ::= v::Vis_c t::Type_c a::Asgn_c '{' names::IDList_c '}' 
                  (typenameDcl_c) { }


nonterminal DeclList_c ;    -- decl_lst
concrete productions
dcls::DeclList_c ::= dcl::OneDecl_c (single_Decl_c) { }
dcls::DeclList_c ::= dcl::OneDecl_c s::SEMI rest::DeclList_c (multi_Decl_c) { }


nonterminal Decl_c ;   -- decl
concrete productions
dcl::Decl_c ::= {-empty-} (empty_Decl_c) { }
dcl::Decl_c ::= dcllist::DeclList_c (decllist_c) { }


nonterminal VrefList_c ;   -- vref_lst
concrete productions
vrl::VrefList_c ::= vref::Varref_c (single_varref_c) { }
vrls::VrefList_c ::= vref::Varref_c ',' rest::VrefList_c (comma_varref_c) { }


nonterminal VarList_c ;   -- var_list
concrete productions
vl::VarList_c ::= iv::IVar_c  ( one_var_c )  { }
vl::VarList_c ::= iv::IVar_c ',' rest::VarList_c  ( cons_var_c )  { }

nonterminal IVar_c ;   -- ivar
concrete productions
iv::IVar_c ::= vd::VarDcl_c (ivar_vardcl_c)  { }
iv::IVar_c ::= vd::VarDcl_c a::ASGN e::Expr_c (ivar_vardcl_assign_expr_c) { }
iv::IVar_c ::= vd::VarDcl_c a::ASGN ch::ChInit_c (ivar_vardcl_assign_ch_init_c) { }


nonterminal ChInit_c ;   -- ch_init
concrete productions
ch::ChInit_c ::= '[' c::CONST ']' o::OF '{' tl::TypList_c '}' (ch_init_c) { }

nonterminal VarDcl_c ;   -- vardcl
concrete productions
vd::VarDcl_c ::= id::ID (vd_id_c) { }
vd::VarDcl_c ::= id::ID ':' cnt::CONST (vd_idconst_c) { }
vd::VarDcl_c ::= id::ID '[' cnt::CONST ']' (vd_array_c) { }


nonterminal Varref_c ;  -- varref
concrete productions
v::Varref_c ::= c::Cmpnd_c (varref_cmpnd_c) { } 


nonterminal Pfld_c ;   -- pfld
concrete productions
pf::Pfld_c ::= id::ID (name_pfld_c) { }
pf::Pfld_c ::= id::ID '[' ex::Expr_c ']' (expr_pfld_c) { }


nonterminal Cmpnd_c ;  -- cmpdn
concrete productions
c::Cmpnd_c ::= p::Pfld_c s::Sfld_c (cmpnd_pfld_c) { }


nonterminal Sfld_c ;  -- sfld
concrete productions
sf::Sfld_c ::= {-empty-} (empty_sfld_c) { }
sf::Sfld_c ::= d::STOP c::Cmpnd_c (dot_sfld_c) precedence = 45 { }


nonterminal Stmt_c ;    -- stmnt
concrete productions
stmt::Stmt_c ::= sc::Special_c (special_stmt_c) { }
stmt::Stmt_c ::= st::Statement_c (statement_stmt_c) { }


-- Productions in spin.y for nonterminals 'for_pre' and 'for_post' are
-- in host:extensions:v6


nonterminal Special_c ;  -- Special
concrete productions
sc::Special_c ::= vref::Varref_c '?' ra::RArgs_c (rcv_special_c) { }
sc::Special_c ::= vref::Varref_c '!' ma::MArgs_c (snd_special_c) { }
-- Productions for the for-loop and select statements in spin.y for
-- nonterminal 'Special' are in host:extensions:v6
sc::Special_c ::= i::IF op::Options_c f::FI (if_special_c) { }
sc::Special_c ::= d::DO op::Options_c o::OD (do_special_c) { }
sc::Special_c ::= b::BREAK (break_special_c) { }
sc::Special_c ::= g::GOTO id::ID (goto_special_c) { }
sc::Special_c ::= id::ID ':' st::Stmt_c (stmt_special_c) { }


nonterminal Statement_c ;   -- Stmnt
concrete productions
st::Statement_c ::= vref::Varref_c '=' exp::Expr_c (assign_stmt_c) { }
st::Statement_c ::= vref::Varref_c inc::INCR (incr_stmt_c) { }
st::Statement_c ::= vref::Varref_c de::DECR (decr_stmt_c) { }
st::Statement_c ::= pr::PRINTF '(' str::STRING par::PrArgs_c ')' (print_stmt_c) { }
st::Statement_c ::= pr::PRINTM '(' vref::Varref_c ')' (printm_stmt_c) { }
st::Statement_c ::= pr::PRINTM '(' cn::CONST ')' (printm_const_c) { }
st::Statement_c ::= ast::ASSERT fe::FullExpr_c (assert_stmt_c) { }
-- Production for embedded C code (deriving ccode) is in the
-- host:extensions:embeededC grammar
st::Statement_c ::= vref::Varref_c r::R_RCV ra::RArgs_c (rrcv_stmt_c) { }
st::Statement_c ::= vref::Varref_c r::RCV '<' ra::RArgs_c '>' (rcv_stmt_c) { }
st::Statement_c ::= vref::Varref_c rr::R_RCV '<' ra::RArgs_c '>' (rrcv_poll_c) { }
st::Statement_c ::= vref::Varref_c '!!' ma::MArgs_c (snd_stmt_c) { }
st::Statement_c ::= fe::FullExpr_c (fullexpr_stmt_c) { }
st::Statement_c ::= 'else' (else_stmt_c) { }
st::Statement_c ::= 'atomic' '{' seq::Sequence_c os::OS_c '}' (atomic_stmt_c) { }
st::Statement_c ::= 'd_step' '{' seq::Sequence_c os::OS_c '}' (step_stmt_c) { }
st::Statement_c ::= '{' seq::Sequence_c os::OS_c '}' (seq_stmt_c) { }
st::Statement_c ::= ina::INAME '(' args::Args_c ')'  (inline_stmt_c) { }
-- ableP parses inlined statements differently from Spin, see the disucssion 
-- for nonterminals NS_c regarding this
st::Statement_c ::= sk::SKIP (skip_stmt_c) { }


nonterminal Options_c ;   -- options
concrete productions
ops::Options_c ::= op::Option_c (single_option_c)  { }
ops::Options_c ::= op::Option_c rest::Options_c (cons_option_c) { }

nonterminal Option_c ;    -- option
concrete productions
op::Option_c ::= '::' seq::Sequence_c os::OS_c (op_seq_c) { }


nonterminal OS_c ;  -- OS
concrete productions
os::OS_c ::= {-empty-} (os_no_semi_c) { }
os::OS_c ::= s::SEMI  (os_semi_c) { }


nonterminal MS_c ;   -- MS
concrete productions
ms::MS_c ::= s::SEMI  (ms_one_semi_c) { }
ms::MS_c ::= ms2::MS_c  s::SEMI (ms_many_semi_c) { }


nonterminal Aname_c ;   -- aname
concrete productions
an::Aname_c ::= pn::PNAME (aname_pname_c) { }
  action { pnames = addToList( pn.lexeme, pnames) ; }
an::Aname_c ::= id::ID (aname_name_c)  { }
  action { pnames = addToList( id.lexeme, pnames) ; }


nonterminal Expr_c ; -- expr
concrete productions
exp1::Expr_c ::= '(' exp2::Expr_c ')'  (paren_expr_c) { }
exp::Expr_c ::= lhs::Expr_c '+' rhs::Expr_c  (plus_expr_c)  { }
exp::Expr_c ::= lhs::Expr_c '-' rhs::Expr_c  (minus_expr_c) { }
exp::Expr_c ::= lhs::Expr_c '*' rhs::Expr_c  (mult_expr_c)  { }
exp::Expr_c ::= lhs::Expr_c '/' rhs::Expr_c  (div_expr_c)   { }
exp::Expr_c ::= lhs::Expr_c '%' rhs::Expr_c  (mod_expr_c)   { }
exp::Expr_c ::= lhs::Expr_c '&' rhs::Expr_c  (singleand_c)  { }
exp::Expr_c ::= lhs::Expr_c '^' rhs::Expr_c  (xor_expr_c)   { }
exp::Expr_c ::= lhs::Expr_c '|' rhs::Expr_c  (singleor_c)   { }
exp::Expr_c ::= lhs::Expr_c '>' rhs::Expr_c  (gt_expr_c)    { }
exp::Expr_c ::= lhs::Expr_c '<' rhs::Expr_c  (lt_expr_c)    { }
exp::Expr_c ::= lhs::Expr_c '>=' rhs::Expr_c (ge_expr_c)    { }
exp::Expr_c ::= lhs::Expr_c '<=' rhs::Expr_c (le_expr_c)    { }
exp::Expr_c ::= lhs::Expr_c '==' rhs::Expr_c (eq_expr_c)    { }
exp::Expr_c ::= lhs::Expr_c '!=' rhs::Expr_c (ne_expr_c)    { }
exp::Expr_c ::= lhs::Expr_c '&&' rhs::Expr_c (andexpr_c)    { }
exp::Expr_c ::= lhs::Expr_c '||' rhs::Expr_c (orexpr_c)     { }
exp::Expr_c ::= lhs::Expr_c op::'<<' rhs::Expr_c (lshift_expr_c) { }
exp::Expr_c ::= lhs::Expr_c op::'>>' rhs::Expr_c (rshift_expr_c) { }
exp::Expr_c ::= '~' lhs::Expr_c (tild_expr_c) { }
exp::Expr_c ::= '-' lhs::Expr_c (neg_expr_c)  precedence = 45 { }
exp::Expr_c ::= '!' lhs::Expr_c (snd_expr_c)  precedence = 45 { }
e::Expr_c ::= '(' c::Expr_c s1::SEMI thenexp::Expr_c ':' elseexp::Expr_c ')'
              (expr_expr_c) { }
exp::Expr_c ::= r::RUN an::Aname_c '(' args::Args_c ')' p::OptPriority_c
                (run_expr_c) { }
exp::Expr_c ::= l::LEN '(' vref::Varref_c ')' (length_expr_c) { }
exp::Expr_c ::= e::ENABLED '(' ex::Expr_c ')' (enabled_expr_c) { }
exp::Expr_c ::= vref::Varref_c r::RCV '[' ra::RArgs_c ']' (rcv_expr_c) { }
exp::Expr_c ::= vref::Varref_c rr::R_RCV '[' ra::RArgs_c ']' (rrcv_expr_c) { }
exp::Expr_c ::= vref::Varref_c (varref_expr_c) { }
exp::Expr_c ::= c::CONST (constExpr_c) { }
e::Expr_c ::= tm::TIMEOUT (to_expr_c) { }
e::Expr_c ::= np::NONPROGRESS (np_expr_c) { }
e::Expr_c ::= pv::PC_VALUE '(' pc::Expr_c ')' (pcval_expr_c) { }
e::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' '@' n::ID (pname_expr_c) { }
e::Expr_c ::= pn::PNAME '@' n::ID (name_expr_c) { }
e::Expr_c ::= pn::PNAME '[' ex::Expr_c ']' ':' pf::Pfld_c (pfld_expr_c) { }
e::Expr_c ::= pn::PNAME ':' pf::Pfld_c (fld_expr_c) { }
-- The production for LTL expressions (deriving 'ltl') is in the
-- host:extensions:v6 grammar


nonterminal OptPriority_c ; -- Opt_priority
concrete productions
op::OptPriority_c ::= {-empty-} (none_priority_c) { }
op::OptPriority_c ::= p::PRIORITY ct::CONST (num_priority_c) { }


nonterminal FullExpr_c ;   -- full_expr
concrete productions
fe::FullExpr_c ::= e::Expr_c (fe_expr) { }
fe::FullExpr_c ::= e::Expression_c (fe_exp) { }


-- Productions for LTL formulas for spin.y nonterminal 'ltl_expr' are
-- in the host:extensions:v6 grammar.


nonterminal Expression_c ;     -- Expr
concrete productions
e::Expression_c ::= pr::Probe_c (expr_probe_c) { }
exp1::Expression_c ::= '(' exp2::Expression_c ')' (expression_paren_c) { }
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expression_c 
                      (and_expression_c) { }
exp::Expression_c ::= lhs::Expression_c op::AND rhs::Expr_c (and_expr_c) { }
exp::Expression_c ::= lhs::Expr_c op::AND rhs::Expression_c  
                      (and_expr_expression_c) { }
exp::Expression_c ::= lhs::Expression_c op::OR rhs::Expression_c 
                      (or_expression_c) { }
exp::Expression_c ::= lhs::Expression_c op::OR rhs::Expr_c (or_expr_c) { }
exp::Expression_c ::= lhs::Expr_c op::OR rhs::Expression_c (expr_or_c) { }


nonterminal Probe_c ;   -- Probe
concrete productions
pr::Probe_c ::= fl::FULL '(' vref::Varref_c ')' (full_probe_c) { }
pr::Probe_c ::= nfl::NFULL '(' vref::Varref_c ')' (nfull_probe_c) { }
pr::Probe_c ::= et::EMPTY '(' vref::Varref_c ')'  (empty_probe_c) { }
pr::Probe_c ::= net::NEMPTY '(' vref::Varref_c ')' (nempty_probe_c) { }


nonterminal OptEnabler_c ; -- Opt_enabler
concrete productions
oe::OptEnabler_c ::= {-empty-} (none_enabler_c) { }
oe::OptEnabler_c ::= p::PROVIDED '(' fe::FullExpr_c ')'  (expr_enabler_c) { }


nonterminal BaseType_c ;   -- basetype
concrete productions
bt::BaseType_c ::= t::Type_c  (bt_type_c)  { }
bt::BaseType_c ::= un::UNAME  (bt_uname_c) { }


nonterminal Type_c ; -- This is a terminal called 'TYPE' in spin.y, but 
                     -- these productions have the same effect.
concrete productions
t::Type_c ::= 'bit'       (bitType_c) { }
t::Type_c ::= 'bool'      (boolType_c) { }
t::Type_c ::= 'int'       (intType_c) { }
t::Type_c ::= 'mtype'     (mtypeType_c) { }
t::Type_c ::= 'chan'      (chanType_c) { }
t::Type_c ::= 'byte'      (byteType_c) { }
t::Type_c ::= 'pid'       (pidType_c) { }
t::Type_c ::= 'short'     (shortType_c) { }
t::Type_c ::= 'unsigned'  (unsignedType_c) { }


nonterminal TypList_c ;   --- typ_list
concrete productions
tl::TypList_c ::= bt::BaseType_c (tl_basetype_c) { }
tl::TypList_c ::= bt::BaseType_c ',' tyl::TypList_c (tl_comma_c) { }


nonterminal Args_c ;  -- args
concrete productions
args::Args_c ::= {-empty-} (empty_args_c) { }
args::Args_c ::= a::Arg_c  (one_args_c) { }


nonterminal PrArgs_c ;   -- prargs
concrete productions
pa::PrArgs_c ::= {-empty-}    (empty_prargs_c) { }
pa::PrArgs_c ::= ',' a::Arg_c (one_prargs_c) { }


nonterminal MArgs_c ;      -- margs
concrete productions
ma::MArgs_c ::= a::Arg_c (one_margs_c) { }
ma::MArgs_c ::= exp::Expr_c '(' a::Arg_c ')' (expr_margs_c) { }


nonterminal Arg_c ;    -- arg
concrete productions
a::Arg_c ::= exp::Expr_c (arg_expr_c) { }
a1::Arg_c ::= exp::Expr_c ',' a2::Arg_c (expr_args_c) { }


nonterminal RArg_c ;    -- rarg
concrete productions
ra::RArg_c ::= vr::Varref_c (var_rarg_c) { }
ra::RArg_c ::= ev::EVAL '(' exp::Expr_c ')' (eval_expr_c) { }
ra::RArg_c ::= cst::CONST (const_rarg_c) { }
ra::RArg_c ::= '-' cst::CONST (neg_const_c) precedence = 20 { }


nonterminal RArgs_c ;      -- rargs
concrete productions
ras::RArgs_c ::= ra::RArg_c (one_rargs_c) { }
ras1::RArgs_c ::= ra::RArg_c ',' ras2::RArgs_c (cons_rargs_c) { }
ras1::RArgs_c ::= ra::RArg_c '(' ras2::RArgs_c ')' (cons_rpargs_c) { }
ras1::RArgs_c ::= '(' ras2::RArgs_c ')' (paren_rargs_c) { }


nonterminal IDList_c ;   -- nlst
concrete productions
nlst::IDList_c ::= n::ID (singleName_c) { }
nlst::IDList_c ::= some::IDList_c n::ID (snocNames_c) { }
nlst1::IDList_c ::= nlst2::IDList_c ',' (commaNames_c) { }

