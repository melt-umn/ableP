grammar edu:umn:cs:melt:ableP:concretesyntax ;

synthesized attribute cst_Program_c :: Program_c occurs on Program ;
aspect production program  p ::= u 
{ p.cst_Program_c = program_c( us_cst ) ; 
  local us_cst::Units_c = 
    if null(us) then error ("Empty list of Unit_c on program.")
    else foldl_p ( units_snoc_c, units_one_c( head(us) ), tail(us) ) ;
  local us::[Unit_c] = u.cst_Unit_c_asList ;
}

--synthesized attribute cst_Units_c :: Units_c occurs on Units ;
--aspect production units_one  us ::= u
--{ us.cst_Units_c = units_one_c(u.cst_Unit_c) ; }
--aspect production units_snoc  us ::= us2 u
--{ us.cst_Units_c = units_snoc_c(us2.cst_Units_c, u.cst_Unit_c) ; }

-- Units --
-----------
synthesized attribute cst_Unit_c_asList :: [Unit_c] occurs on Unit ;
synthesized attribute cst_Unit_c :: Unit_c occurs on Unit ;

aspect production seqUnit  u::Unit ::= u1::Unit u2::Unit
{ u.cst_Unit_c_asList = u1.cst_Unit_c_asList ++ u2.cst_Unit_c_asList ;
  u.cst_Unit_c = error ("Cannont compute cst_Unit_c on seqUnit.");
}
aspect production emptyUnit   u::Unit ::= 
{ u.cst_Unit_c_asList = [ ] ;
  u.cst_Unit_c = error ("Cannont compute cst_Unit_c on emptyUnit.");
}
aspect production unitDecls   u::Unit ::= ds::Decls
{ u.cst_Unit_c_asList = intersperse ( unit_semi_c(sem), 
          ds.cst_Unit_c_asList ) ;
        --  map_p ( unit_one_decl_c, ds.cst_OneDecl_c_asList ) ) ;
        -- we switch from the map_p above because we added cst_Unit_c_asList
        -- which we added to span more of the CST tree hierarchy.
  u.cst_Unit_c = unit_one_decl_c ( ds.cst_OneDecl_c ) ; 
}

synthesized attribute cst_Claim_c :: Claim_c occurs on Unit ;

-- Declarations --
------------------
global sem ::SEMI = terminal(SEMI,";") ;
synthesized attribute cst_OneDecl_c_asList :: [ OneDecl_c ] occurs on Decls ;
synthesized attribute cst_Decl_c::Decl_c occurs on Decls ;
attribute cst_Unit_c_asList occurs on Decls ;
attribute cst_Unit_c occurs on Decls ;

synthesized attribute cst_DeclList_c::DeclList_c occurs on Decls ;
synthesized attribute cst_OneDecl_c::OneDecl_c occurs on Decls ;

-- Mapping abstract syntax back to concrete syntax --
aspect production seqDecls  ds::Decls ::= ds1::Decls ds2::Decls
{ ds.cst_Unit_c_asList = ds1.cst_Unit_c_asList ++ ds2.cst_Unit_c_asList ;
  ds.cst_Unit_c = error("Cannot compute cst_Unit_c on " ++ prodName); 

  ds.cst_OneDecl_c_asList = ds1.cst_OneDecl_c_asList ++ ds2.cst_OneDecl_c_asList ;
  ds.cst_OneDecl_c = error("Cannot compute cst_OneDecl_c on " ++ prodName); 
 


  ds.cst_Decl_c = error("Cannot compute cst_Decl_c on " ++ prodName);
  ds.cst_DeclList_c = multi_Decl_c(ds1.cst_OneDecl_c, sem, ds2.cst_DeclList_c ) ; 

  ds.cst_VarList_c = error("Cannot compute cst_VarList_c on " ++ prodName); 
  ds.cst_IVar_c = error("Cannot compute cst_IVar_c on " ++ prodName); 
  ds.cst_Proc_c = error("Cannot compute cst_Prc_c on " ++ prodName); 
  local prodName::String = "seqDecls" ;}

