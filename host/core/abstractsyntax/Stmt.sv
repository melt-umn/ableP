grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax ;

nonterminal Stmt with pp, ppi, ppsep, errors, host<Stmt>, inlined<Stmt> ;

-- Grouping: sequence, block ...
abstract production seqStmt
s::Stmt ::= s1::Stmt s2::Stmt
{ s.pp = s.ppi ++ s1.pp ++ s.ppsep ++ s2.pp ; 
  s.errors := s1.errors ++ s2.errors ;
  s1.env = s.env ;
  s2.env = mergeDefs(s1.defs, s.env) ;
  s.defs = mergeDefs(s1.defs, s2.defs) ;

  s.uses = s1.uses ++ s2.uses ;
  s.host = seqStmt(s1.host, s2.host);
  s.inlined = seqStmt(s1.inlined, s2.inlined);
}

abstract production blockStmt
s::Stmt ::= body::Stmt
{
 s.pp = "\n{\n" ++ body.ppi ++ body.pp ++ s.ppi ++ "\n}\n";
 body.ppi = s.ppi ++ " ";
 body.ppsep = "; \n" ;
 s.errors := body.errors ;
 s.host = blockStmt(body.host) ;
 s.inlined = blockStmt(body.inlined) ;
 s.defs = emptyDefs() ;
 body.env = s.env;
 s.uses = body.uses ;
}

abstract production one_decl
s::Stmt ::= d::Decls
{ s.pp = d.pp ; -- ++ " ";
  d.ppi = s.ppi ;
  d.ppsep = "; \n" ;
  s.errors := d.errors ;
  s.defs = d.defs;
  d.env = s.env ;
  s.uses = d.uses ;
  s.host = one_decl(d.host);
  s.inlined = one_decl(d.inlined);
}

-- Print statements
abstract production printStmt
s::Stmt ::= st::String es::Exprs
{ s.pp = s.ppi ++ "printf (" ++ st ++ 
          case es of
            noneExprs() -> " " 
          | _ -> ", " ++ es.pp end  ++
          ");\n" ;
 s.errors := es.errors ;
 s.defs = emptyDefs();
 s.uses = [ ] ;
 s.host = printStmt(st, es.host) ;
 s.inlined = printStmt(st, es.inlined) ;
}

abstract production printmStmt
s::Stmt ::= vref::Expr
{ s.pp = s.ppi ++ "printm" ++ "(" ++ vref.pp ++ ") ;\n";
  s.errors := vref.errors;
  s.defs = emptyDefs();
  s.uses = vref.uses ;
  s.host = printmStmt(vref.host) ;
  s.inlined = printmStmt(vref.inlined) ;
}
abstract production printmConstStmt
s::Stmt ::= cn::CONST
{ s.pp = s.ppi ++  "printm" ++ "(" ++ cn.lexeme ++ ") ;\n";
  s.errors := [ ];
  s.defs = emptyDefs();
  s.uses = [ ] ;
  s.host = printmConstStmt(cn) ;
  s.inlined = printmConstStmt(cn) ;
}


-- Control Flow                                 --
--------------------------------------------------
abstract production ifStmt
s::Stmt ::= op::Options 
{ s.pp = s.ppi ++ "if\n" ++ s.ppi ++ op.pp ++ "\n" ++ s.ppi ++ "fi ;\n";
  op.ppi = s.ppi ++ "  ";
  s.errors := op.errors;
  s.host = ifStmt(op.host);
  s.inlined = ifStmt(op.inlined);
  s.defs = emptyDefs();
  s.uses = op.uses ;
}

abstract production doStmt
s::Stmt ::= op::Options
{ s.pp = s.ppi ++ "do\n" ++ s.ppi ++ op.pp ++ s.ppi ++ "od ;\n";
  op.ppi = s.ppi ++ "  " ;
  s.errors := op.errors;
  s.defs = emptyDefs();
  s.uses = op.uses ;
  s.host = doStmt(op.host);
  s.inlined = doStmt(op.inlined);
}

abstract production breakStmt
s::Stmt ::=
{ s.pp = s.ppi ++ "break";
  s.errors := [ ];
  s.defs = emptyDefs();
  s.uses = [ ] ;
  s.host = breakStmt();
  s.inlined = breakStmt();
--  s.defs = emptyDefs();
}

