grammar edu:umn:cs:melt:ableP:concretesyntax;

--Decl

nonterminal Decl_c with pp, ppi;
--synthesized attribute ast_Decls::Decls occurs on Decl_c, OneDecl_c, DeclList_c;


concrete production empty_Decl_c
dcl::Decl_c ::= 
{ dcl.pp = "";
-- dcl.ast_Decls = empty_Decl();
}

concrete production decllist_c
dcl::Decl_c ::= dcllist::DeclList_c
{ dcl.pp = dcllist.pp;
  dcllist.ppi = "";
-- dcl.ast_Decls = dcllist.ast_Decls ;
}

--DeclList

nonterminal DeclList_c with pp, ppi;

concrete production single_Decl_c
dcllist::DeclList_c ::= dcl::OneDecl_c
{ dcllist.pp = "  " ++ dcl.pp;
  dcl.ppi = dcllist.ppi;
-- dcllist.ast_Decls = dcl.ast_Decls ;
}

concrete production multi_Decl_c
dcllist1::DeclList_c ::= dcl::OneDecl_c sc::SEMI dcllist2::DeclList_c
{ dcllist1.pp =  dcl.pp ++ "; \n" ++ dcllist1.ppi ++  dcllist2.pp;
  dcl.ppi = dcllist1.ppi;
  dcllist2.ppi = dcllist1.ppi;
-- dcllist1.ast_Decls = seqDecls(dcl.ast_Decls, dcllist2.ast_Decls);
}


--One Decl

nonterminal OneDecl_c with pp, ppi ;


--new attribute to forward to single declaration for multiple declarations
-- e.g. int a,b,c, is equivalent to int a,int b, int c;

--inherited attribute typein::Type;
--synthesized attribute treedcl::Decls;
--attribute typein occurs on VarList_c;
--attribute treedcl occurs on VarList_c;


-- Rename BaseType_c to TypeExpr_c ?

concrete production typedecl_c
od::OneDecl_c ::= t::BaseType_c vars::VarList_c
{  od.pp = t.pp ++ " " ++ vars.pp;
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

}

{-
aspect production typedecl_c
od::OneDecl_c ::= t::BaseType_c vars::VarList_c
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


concrete production typeDcl_c
od::OneDecl_c ::= v::Vis_c t::BaseType_c vars::VarList_c
{ od.pp = od.ppi ++ v.pp ++ " " ++ t.pp ++ " " ++ vars.pp;
{-  
  vars.typein = case t of
                   bt_uname_c(un) => named_type(un)
                 | bitType_c(b) => promela_typeexpr(b.lexeme)
                 | byteType_c(y) => promela_typeexpr("byte")
                 | intType_c(i) => promela_typeexpr("int")
                 | shortType_c(s) => promela_typeexpr("short")
                 | mtypeType_c(m) => promela_typeexpr("mtype")
                 | chanType_c(c) => promela_typeexpr("chan")
                 | pidType_c(p) => promela_typeexpr("pid")
                 | boolType_c(l) => promela_typeexpr("bool")
                 | unsigned_c(u) => promela_typeexpr("unsigned")
                end;   

  od.ast_Decls = vars.treedcl;
  od.ast_Unit = unitDecls(od.ast_Decls);
  vars.visibility = v.ast_Vis;
-}
}


concrete production tynameDecl_c
od::OneDecl_c ::= t::BaseType_c a::Asgn_c lc::LCURLY nlist::IDList_c rc::RCURLY
{ od.pp = od.ppi ++ t.pp ++ " " ++ a.pp ++ " { " ++ nlist.pp ++ " } ";

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
}


concrete production typenameDcl_c
od::OneDecl_c ::= v::Vis_c t::BaseType_c a::Asgn_c lc::LCURLY namelist::IDList_c rc::RCURLY
{ od.pp = od.ppi ++ v.pp ++ " " ++ t.pp ++ a.pp  ++ " { " ++ namelist.pp ++ " } ";
{-
 od.ast_Decls = case t of 
                   bitType_c(b) => mtypeDecl(vis_empty(),promela_typeexpr(b.lexeme),a.ast_Asgn,namelist.ast_IDList)
                 | byteType_c(y) => mtypeDecl(vis_empty(),promela_typeexpr("byte"),a.ast_Asgn,namelist.ast_IDList)
                 | intType_c(i) =>mtypeDecl(vis_empty(),promela_typeexpr("int"),a.ast_Asgn,namelist.ast_IDList)
                 | shortType_c(s) => mtypeDecl(vis_empty(),promela_typeexpr("short"),a.ast_Asgn,namelist.ast_IDList)
                 | mtypeType_c(m) => mtypeDecl(vis_empty(),promela_typeexpr("mtype"),a.ast_Asgn,namelist.ast_IDList)
                 | chanType_c(c) => mtypeDecl(vis_empty(),promela_typeexpr("chan"),a.ast_Asgn,namelist.ast_IDList)
                 | pidType_c(p) => mtypeDecl(vis_empty(),promela_typeexpr("pid"),a.ast_Asgn,namelist.ast_IDList)
                 | boolType_c(l) => mtypeDecl(vis_empty(),promela_typeexpr("bool"),a.ast_Asgn,namelist.ast_IDList)
                 | unsigned_c(u) => mtypeDecl(vis_empty(),promela_typeexpr("unsigned"),a.ast_Asgn,namelist.ast_IDList)
                 | _ => error(" The base type not defined " ++ t.pp )
                end; 

 od.ast_Unit = unitDecls(od.ast_Decls);
 namelist.visibility = v.ast_Vis;
-}
}


--NameList

nonterminal IDList_c with pp;
--synthesized attribute ast_IDList::IDList occurs on IDList_c;

concrete production singleName_c
nlst::IDList_c ::= n::ID
{ nlst.pp = n.lexeme;
-- nlst.ast_IDList = singleName(n);
}


concrete production multiNames_c
nlst1::IDList_c ::= nlst2::IDList_c n::ID
{ nlst1.pp = nlst2.pp ++ n.lexeme;
-- nlst1.ast_IDList = multiNames(nlst2.ast_IDList,n);
}

concrete production commaNames_c
nlst1::IDList_c ::= nlst2::IDList_c ','
{ nlst1.pp = nlst2.pp ++ ",";
-- nlst1.ast_IDList = commaNames(nlst2.ast_IDList);
}

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



--newly added rule for message types -- not in original grammar



--concrete production tynameDecl_c
--od::OneDecl_c ::= t::TYPE a::Asgn_c lc::LCURLY nlist::IDList_c rc::RCURLY
--{
-- od.pp = od.ppi ++ t.lexeme ++ " " ++ a.pp ++ " { " ++ nlist.pp ++ " } ";
--
--  od.ast_Decls = mtypeDecl(vis_empty(), promela_typeexpr(t), a.ast_Asgn, nlist.ast_IDList);
--  od.ast_Unit = unitDecls(od.ast_Decls);
--  nlist.visibility = vis_empty();
--}



--concrete production typenameDcl_c
--od::OneDecl_c ::= v::Vis_c t::TYPE a::Asgn_c lc::LCURLY namelist::IDList_c rc::RCURLY
--{
-- od.pp = od.ppi ++ v.pp ++ " " ++ t.lexeme ++ a.pp  ++ " { " ++ namelist.pp ++ " } ";
--
-- od.ast_Decls = mtypeDecl(v.ast_Vis, promela_typeexpr(t), a.ast_Asgn, namelist.ast_IDList);
-- od.ast_Unit = unitDecls(od.ast_Decls);
-- namelist.visibility = v.ast_Vis;
--}