aspect production emptyDecl  ds::Decls ::=
{ ds.cst_Unit_c_asList = [ ] ;
  ds.cst_Unit_c = error("Cannot compute cst_Unit_c on " ++ prodName); 

  ds.cst_OneDecl_c_asList = [ ] ;
  ds.cst_OneDecl_c = error("Cannot compute cst_OneDecl_c on " ++ prodName); 

  ds.cst_Decl_c = empty_Decl_c() ;
  ds.cst_DeclList_c =  error("Cannot compute cst_DeclList_c on " ++ prodName);
  ds.cst_VarList_c = error("Cannot compute cst_VarList_c on " ++ prodName); 
  ds.cst_IVar_c = error("Cannot compute cst_IVar_c on " ++ prodName); 
  ds.cst_Proc_c = error("Cannot compute cst_Prc_c on " ++ prodName); 
  local prodName::String = "emptyDecls" ;}

aspect production defaultVarDecl ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{ ds.cst_Unit_c_asList = [ ds.cst_Unit_c ] ;
  ds.cst_Unit_c = unit_one_decl_c ( ds.cst_OneDecl_c ) ;

  ds.cst_OneDecl_c_asList = [ ds.cst_OneDecl_c ] ;
  ds.cst_OneDecl_c = varDcls_c ( vis.cst_Vis_c, t.cst_Type_c, 
                        one_var_c ( ivar_vardcl_c( v.cst_VarDcl_c) ) ) ;
---
  ds.cst_Decl_c = error("Cannot compute cst_Decl_c on " ++ prodName);
  ds.cst_DeclList_c =  single_Decl_c(ds.cst_OneDecl_c);


  ds.cst_VarList_c = error("Cannot compute cst_VarList_c on " ++ prodName); 
  ds.cst_IVar_c = error("Cannot compute cst_IVar_c on " ++ prodName); 
  ds.cst_Proc_c = error("Cannot compute cst_Prc_c on " ++ prodName); 
  local prodName::String = "defaultVarDecl" ;}

aspect production defaultVarAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{ ds.cst_Unit_c_asList = [ ds.cst_Unit_c ] ;
  ds.cst_Unit_c = unit_one_decl_c ( ds.cst_OneDecl_c ) ;

  ds.cst_OneDecl_c_asList = [ ds.cst_OneDecl_c ] ;
  ds.cst_OneDecl_c = varDcls_c ( vis.cst_Vis_c, t.cst_Type_c, 
                       one_var_c (
                         ivar_vardcl_assign_expr_c (
                           v.cst_VarDcl_c, '=', e.cst_Expr_c
                      ) ) ) ;


------

  ds.cst_Decl_c = error("Cannot compute cst_Decl_c on " ++ prodName);
--  ds.cst_DeclList_c =  single_Decl_c(ds.cst_OneDecl_c);
  ds.cst_DeclList_c =  error("Cannot compute cst_DeclList_c on " ++ prodName);

  
--  ds.cst_OneDecl_c = varDcls_c(vis.cst_Vis_c, t.cst_Type_c, v.cst_VarList_c) ;
  ds.cst_OneDecl_c = error("Cannot compute cst_OneDecl_c on " ++ prodName); 
  ds.cst_VarList_c = error("Cannot compute cst_VarList_c on " ++ prodName); 
  ds.cst_IVar_c = error("Cannot compute cst_IVar_c on " ++ prodName); 
  ds.cst_Proc_c = error("Cannot compute cst_Prc_c on " ++ prodName); 
  local prodName::String = "defaultVarAssignDecl";}