abstract production gotoStmt
s::Stmt ::= id::ID
{ s.pp = s.ppi ++ "goto " ++ id.lexeme ++ " ;\n" ;
  s.errors := [ ];
  s.defs = emptyDefs();
  s.uses = [ ] ; --ToDo check that ID is valid, etc.
  s.host = gotoStmt(id);
  s.inlined = gotoStmt(id);
}

abstract production labeledStmt
s::Stmt ::= id::ID st::Stmt
{ s.pp = s.ppi ++ id.lexeme ++ ": " ++ st.pp;
  st.ppi = s.ppi;
  s.errors := st.errors;
  s.defs = emptyDefs();  --ToDo add ID to defs - but this has different scope than normal variables...
  s.uses = st.uses ;
  s.inlined = labeledStmt(id, st.inlined);
  s.host = labeledStmt(id, st.host);
}

abstract production elseStmt
s::Stmt ::= 
{ s.pp = s.ppi ++ "else ;\n";
  s.errors := [ ];
  s.defs = emptyDefs();
  s.uses = [ ] ;
  s.inlined = elseStmt();
  s.host = elseStmt();
}

abstract production skipStmt
s::Stmt ::= 
{ s.pp = s.ppi ++ "skip ;\n";
  s.errors := [ ];

  -- The Spin lexer replaces "skip" by the constant "1".  We do something similar
  -- hear using forwarding, but the transformation takes place on the syntax tree
  -- after parsing instead.
  forwards to exprStmt( constExpr (terminal(CONST,"1")) ) ;
}

-- Options --
nonterminal Options with pp, ppi, ppsep, errors, host<Options>, inlined<Options> ;
abstract production oneOption
ops::Options ::= s::Stmt
{ ops.pp = ":: " ++ s.pp;
  s.ppi = ops.ppi ++ "   " ;
  ops.errors := s.errors;
  ops.defs = emptyDefs();
  ops.uses = s.uses ;
  ops.host = oneOption(s.host);
  ops.inlined = oneOption(s.inlined);
}

abstract production consOption
ops::Options ::= s::Stmt rest::Options
{ ops.pp = ":: " ++ s.pp ++ ops.ppi ++ rest.pp;
  s.ppi = ops.ppi ++ "   ";
  rest.ppi = ops.ppi;
  ops.errors := s.errors ++ rest.errors;

  s.env = ops.env ;
  rest.env = mergeDefs(s.defs, ops.env) ;
  ops.defs = mergeDefs(s.defs, rest.defs) ;

  ops.uses = s.uses ++ rest.uses ;

  ops.host = consOption(s.host, rest.host);
  ops.inlined = consOption(s.inlined, rest.inlined);
}



-- Message sends and receives                   --
--------------------------------------------------
abstract production sndStmt
sc::Stmt ::= vref::Expr op::String ma::MArgs
{ -- op is either "!" or "!!", one of the two kinds of snd operators.
  sc.pp =  vref.pp ++ op ++ ma.pp ; --++ " ;\n" ;
  sc.errors := vref.errors ++ ma.errors ; 
  sc.defs = emptyDefs();
  sc.uses = vref.uses ++ ma.uses ;
  sc.host = sndStmt (vref.host, op, ma.host) ;
  sc.inlined = sndStmt (vref.inlined, op, ma.inlined) ;
}

abstract production rcvStmt
sc::Stmt ::= vref::Expr op::String ra::RArgs
{ -- op is either "?", "??", "?<>", or "??<>"
  -- one of the four kinds of rcv operators.
  sc.pp =  vref.pp ++ op ++ ra.pp ; --  ++ " ;\n" ;
  sc.errors := vref.errors ++ ra.errors ; 
  sc.defs = emptyDefs();
  sc.uses = vref.uses ++ ra.uses ;
  sc.host = rcvStmt (vref.host, op, ra.host) ;
  sc.inlined = rcvStmt (vref.inlined, op, ra.inlined) ;
}


-- Block-type statements                        --
--------------------------------------------------
abstract production atomicStmt
s::Stmt ::= b::Stmt
{ s.pp = "atomic { " ++  b.pp ++ " } ";
  s.errors := b.errors ;
  s.defs = emptyDefs();
  s.host = atomicStmt(b.host) ;
  s.inlined = atomicStmt(b.inlined) ;
}

