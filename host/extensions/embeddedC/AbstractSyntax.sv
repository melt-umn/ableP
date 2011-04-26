grammar edu:umn:cs:melt:ableP:host:extensions:embeddedC ;

abstract production unitCcmpd
u::Unit ::= cc::Ccmpd
{ u.pp = "\n" ++ cc.pp ;
  u.errors :=  [ ] ;
  u.defs = emptyDefs() ;
  u.uses = [ ] ;
  u.host = unitCcmpd(cc) ;
  u.inlined = unitCcmpd(cc) ;
}

abstract production unitCdcls
u::Unit ::= cc::Cdcls
{ u.pp = "\n" ++ cc.pp ;
  u.errors :=  [ ] ;
  u.defs = emptyDefs() ;
  u.uses = [ ] ;
  u.host = unitCdcls(cc) ;
  u.inlined = unitCdcls(cc) ;
}

abstract production cStateTrack
u::Unit ::= kwd::String str1::String str2::String str3::String
{ u.pp = kwd ++ " " ++ str1 ++ " " ++ str2 ++ " " ++ str3 ;
  u.errors := [ ] ;
  u.defs = emptyDefs() ;
  u.uses = [ ] ;
  u.host = cStateTrack(kwd, str1, str2, str3) ;
  u.inlined = cStateTrack(kwd, str1, str2, str3) ;
}

nonterminal Ccmpd with pp, errors, host<Ccmpd>, inlined<Ccmpd> ;
nonterminal Cdcls with pp, errors, host<Cdcls>, inlined<Cdcls> ;

abstract production cCmpd
cc::Ccmpd ::= kwd::C_CODE cmpd::String
{ cc.pp = kwd.lexeme ++ "{ " ++  cmpd ++ " }";
  cc.errors := [];
  cc.host = cCmpd(kwd,cmpd);
  cc.inlined = cCmpd(kwd,cmpd);
}

abstract production cExprCmpd
cc::Ccmpd ::= kwd::C_CODE expr::String cmpd::String
{ cc.pp = kwd.lexeme ++ " [ " ++ expr ++ " ] { " ++ cmpd ++ " } " ;
  cc.errors := [];
  cc.host = cExprCmpd(kwd,expr,cmpd);
  cc.inlined = cExprCmpd(kwd,expr,cmpd);
}

abstract production cDcls
c::Cdcls ::= kwd::C_DECL dcl::String
{ c.pp = kwd.lexeme ++ " { " ++ dcl ++ " } " ;
  c.errors := [] ;
  c.host = cDcls(kwd,dcl);
  c.inlined = cDcls(kwd,dcl);
}

abstract production stmtCode
s::Stmt ::= cc::Ccmpd
{ s.pp = cc.pp ;
  s.errors := [] ;
  s.defs = emptyDefs(); 
  s.host = stmtCode(cc) ;
  s.inlined = stmtCode(cc) ;
}

-- 3 forms for including C expressions in Promela expressions.
abstract production exprCExpr
exp::Expr ::= kwd::C_EXPR ce::String
{ exp.pp =  kwd.lexeme ++ "{" ++ ce ++ "}" ;
  exp.errors := [ ];
  exp.uses = [ ] ; 
  exp.host = exprCExpr(kwd, ce);
  exp.inlined = exprCExpr(kwd, ce);

  exp.typerep = intTypeRep() ;
}

abstract production exprCCmpd
exp::Expr ::= kwd::C_EXPR ce::String
{ exp.pp = kwd.lexeme ++ "{" ++ ce ++ "}" ;
  exp.errors := [ ] ;
  exp.uses = [ ] ; 
  exp.host = exprCCmpd(kwd, ce);
  exp.inlined = exprCCmpd(kwd, ce);

  exp.typerep = intTypeRep() ;
}

abstract production exprCExprCmpd
exp::Expr ::= kwd::C_EXPR ce::String cp::String
{ exp.pp = kwd.lexeme ++ "[" ++ ce ++ "] {" ++ cp ++ "}" ;
  exp.errors := [ ] ;
  exp.uses = [ ] ; 
  exp.host = exprCExprCmpd(kwd, ce, cp);
  exp.inlined = exprCExprCmpd(kwd, ce, cp);

  exp.typerep = intTypeRep() ;
}
