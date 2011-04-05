grammar edu:umn:cs:melt:ableP:concretesyntax;

--Decl_c
nonterminal Decl_c with pp, ppi, ast<Decls>;   -- same as in v4.2.9 and v6

concrete production empty_Decl_c
dcl::Decl_c ::= 
{ dcl.pp = "";
  dcl.ast = emptyDecl();
}

concrete production decllist_c
dcl::Decl_c ::= dcllist::DeclList_c
{ dcl.pp = dcllist.pp;
  dcllist.ppi = dcl.ppi ;
  dcl.ast = dcllist.ast ;
}

--DeclList_c
nonterminal DeclList_c with pp, ppi, ast<Decls> ;    -- same as in v4.2.9 and v6
synthesized attribute cst_DeclList_c::DeclList_c occurs on Decls ;

concrete production single_Decl_c
dcls::DeclList_c ::= dcl::OneDecl_c
{ dcls.pp = dcl.pp;
  dcl.ppi = dcls.ppi;
  dcls.ast = dcl.ast ;
}

concrete production multi_Decl_c
dcls::DeclList_c ::= dcl::OneDecl_c sc::SEMI rest::DeclList_c
{ dcls.pp = dcl.pp ++ "; \n" ++ rest.pp;
  dcl.ppi = dcls.ppi;
  rest.ppi = dcls.ppi;
  dcls.ast = seqDecls(dcl.ast, rest.ast);
}

--OneDecl_c
nonterminal OneDecl_c with pp, ppi, ast<Decls> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_OneDecl_c::OneDecl_c occurs on Decls ;

concrete production varDcls_c
d::OneDecl_c ::= v::Vis_c t::Type_c vars::VarList_c
{ d.pp = d.ppi ++ v.pp ++ " " ++ t.pp ++ " " ++ vars.pp;
  d.ast = vars.ast ; -- varDecl (v.ast, t.ast, vars.ast) ;
  vars.inTypeExpr = t.ast ;
  vars.inVis = v.ast ;
}

concrete production typeDclUNAME_c
od::OneDecl_c ::= v::Vis_c u::UNAME vars::VarList_c
{ od.pp = od.ppi ++ v.pp ++ " " ++ u.lexeme ++ " " ++ vars.pp; }

concrete production typenameDcl_c
od::OneDecl_c ::= v::Vis_c t::Type_c a::Asgn_c lc::LCURLY names::IDList_c rc::RCURLY
{ od.pp = od.ppi ++ v.pp ++ " " ++ t.pp ++ a.pp ++ "{ " ++ names.pp ++ " }" ;
  od.ast = mtypeDecls (v.ast, t.ast, names.ast) ;   }

-- Asgn
nonterminal Asgn_c with pp ;    -- same as in v4.2.9 and v6
concrete productions
a::Asgn_c ::= at::ASGN   { a.pp = " " ++ at.lexeme ++ " " ; }
a::Asgn_c ::=            { a.pp = " " ; }



-- VarList
nonterminal VarList_c with pp, ast<Decls>, inTypeExpr, inVis ;   -- same as v4.2.9 and v6
synthesized attribute cst_VarList_c::VarList_c occurs on Decls ;
autocopy attribute inTypeExpr::TypeExpr ;

concrete production one_var_c
vl::VarList_c ::= iv::IVar_c
{ vl.pp = iv.pp ;      vl.ast = iv.ast ;   
}
concrete production cons_var_c
vl::VarList_c ::= iv::IVar_c ',' rest::VarList_c
{ vl.pp = iv.pp ++ " ," ++ rest.pp ; 
  vl.ast = seqDecls(iv.ast, rest.ast) ;   
}


-- IVar
nonterminal IVar_c with pp, ast<Decls>, inTypeExpr, inVis;   -- same as in v4.2.9 and v6
synthesized attribute cst_IVar_c::IVar_c occurs on Decls ;

concrete production ivar_vardcl_c
iv::IVar_c ::= vd::VarDcl_c
{ iv.pp = vd.pp ; 
  iv.ast = varDecl (iv.inVis, iv.inTypeExpr, vd.ast ) ;
}
concrete production ivar_vardcl_assign_expr_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN e::Expr_c
{ iv.pp = vd.pp ++ " = " ++ e.pp ; 
  iv.ast = varAssignDecl (iv.inVis, iv.inTypeExpr, vd.ast, e.ast) ;
}
concrete production ivar_vardcl_assign_ch_init_c
iv::IVar_c ::= vd::VarDcl_c a::ASGN ch::ChInit_c
{ iv.pp = vd.pp ++ " = " ++ ch.pp ; 
  iv.ast = varAssignDecl (iv.inVis, iv.inTypeExpr, vd.ast, exprChInit(ch.ast)) ;
}

-- ChInit
nonterminal ChInit_c with pp, ast<ChInit> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_ChInit_c::ChInit_c occurs on ChInit ;