aspect production procDecl
proc::Decls ::= i::Inst procty::ProcType nm::ID dcl::Decls
                pri::Priority ena::Enabler 
                b::Stmt
{ proc.cst_Unit_c_asList = [ proc.cst_Unit_c ] ;
  proc.cst_Unit_c
    = unit_proc_c ( proc_decl_c ( i.cst_Inst_c, procty.cst_ProcType_c, nm,
                                  '(', dcl.cst_Decl_c, ')', 
                                  pri.cst_OptPriority_c, ena.cst_OptEnabler_c, 
                                  b.cst_Body_c  ) ) ;

  proc.cst_OneDecl_c_asList = error("Cannot compute cst_OneDecl_c on procDecl.") ;
  proc.cst_OneDecl_c = error("Cannot compute cst_OneDecl_c on " ++ prodName); 

  proc.cst_VarList_c = error("Cannot compute cst_VarList_c on " ++ prodName); 
  proc.cst_IVar_c = error("Cannot compute cst_IVar_c on " ++ prodName); 
  proc.cst_Proc_c = error("Cannot compute cst_Prc_c on " ++ prodName); 
  local prodName::String = "defaultVarAssignDecl";
}
{-
aspect production -- -- 
{ ds.cst_Decl_c = error("Cannot compute cst_Decl_c on " ++ prodName);
  ds.cst_DeclList_c =  error("Cannot compute cst_DeclList_c on " ++ prodName);
  ds.cst_OneDecl_c = error("Cannot compute cst_OneDecl_c on " ++ prodName); 
  ds.cst_VarList_c = error("Cannot compute cst_VarList_c on " ++ prodName); 
  ds.cst_IVar_c = error("Cannot compute cst_IVar_c on " ++ prodName); 
  ds.cst_Proc_c = error("Cannot compute cst_Prc_c on " ++ prodName); 
  local prodName::String = "seqDecls" ;}
-}

-- Declarator --
aspect production vd_id   vd::Declarator ::= id::ID
{ vd.cst_VarDcl_c = vd_id_c(id) ; }
aspect production vd_idconst   vd::Declarator ::= id::ID cnt::CONST
{ vd.cst_VarDcl_c = vd_idconst_c(id, ':', cnt) ; }
aspect production vd_array   vd::Declarator ::= id::ID cnt::CONST
{ vd.cst_VarDcl_c = vd_array_c(id, '[', cnt, ']') ; }

-- Vis --
aspect production vis_empty  v::Vis ::=
{ v.cst_Vis_c = vis_empty_c() ; }
aspect production vis_hidden v::Vis ::=
{ v.cst_Vis_c = vis_hidden_c('hidden') ; }
aspect production vis_show v::Vis ::=
{ v.cst_Vis_c = vis_show_c('show') ; }
aspect production vis_islocal  v::Vis ::=
{ v.cst_Vis_c = vis_islocal_c('local') ; }



-- Stmt --
----------
synthesized attribute cst_Body_c::Body_c occurs on Stmt ;
synthesized attribute cst_Sequence_c::Sequence_c occurs on Stmt ;
synthesized attribute cst_Step_c::Step_c occurs on Stmt ;
synthesized attribute cst_Stmt_c::Stmt_c occurs on Stmt ;
synthesized attribute cst_Special_c::Special_c occurs on Stmt ;
synthesized attribute cst_Statement_c::Statement_c occurs on Stmt ;

aspect production seqStmt  s::Stmt ::= s1::Stmt s2::Stmt
{ s.cst_Body_c = body_statements_c ( '{', s.cst_Sequence_c, os_no_semi_c(), '}' ) ;
  s.cst_Sequence_c = cons_step_c ( s1.cst_Sequence_c, ms_one_semi_c(sem), s2.cst_Step_c ) ;
  s.cst_Step_c = step_stamt_c ( s.cst_Stmt_c ) ;
  s.cst_Stmt_c = special_stmt_c ( s.cst_Special_c ) ;
  -- OR  s.cst_Stmt_c = statement_stmt_c ( s.cst_Statement_c ) ;
  s.cst_Special_c = error ("Cannot compute cst_Special_c on seqStmt.") ;
  s.cst_Statement_c = seq_stmt_c ( '{', s.cst_Sequence_c, os_no_semi_c(), '}' ) ;
}