abstract production dstepStmt
s::Stmt ::= b::Stmt
{ s.pp = "d_step { " ++  b.pp ++ " } ";
  s.errors := b.errors ;
  s.defs = emptyDefs();
  s.host = dstepStmt(b.host) ;
  s.inlined = dstepStmt(b.inlined) ;
}

-- Assignments, increments, side-effects        --
--------------------------------------------------
abstract production assign
s::Stmt ::= lhs::Expr rhs::Expr 
{ s.pp = s.ppi ++ lhs.pp ++ " = " ++ rhs.pp ;
  production attribute overloads :: [Stmt] with ++ ;
  overloads := [ ] ;

  forwards to if null(overloads) then defaultAssign(lhs,rhs) 
              else head(overloads) ;
}

abstract production defaultAssign
s::Stmt ::= lhs::Expr rhs::Expr 
{ s.pp = s.ppi ++ lhs.pp ++ " = " ++ rhs.pp ++ " ;\n" ; 
  s.errors := lhs.errors ++ rhs.errors ;
  s.defs = emptyDefs();
  s.uses = lhs.uses ++ rhs.uses ;
  s.host = assign(lhs.host, rhs.host) ;
  s.inlined = assign(lhs.inlined, rhs.inlined) ;
}

abstract production incrStmt
st::Stmt ::= vref::Expr
{ st.pp = vref.pp ++ "++";
  st.errors := vref.errors;
  st.defs = emptyDefs();
  st.host = incrStmt(vref.host);
  st.inlined = incrStmt(vref.inlined);
}
abstract production decrStmt
st::Stmt ::= vref::Expr
{ st.pp = vref.pp ++ "--";
  st.errors := vref.errors;
  st.defs = emptyDefs();
  st.host = decrStmt(vref.host);
  st.inlined = decrStmt(vref.inlined);
}

-- Misc. Statements                             --
--------------------------------------------------
abstract production exprStmt
s::Stmt ::= e::Expr
{ s.pp =  e.pp ; -- ++ " ;\n" ;
  s.errors := e.errors;
  s.defs = emptyDefs();
  s.uses = e.uses ;
  s.host = exprStmt(e.host);
  s.inlined = exprStmt(e.inlined);
}

abstract production assertStmt
st::Stmt ::= fe::Expr
{ st.pp = "assert " ++ fe.pp ;
  st.errors := fe.errors;
  st.defs = emptyDefs();
  st.host = assertStmt(fe.host) ;
  st.inlined = assertStmt(fe.inlined) ;
}

abstract production unlessStmt
st::Stmt ::= st1::Stmt st2::Stmt
{ st.pp = st1.pp ++ " unless " ++ st2.pp ++ "\n" ;
  st.errors := st1.errors ++ st2.errors;
  st.defs = emptyDefs();
  st.host = unlessStmt(st1.host, st2.host);
  st.inlined = unlessStmt(st1.inlined, st2.inlined);
}

-- ToDo.  Fix semantics here.
abstract production xuStmt
st::Stmt ::= xu::XU vlst::Exprs
{ st.pp = xu.lexeme ++ " " ++ vlst.pp ;
  st.errors := vlst.errors ;
  st.defs = emptyDefs() ; 
  st.host = xuStmt(xu, vlst.host);
  st.inlined = xuStmt(xu, vlst.inlined);
}

-- ToDo.  Fix semantics here.
abstract production namedXUStmt
st::Stmt ::= id::ID xu::XU
{ st.pp = id.lexeme ++ ":" ++ xu.lexeme ;
  st.errors := [ ] ;
  st.defs = emptyDefs() ;
  st.host = namedXUStmt(id, xu);
  st.inlined = namedXUStmt(id, xu);
}

-- ToDo.  Fix semantics here.
abstract production namedDecl
st::Stmt ::= id::ID d::Decls
{ st.pp = id.lexeme ++ ":" ++ d.pp  ;
  st.errors := d.errors;
  st.defs = d.defs;
  st.host = namedDecl(id, d.host) ;
  st.inlined = namedDecl(id, d.inlined) ;
}