concrete production ch_init_c 
ch::ChInit_c ::= '[' c::CONST ']' o::OF '{' tl::TypList_c '}'
{ ch.pp = "[ " ++ c.lexeme ++ " ]" ++ " of " ++ " { " ++ tl.pp ++ " } ";
  ch.ast = chInit(c, tl.ast);
}


--VarDcl_c
nonterminal VarDcl_c with pp, ppi, ast<Declarator> ;   -- same as in v4.2.9 and v6
synthesized attribute cst_VarDcl_c::VarDcl_c occurs on Declarator ;

concrete production vd_id_c
vd::VarDcl_c ::= id::ID
{ vd.pp = id.lexeme;     
  vd.ast = vd_id(id);  }

concrete production vd_idconst_c
vd::VarDcl_c ::= id::ID ':' cnt::CONST
{ vd.pp = id.lexeme ++ ":" ++ cnt.lexeme;
  vd.ast = vd_idconst(id,cnt);   }

concrete production vd_array_c
vd::VarDcl_c ::= id::ID '[' cnt::CONST ']'
{ vd.pp = id.lexeme ++ "[" ++ cnt.lexeme ++ "]";
  vd.ast = vd_array(id,cnt);  }


-- Vis, visibility
nonterminal Vis_c with pp, ast<Vis> ;  -- same as in v4.2.9 and v6
synthesized attribute cst_Vis_c::Vis_c occurs on Vis ;

concrete production vis_empty_c  
v::Vis_c ::= 
{ v.pp = "" ; v.ast = vis_empty() ; }
concrete production vis_hidden_c  
v::Vis_c ::= h::HIDDEN 
{ v.pp = "hidden" ;  v.ast = vis_hidden(); }
concrete production vis_show_c   
v::Vis_c ::= s::SHOW   
{ v.pp = "show" ;  v.ast = vis_show(); }
concrete production vis_islocal_c
v::Vis_c ::= i::ISLOCAL 
{ v.pp = "local" ;  v.ast = vis_islocal() ; }







--NameList
nonterminal IDList_c with pp, ast<IDList> ;   -- same as v4.2.9 and v6
synthesized attribute cst_IDList_c::IDList_c occurs on IDList ;
-- nlst in spin.y

concrete production singleName_c
nlst::IDList_c ::= n::ID
{ nlst.pp = n.lexeme;
  nlst.ast = singleName(n);
}

concrete production snocNames_c
nlst::IDList_c ::= some::IDList_c n::ID
{ nlst.pp = some.pp ++ n.lexeme;
  nlst.ast = snocNames( some.ast ,n );
}

concrete production commaNames_c  
nlst1::IDList_c ::= nlst2::IDList_c ','   -- commas are optional
{ nlst1.pp = nlst2.pp ++ ",";
  nlst1.ast = nlst2.ast ;
}



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------







--inherited attribute visibility::Vis;
--attribute visibility occurs on VarList_c,IDList_c;
--attribute visibility occurs on IVar_c,VarDcl_c;



--new attribute to forward to single declaration for multiple declarations
-- e.g. int a,b,c, is equivalent to int a,int b, int c;

--inherited attribute typein::Type;
--synthesized attribute treedcl::Decls;
--attribute typein occurs on VarList_c;
--attribute treedcl occurs on VarList_c;


-- Rename Type_c to TypeExpr_c ?

--concrete production typedecl_c
--od::OneDecl_c ::= t::Type_c vars::VarList_c
--{  od.pp = t.pp ++ " " ++ vars.pp;
{-  od.ast_Decls = vars.treedcl;
   od.ast_Unit = unitDecls(od.ast_Decls);

  production attribute childType::[Type] with ++;

  childType := [];

  -- vars.typein = t.typeexpr ;

  vars.typein = if length(childType) == 1
                then head(childType)
                else if length(childType) > 1
                     then error("A single variable can not have two base types")
                     else error(" Error: Undefined Type with empty childType ");

  vars.visibility = vis_empty();
 -}

  
--  childType = case t of 
--                   bt_uname_c(un) => named_type(un)
--                 | bitType_c(b) => promela_typeexpr(b.lexeme)
--                 | byteType_c(y) => promela_typeexpr("byte")
--                 | intType_c(i) => promela_typeexpr("int")
--                 | shortType_c(s) => promela_typeexpr("short")
--                 | mtypeType_c(m) => promela_typeexpr("mtype")
--                 | chanType_c(c) => promela_typeexpr("chan")
--                 | pidType_c(p) => promela_typeexpr("pid")
--                 | boolType_c(l) => promela_typeexpr("bool")
--                 | unsigned_c(u) => promela_typeexpr("unsigned")
--                end; 

--}




--newly added rule for message types -- not in original grammar