aspect production one_decl  s::Stmt ::= d::Decls
{ s.cst_Body_c = body_statements_c ( '{', s.cst_Sequence_c, os_no_semi_c(), '}' ) ;
  s.cst_Sequence_c = single_step_c ( s.cst_Step_c ) ; 
  s.cst_Step_c = one_decl_c ( d.cst_OneDecl_c ) ;
  s.cst_Stmt_c = special_stmt_c ( s.cst_Special_c ) ;
  -- OR  s.cst_Stmt_c = statement_stmt_c ( s.cst_Statement_c ) ;
  s.cst_Special_c = error ("Cannot compute cst_Special_c on one_decl.") ;
  s.cst_Statement_c = seq_stmt_c ( '{', s.cst_Sequence_c, os_no_semi_c(), '}' ) ;
}

aspect production blockStmt s::Stmt ::= body::Stmt
{ s.cst_Body_c = body_statements_c ( '{', body.cst_Sequence_c, os_no_semi_c(), '}' ) ;
  s.cst_Sequence_c = single_step_c ( s.cst_Step_c ) ; 
  s.cst_Step_c = step_stamt_c ( s.cst_Stmt_c ) ;
  s.cst_Stmt_c = special_stmt_c ( s.cst_Special_c ) ;
  -- OR  s.cst_Stmt_c = statement_stmt_c ( s.cst_Statement_c ) ;
  s.cst_Special_c = error ("Cannot compute cst_Special_c on one_decl.") ;
  s.cst_Statement_c = seq_stmt_c ( '{', s.cst_Sequence_c, os_no_semi_c(), '}' ) ;
}



aspect production assign   s::Stmt ::= lhs::Expr rhs::Expr 
{ s.cst_Statement_c = assign_stmt_c( lhs.cst_Varref_c, '=', rhs.cst_Expr_c ) ;
}

abstract production defaultStmt
s::Stmt ::= fs::Decorated Stmt
{ s.cst_Body_c = body_statements_c ( '{', fs.cst_Sequence_c, os_no_semi_c(), '}' ) ;
  s.cst_Sequence_c = single_step_c ( fs.cst_Step_c ) ; 
  s.cst_Step_c = step_stamt_c ( s.cst_Stmt_c ) ;
  s.cst_Stmt_c = statement_stmt_c ( fs.cst_Statement_c ) ;
  -- OR s.cst_Stmt_c = special_stmt_c ( fs.cst_Special_c ) ;
  s.cst_Special_c = error ("Cannot compute cst_Special_c on " ++ prodName ) ;
  s.cst_Statement_c = seq_stmt_c ( '{', fs.cst_Sequence_c, os_no_semi_c(), '}' ) ;
  local prodName::String = "...";
}


-- Expression / Expressions --
------------------------------
synthesized attribute cst_FullExpr_c::FullExpr_c occurs on Expr ;
synthesized attribute cst_Expression_c::Expression_c occurs on Expr ;
synthesized attribute cst_Varref_c::Varref_c occurs on Expr ;

synthesized attribute cst_Args_c::Args_c occurs on Exprs ;
synthesized attribute cst_Exprs_c::Exprs_c occurs on Exprs ;
synthesized attribute cst_PrArgs_c::PrArgs_c occurs on Exprs ;

abstract production defaultExpr e::Expr ::= fe::Decorated Expr
{ e.cst_FullExpr_c = fe_expr( e.cst_Expr_c ) ;
  -- OR e.cst_FullExpr_c = fe_exp( e.cst_Expression_c ) ;
  -- e.cst_Expression_c = 
  -- Circular e.cst_Expression_c = expression_paren_c ( '(', e.cst_Expression_c, ')' ) ;

  e.cst_Expr_c = varref_expr_c ( e.cst_Varref_c ) ;
  -- Circular e.cst_Expr_c = paren_expr_c ( '(', e.cst_Expr_c, ')' ) ;
  
}

