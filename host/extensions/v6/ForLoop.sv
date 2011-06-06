grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

-- This files contains the abstract syntax for the new for-loop
-- and aspects on its concrete syntax to generate the abstract syntax.

-- For loop --
--------------
abstract production forRange
s::Stmt ::= f::FOR vr::Expr lower::Expr upper::Expr body::Stmt
{ s.pp = "for ( " ++ vr.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ")" ++
         " {\n" ++ body.pp ++ "\n} ;" ;

  s.errors := vr.errors ++ lower.errors ++ upper.errors ++ body.errors ;

  {- do :: $vr <= $upper ->  $body
        :: else -> goto $label ;
     $label : skip();
   -}
  
  forwards to 
   seqStmt ( doStmt ( consOption (
                        seqStmt ( exprStmt ( genericBinOp(vr, op, upper) ) ,
                                  body
                                ) ,
                      oneOption ( 
                        seqStmt ( elseStmt() ,
                                  gotoStmt (label)
                                ) 
                      ) ) ) ,
             labeledStmt ( label, skipStmt () )
           ) ;
  local op::Op = mkOp("<=", boolTypeExpr()) ;
  local label::ID = terminal(ID,"l"++toString(f.line), f.line, f.column) ;
}


abstract production forIn
s::Stmt ::= f::FOR vr::Expr e::Expr body::Stmt
{ s.pp = "for ( " ++ vr.pp ++ " in " ++ e.pp ++ ")" ++
         " {\n" ++ body.pp ++ "\n} ;" ;

  s.errors := vr.errors ++ e.errors ++ body.errors ;
  -- ToDo - verify that e is an array.
  local tr::TypeRep = e.typerep ;

  {- $vr = 0 ;
     do :: ( $vr <= $array_size ) ->
           $body
           $vr = $vr + 1;
        :: else -> goto $label ;
     od;
     $label: skip() ;
   -}
  forwards to
    seqStmt (
      assign ( vr, asnOp, zero),
      seqStmt (
        doStmt ( consOption (
                   seqStmt (
                     exprStmt(genericBinOp(vr, mkOp("<=",boolTypeExpr()), array_size)) ,
                     seqStmt (
                       body,
                       assign ( vr, asnOp, 
                                genericBinOp(vr, mkOp("+",intTypeExpr()), one)
                       )
                     )
                   )
                   ,
                   oneOption (
                     seqStmt (
                       elseStmt(),
                       gotoStmt (label)
                     )
                   )
                 )
        ) ,
        labeledStmt(label, skipStmt())
      )
    ) ;

  local array_size::Expr 
    = constExpr(terminal(CONST, toString(
         case e.typerep of
           arrayTypeRep(_,sz) -> sz
         | _ -> 0 end) ,
         f.line, f.column) ) ;
  local asnOp::ASGN = terminal(ASGN,"=", f.line, f.column) ;
  local one::Expr = constExpr(terminal(CONST,"1", f.line, f.column)) ;
  local zero::Expr = constExpr(terminal(CONST,"0", f.line, f.column)) ;
  local op::Op = mkOp("<=", boolTypeExpr()) ;
  local label::ID = terminal(ID,"l"++toString(f.line), f.line, f.column) ;


--  s.host = forIn(f,vr.host, e.host,body.host) ;
--  s.inlined = forIn(f,vr.inlined, e.inlined,body.inlined) ;
}






aspect production varRefExprAll
e::Expr ::= id::ID
{ overloads <- if id.lexeme == "in" then [ varInRefExpr(id, eres) ] else [ ] ;
}

abstract production varInRefExpr
e::Expr ::= id::ID eres::EnvResult
{ e.pp = id.lexeme ; 
  e.errors := if eres.found then [ ] 
              else [ mkError ("Id \"" ++ id.lexeme ++ "\" not declared" ,
                              mkLocID(id) ) ] ;
  e.typerep = eres.dcl.typerep ; 
  local dcl::Decorated Decls = eres.dcl ;

  local newRenamedID::ID 
    = terminal(ID, if eres.found then dcl.inRename else id.lexeme, 
               id.line, id.column) ;
  e.host = varRefExpr(id, eres) ; -- newRenamedID) ;

  -- We need to know if 'id' is an argument in an inline declaration
  -- body.  If so, we replace it with the actual argument from the
  -- inline call site. This expressions is part of the declaration,
  -- created for this call site, for the formal parameter.
  e.inlined = case eres.dcl of
                inlineArgDecl(_,ine) -> ine
              | _ -> varRefExpr(id, eres)  end ;

  forwards to varRefExpr(id, eres) ;
}

synthesized attribute inRename::String occurs on Decls, Declarator ;
aspect production defaultVarDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{ ds.inRename = v.inRename ; }
aspect production defaultVarAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{ ds.inRename = v.inRename ; }

{-
concrete production inVarDcl_c
vd::VarDcl_c ::= i::IN
{ vd.pp = i.lexeme;     
--  vd.ast = vd_id(i);  
}
-}

aspect production vd_id
vd::Declarator ::= id::ID
{ vd.inRename = id.lexeme ++ "_" ++ toString(id.line) ++
                "_" ++ toString(id.column);    }
aspect production vd_idconst
vd::Declarator ::= id::ID cnt::CONST
{ vd.inRename = id.lexeme ++ "_" ++ toString(id.line) ++
                "_" ++ toString(id.column);    }
aspect production vd_array
vd::Declarator ::= id::ID cnt::CONST
{ vd.inRename = id.lexeme ++ "_" ++ toString(id.line) ++
                "_" ++ toString(id.column);    }


-- Aspects on concrete syntax for for-loops --
----------------------------------------------
attribute pp, ppi occurs on ForPre_c ; 
attribute ast<Expr> occurs on ForPre_c ; 
attribute forTerminal occurs on ForPre_c ; 

aspect production forPre_c
fp::ForPre_c ::= f::FOR '(' v::Varref_c 
{ fp.pp = "for (" ++ v.pp ; 
  fp.ast = v.ast ; 
  fp.forTerminal = f ;
}

attribute pp, ppi occurs on ForPost_c ;
attribute ast<Stmt> occurs on ForPost_c ;

aspect production forPost_c
fp::ForPost_c ::= '{' s::Sequence_c os::OS_c '}'
{ fp.pp = "{\n" ++ s.ppi ++ s.pp ++ os.pp ++ "\n" ++ fp.ppi ++ "}" ; 
  s.ppi = "  " ++ fp.ppi ;
  fp.ast = s.ast ;
}

aspect production forRange_c
s::Special_c ::= fpre::ForPre_c ':' lower::Expr_c '..' upper::Expr_c ')' 
                 fpost::ForPost_c 
{ s.pp = fpre.pp ++ " : " ++ lower.pp ++ " .. " ++ upper.pp ++ ") " ++ fpost.pp ; 
  s.ast = forRange ( fpre.forTerminal, fpre.ast, lower.ast, upper.ast, fpost.ast ) ;
}

aspect production forIn_c
s::Special_c ::= fpre::ForPre_c 'in' v::Varref_c ')' fpost::ForPost_c 
{ s.pp = fpre.pp ++ " in " ++ v.pp ++ ") " ++ fpost.pp ; 
  s.ast = forIn(fpre.forTerminal, fpre.ast, v.ast, fpost.ast) ;
}