--concrete production tynameDecl_c
--od::OneDecl_c ::= t::Type_c a::Asgn_c lc::LCURLY nlist::IDList_c rc::RCURLY
--{ od.pp = od.ppi ++ t.pp ++ " " ++ a.pp ++ " { " ++ nlist.pp ++ " } ";

{-
  od.ast_Decls = case t of 
                   bitType_c(b) => mtypeDecl(vis_empty(),promela_typeexpr(b.lexeme),a.ast_Asgn,nlist.ast_IDList)
                 | byteType_c(y) => mtypeDecl(vis_empty(),promela_typeexpr("byte"),a.ast_Asgn,nlist.ast_IDList)
                 | intType_c(i) =>mtypeDecl(vis_empty(),promela_typeexpr("int"),a.ast_Asgn,nlist.ast_IDList)
                 | shortType_c(s) => mtypeDecl(vis_empty(),promela_typeexpr("short"),a.ast_Asgn,nlist.ast_IDList)
                 | mtypeType_c(m) => mtypeDecl(vis_empty(),promela_typeexpr("mtype"),a.ast_Asgn,nlist.ast_IDList)
                 | chanType_c(c) => mtypeDecl(vis_empty(),promela_typeexpr("chan"),a.ast_Asgn,nlist.ast_IDList)
                 | pidType_c(p) => mtypeDecl(vis_empty(),promela_typeexpr("pid"),a.ast_Asgn,nlist.ast_IDList)
                 | boolType_c(l) => mtypeDecl(vis_empty(),promela_typeexpr("bool"),a.ast_Asgn,nlist.ast_IDList)
                 | unsigned_c(u) => mtypeDecl(vis_empty(),promela_typeexpr("unsigned"),a.ast_Asgn,nlist.ast_IDList)
                 | _ => error(" The base type not defined " ++ t.pp )
                end; 


  od.ast_Unit = unitDecls(od.ast_Decls);
  nlist.visibility = vis_empty();
-}
--}





{-
aspect production typedecl_c
od::OneDecl_c ::= t::Type_c vars::VarList_c
{


 childType <- if match(t,bt_uname_c(_))
              then [t.ast_Type]
              else if match(t,bitType_c(_))
              then [promela_typeexpr("bit")]
              else if match(t,byteType_c(y))
                   then [promela_typeexpr("byte")]
                   else if match(t,intType_c(_))
                        then [promela_typeexpr("int")]
                        else if match(t,shortType_c(_))
                             then [promela_typeexpr("short")]
                             else if match(t,mtypeType_c(_))
                                  then [promela_typeexpr("mtype")]
                                  else if match(t,chanType_c(_))
                                       then [promela_typeexpr("chan")]
                                       else if match(t,pidType_c(_))
                                            then [promela_typeexpr("pid")]
                                            else if match(t,boolType_c(_))
                                                 then [promela_typeexpr("bool")]
                                                 else if match(t,unsigned_c(_))
                                                      then [promela_typeexpr("unsigned")]
                                                      else [::Type];

}
-}







--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--  ALWAYS COMMENTED BELOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--concrete production typedecl_c
--od::OneDecl_c ::= t::TYPE vars::VarList_c
--{
-- od.pp = t.lexeme ++ " " ++ vars.pp ;
--
-- vars.typein = promela_typeexpr(t);
-- od.ast_Decls = vars.treedcl;
-- od.ast_Unit = unitDecls(od.ast_Decls);
--
----New attribute for visibility information 
--
-- vars.visibility = vis_empty();
--  
--
--}

--concrete production typeDcl_c
--od::OneDecl_c ::= v::Vis_c t::TYPE vars::VarList_c
--{ 
--  od.pp = od.ppi ++ v.pp ++ " " ++ t.lexeme ++ " " ++ vars.pp ; 
--
--  vars.typein = promela_typeexpr(t);
--  od.ast_Decls = vars.treedcl;
--  od.ast_Unit = unitDecls(od.ast_Decls);   
--  vars.visibility = v.ast_Vis;
--}

-- newly added rule to avoid conflict because of Vis = empty - not in original grammar

-- following two productions are commented as BaseType = UNAME ..
-- above productions to be modified to include typein attribute using pattern matching on BaseType


--concrete production unameDecl_c
--od::OneDecl_c ::= u::UNAME vars::VarList_c
--{
--  od.pp = od.ppi ++ u.lexeme ++ " " ++ vars.pp;
--
--  vars.typein = named_type(u);
--
--  od.ast_Decls = vars.treedcl ;
--  od.ast_Unit = unitDecls(od.ast_Decls);
--  vars.visibility = vis_empty();
--
--}
--
--
--
--concrete production unameDcl_c
--od::OneDecl_c ::= v::Vis_c u::UNAME vars::VarList_c
--{
--  od.pp = od.ppi ++ v.pp ++ " " ++ u.lexeme ++ " " ++ vars.pp ;
--  od.ast_Decls = vars.treedcl; 
--  od.ast_Unit = unitDecls(od.ast_Decls);
--  vars.visibility = v.ast_Vis;
--
--}