aspect production constExpr   e::Expr ::= c::CONST
{ e.cst_Expr_c = constExpr_c ( c ) ; }




synthesized attribute cst_Proc_c::Proc_c occurs on Decls ;
aspect production procDecl
proc::Decls ::= i::Inst procty::ProcType nm::ID dcl::Decls
                pri::Priority ena::Enabler 
                b::Stmt
{ proc.cst_Proc_c = proc_decl_c ( i.cst_Inst_c, procty.cst_ProcType_c, nm,
                       '(', dcl.cst_Decl_c, ')', pri.cst_OptPriority_c, 
                       ena.cst_OptEnabler_c, b.cst_Body_c ) ; }



-- ProcType --
synthesized attribute cst_ProcType_c::ProcType_c occurs on ProcType ;
aspect production just_procType pt::ProcType ::=
{ pt.cst_ProcType_c = just_procType_c( 'proctype') ;  }
aspect production d_procType  pt::ProcType ::=
{ pt.cst_ProcType_c = d_procType_c( 'D_proctype' ) ;   }

-- Inst --
synthesized attribute cst_Inst_c::Inst_c occurs on Inst ;
aspect production empty_inst  i::Inst ::= 
{ i.cst_Inst_c = empty_inst_c() ; }
aspect production active_inst  i::Inst ::= 
{ i.cst_Inst_c = active_inst_c('active') ; }
aspect production activeconst_inst  i::Inst ::= ct::CONST
{ i.cst_Inst_c = activeconst_inst_c ( 'active', '[', ct, ']' ) ; }
aspect production activename_inst  i::Inst ::= id::ID
{ i.cst_Inst_c = activename_inst_c ( 'active', '[', id, ']' ) ; }

-- OptPriority --
synthesized attribute cst_OptPriority_c::OptPriority_c occurs on Priority ;
aspect production none_priority   p::Priority ::=
{ p.cst_OptPriority_c = none_priority_c() ; }
aspect production num_priority   p::Priority ::= ct::CONST
{ p.cst_OptPriority_c = num_priority_c('priority', ct) ; }

-- OptEnabler --
synthesized attribute cst_OptEnabler_c::OptEnabler_c occurs on Enabler ;
aspect production noEnabler   e::Enabler ::= 
{ e.cst_OptEnabler_c = none_enabler_c() ; }




synthesized attribute cst_BaseType_c::BaseType_c occurs on TypeExpr ;
synthesized attribute cst_Type_c::Type_c occurs on TypeExpr ;
synthesized attribute cst_TypList_c::TypList_c occurs on TypeExprs ;

aspect production intTypeExpr  t::TypeExpr ::=
{ t.cst_Type_c = intType_c('int') ; }
aspect production mtypeTypeExpr      t::TypeExpr ::=
{ t.cst_Type_c = mtypeType_c('mtype') ; }
aspect production chanTypeExpr       t::TypeExpr ::=
{ t.cst_Type_c = chanType_c('chan') ; }
aspect production bitTypeExpr        t::TypeExpr ::=
{ t.cst_Type_c = bitType_c('bit') ; }
aspect production boolTypeExpr       t::TypeExpr ::= 
{ t.cst_Type_c = boolType_c('bool') ; }
aspect production byteTypeExpr       t::TypeExpr ::=
{ t.cst_Type_c = byteType_c('byte') ; }
aspect production shortTypeExpr      t::TypeExpr ::=
{ t.cst_Type_c = shortType_c('short') ; }
aspect production pidTypeExpr        t::TypeExpr ::=
{ t.cst_Type_c = pidType_c('pid') ; }
aspect production unsignedTypeExpr   t::TypeExpr ::=
{ t.cst_Type_c = unsignedType_c('unsigned') ; }
