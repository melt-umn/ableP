grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

-- Message arguments for sending
nonterminal MArgs with pp, errors, host<MArgs>, inlined<MArgs> ;

-- ToDo: The following are the same.
abstract production margsSeq
ma::MArgs ::= es::Exprs
{ ma.pp = es.pp;
  ma.errors := es.errors ;
  ma.uses = es.uses ;
  ma.host = margsSeq(es.host) ;
  ma.inlined = margsSeq(es.inlined) ;
  ma.transformed = applyARewriteRule(ma.rwrules_MArgs, ma,
                    margsSeq ( es.transformed ));
}

abstract production margsPattern
ma::MArgs ::= es::Exprs
{ ma.pp = es.pp;
  ma.errors := es.errors ;
  ma.uses = es.uses ;
  ma.host = margsPattern(es.host) ;
  ma.inlined = margsPattern(es.inlined) ;
  ma.transformed = applyARewriteRule(ma.rwrules_MArgs, ma,
                    margsPattern ( es.transformed ));
}

-- Message arguments for receiving
nonterminal RArgs with pp, errors, host<RArgs>, inlined<RArgs> ;

abstract production oneRArg
ras::RArgs ::= ra::RArg
{ ras.pp = ra.pp;  
  ras.errors := ra.errors ; 
  ras.uses = ra.uses ;
  ras.host = oneRArg(ra.host) ; 
  ras.inlined = oneRArg(ra.inlined) ; 
  ras.transformed = applyARewriteRule(ras.rwrules_RArgs, ras,
                       oneRArg ( ra.transformed ));
}
abstract production consRArg
ras::RArgs ::= ra::RArg rest::RArgs
{ ras.pp = ra.pp ++ " , " ++ rest.pp;  
  ras.errors := ra.errors ++ rest.errors ;
  ras.uses = ra.uses ++ rest.uses ;
  ras.host = consRArg(ra.host, rest.host);  
  ras.inlined = consRArg(ra.inlined, rest.inlined);  
  ras.transformed = applyARewriteRule(ras.rwrules_RArgs, ras,
                       consRArg ( ra.transformed, rest.transformed ));
}
abstract production consParenRArg
ras::RArgs ::= ra::RArg rest::RArgs
{ ras.pp = ra.pp ++ "(" ++ rest.pp ++ ")";
  ras.errors := ra.errors ++ rest.errors ;
  ras.uses = ra.uses ++ rest.uses ;
  ras.host = consParenRArg(ra.host, rest.host); 
  ras.inlined = consParenRArg(ra.inlined, rest.inlined);  
  ras.transformed = applyARewriteRule(ras.rwrules_RArgs, ras,
                       consParenRArg ( ra.transformed, rest.transformed ));
}

nonterminal RArg with pp, errors, host<RArg>, inlined<RArg> ;

abstract production varRArg
ra::RArg ::= vr::Expr
{ ra.pp = vr.pp;
  ra.errors := vr.errors ;
  ra.uses = vr.uses ;
  ra.host = varRArg(vr.host);   
  ra.inlined = varRArg(vr.inlined);   
  ra.transformed = applyARewriteRule(ra.rwrules_RArg, ra,
                       varRArg ( vr.transformed ));
}
abstract production evalRArg
ra::RArg ::= exp::Expr
{ ra.pp = "eval" ++ "(" ++ exp.pp ++ ")";
  ra.errors := exp.errors ;
  ra.uses = exp.uses ;
  ra.host = evalRArg(exp.host);   
  ra.inlined = evalRArg(exp.inlined);   
  ra.transformed = applyARewriteRule(ra.rwrules_RArg, ra,
                       evalRArg ( exp.transformed ));
}
abstract production constRArg
ra::RArg ::= cst::CONST
{ ra.pp = cst.lexeme;
  ra.errors := [ ];
  ra.uses = [ ] ;
  ra.host = constRArg(cst) ;
  ra.inlined = constRArg(cst) ;
  ra.transformed = applyARewriteRule(ra.rwrules_RArg, ra, 
                       constRArg ( cst ));
}
abstract production negConstRArg
ra::RArg ::= cst::CONST
{ ra.pp = "-" ++ cst.lexeme;
  ra.errors := [ ];
  ra.uses = [ ]  ;
  ra.host = negConstRArg(cst) ; 
  ra.inlined = negConstRArg(cst) ; 
  ra.transformed = applyARewriteRule(ra.rwrules_RArg, ra, 
                       negConstRArg ( cst ));
}
