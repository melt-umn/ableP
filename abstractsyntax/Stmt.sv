grammar edu:umn:cs:melt:ableP:abstractsyntax ;

nonterminal Stmt with pp, ppi, errors, host<Stmt> ;

abstract production seqStmt
s::Stmt ::= s1::Stmt s2::Stmt
{ s.pp = s1.pp ++ "\n" ++ s2.pp ; 
  s.host = seqStmt(s1.host, s2.host);
}

abstract production one_decl
s::Stmt ::= d::Decls
{ s.pp = d.pp ; -- ++ " ";
  d.ppi = s.ppi ;
  d.ppsep = "" ; -- ;" \n" ;
  s.host = one_decl(d.host);
--  s.errors := d.errors;
--  s.defs = d.defs;
--  d.env = s.env ;
}


abstract production printStmt
s::Stmt ::= st::String es::Exprs
{ s.pp = s.ppi ++ "printf (" ++ st ++ 
          case es of
            noneExprs() -> " " 
          | _ -> ", " ++ es.pp end  ++
          ");\n" ;
 s.host = printStmt(st, es.host);
}

abstract production assign
s::Stmt ::= lhs::Expr rhs::Expr 
{ s.pp = s.ppi ++ lhs.pp ++ " = " ++ rhs.pp ++ " ;\n" ; 
  s.host = assign(lhs.host, rhs.host) ;
}

-- Control Flow                                 --
--------------------------------------------------
abstract production ifStmt
s::Stmt ::= op::Options 
{ s.pp = "if\n" ++ s.ppi ++ op.pp ++ "\n" ++ s.ppi ++ "fi ;\n";
  op.ppi = s.ppi;
  s.errors := op.errors;
  s.host = ifStmt(op.host);
--  sc.defs = emptyDefs();
--  op.env = sc.env;
}

abstract production doStmt
s::Stmt ::= op::Options
{ s.pp = "do\n" ++ s.ppi ++ op.pp ++ "\n" ++ s.ppi ++ "od ;\n";
  op.ppi = s.ppi;
  s.errors := op.errors;
  s.host = doStmt(op.host);
--  s.defs = emptyDefs();
--  op.env = s.env;
}

abstract production breakStmt
s::Stmt ::=
{ s.pp = "break";
  s.errors := [ ];
  s.host = breakStmt();
--  s.defs = emptyDefs();
}

abstract production gotoStmt
s::Stmt ::= id::ID
{ s.pp = s.ppi ++ "goto " ++ id.lexeme;
  s.errors := [ ];
  s.host = gotoStmt(id);
--  s.defs = emptyDefs();
}

abstract production labeledStmt
s::Stmt ::= id::ID st::Stmt
{ s.pp = id.lexeme ++ ": " ++ st.pp;
  st.ppi = s.ppi;
  s.errors := st.errors;
  s.host = labeledStmt(id, st.host);
--  s.defs = st.defs;
--  st.env = s.env;
}

abstract production elseStmt
s::Stmt ::= 
{ s.pp = "else ;\n";
  s.errors := [ ];
  s.host = elseStmt();
--  s.defs = emptyDefs();
}

abstract production skipStmt
s::Stmt ::= 
{ s.pp = "skip ;\n";
  s.errors := [ ];

  -- The Spin lexer replaces "skip" by the constant "1".  We do something similar
  -- hear using forwarding, but the transformation takes place on the syntax tree
  -- after parsing instead.
  forwards to exprStmt( constExpr (terminal(CONST,"1")) ) ;

--  s.defs = emptyDefs();
}

-- Options --
nonterminal Options with pp, ppi, errors, host<Options> ;
abstract production oneOption
ops::Options ::= s::Stmt
{ ops.pp = ":: " ++ s.pp;
  s.ppi = ops.ppi ++ "   " ;
  ops.errors := s.errors;
  ops.host = oneOption(s.host);
--  st.env = ops.env;
}

abstract production consOption
ops::Options ::= s::Stmt rest::Options
{ ops.pp = ":: " ++ s.pp ++ ops.ppi ++ rest.pp;
  s.ppi = ops.ppi ++ "   ";
  rest.ppi = ops.ppi;
  ops.errors := s.errors ++ rest.errors;
  ops.host = consOption(s.host, rest.host);
--  st.env = ops.env;
--  rest.env = ops.env;
}


-- Misc. Statements                             --
--------------------------------------------------
abstract production exprStmt
s::Stmt ::= e::Expr
{ s.pp =  e.pp ++ " ;\n" ;
  s.errors := e.errors;
  s.host = exprStmt(e.host);
--  s.defs = emptyDefs();
--  e.env = t.env;
}


{-
----------
grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal Asgn with basepp,pp;
nonterminal VrefList with basepp,pp;
nonterminal ChInit with basepp,pp;

abstract production asgn
a::Asgn ::= 
{
 a.basepp = "=";
 a.pp = "=";
}

abstract production asgn_empty
a::Asgn ::= 
{
 a.basepp = "";
 a.pp = "";
}

abstract production single_varref
vrl::VrefList ::= vref::Expr
{
  vrl.basepp = vref.basepp;
  vrl.pp = vref.basepp;
  vrl.errors = vref.errors;
  vref.env = vrl.env;
}

abstract production comma_varref
vrl1::VrefList ::= vref::Expr vrl2::VrefList
{
 vrl1.basepp = vref.basepp ++ "," ++ vrl2.basepp;
 vrl1.pp = vref.pp ++ "," ++ vrl2.pp;
 vrl1.errors = vref.errors ++ vrl2.errors;
 vref.env = vrl1.env;
 vrl2.env = vrl1.env;
}

grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal RArgs with basepp,pp;
nonterminal MArgs with basepp,pp;
nonterminal Options with basepp,ppi,pp;
nonterminal OS with basepp,pp;

abstract production stmt_seq
st::Stmt ::= s1::Stmt s2::Stmt
{
  st.pp = s1.pp ++ " ;\n" ++ st.ppi ++ s2.pp ;
  s1.ppi = st.ppi ;
  s2.ppi = st.ppi ;
  st.basepp = s1.basepp ++ " ;\n" ++ st.ppi ++ s2.basepp ;

  st.errors = s1.errors ++ s2.errors;
  st.defs = mergeDefs(s1.defs,s2.defs);
  s1.env = st.env;
  s2.env = mergeDefs(s1.defs,st.env);
}




abstract production vref_lst
st::Stmt ::= xu::XU vlst::VrefList
{
 st.pp = xu.lexeme ++ " " ++ vlst.pp ;
 st.basepp =  xu.lexeme ++ " " ++ vlst.basepp ;
 st.defs = emptyDefs() ; 
 st.errors = vlst.errors ;
}

-- ? - labeled statement ?
abstract production name_od
st::Stmt ::= id::ID d::Decls
{
 st.pp = id.lexeme ++ ":" ++ d.pp  ;
 d.ppi = "" ;
 d.ppsep = ", ";
 st.basepp = id.lexeme ++ ":" ++ d.basepp ;
 st.errors = d.errors;
 st.defs = d.defs;
 d.env = st.env ;
}

abstract production name_xu
st::Stmt ::= id::ID xu::XU
{
 st.pp = id.lexeme ++ ":" ++ xu.lexeme ;
 st.basepp = id.lexeme ++ ":" ++ xu.lexeme ;
}
-- Message sends and receives                   --
--------------------------------------------------

abstract production rcv_special
sc::Stmt ::= vref::Expr ra::RArgs
{
 sc.basepp = vref.basepp ++ "?" ++ ra.basepp ;

 sc.pp = vref.pp ++ "?" ++ ra.pp ;
 sc.errors = vref.errors ++ ra.errors;
 sc.defs = emptyDefs();
 vref.env = sc.env;
 ra.env = sc.env; 
}

abstract production snd_special
sc::Stmt ::= vref::Expr ma::MArgs
{
  sc.basepp = vref.basepp ++ "!" ++ ma.basepp ;  
  sc.pp =  vref.pp ++ "!" ++ ma.pp  ;
  sc.errors = vref.errors ++ ma.errors ; 
  sc.defs = emptyDefs();
  vref.env = sc.env;
  ma.env = sc.env;
}

abstract production rrcv_stmt
st::Stmt ::= vref::Expr ra::RArgs
{
  st.basepp = vref.basepp ++ "??" ++ ra.basepp ;
  st.pp = vref.pp ++ "??" ++ ra.pp ;
  st.errors = vref.errors ++ ra.errors;
  st.defs = emptyDefs();
  vref.env = st.env;
  ra.env = st.env;
}
abstract production rcv_stmt
st::Stmt ::= vref::Expr ra::RArgs
{
  st.basepp = vref.basepp ++ "? < " ++ ra.basepp ++ ">";
  st.pp = vref.pp ++ "? < " ++ ra.pp ++ ">";
  st.errors = vref.errors ++ ra.errors;
  st.defs = emptyDefs();
  vref.env = st.env;
  ra.env = st.env;
}

abstract production rrcv_poll
st::Stmt ::= vref::Expr ra::RArgs
{
  st.basepp = vref.basepp ++ "?? <" ++ ra.basepp ++ ">";
  st.pp = vref.pp ++ "?? <" ++ ra.pp ++ ">";
  st.errors = vref.errors ++ ra.errors;
  st.defs = emptyDefs();
  vref.env = st.env;
  ra.env = st.env;
}

abstract production snd_stmt
st::Stmt ::= vref::Expr ma::MArgs
{
  st.basepp = vref.basepp ++ "!!" ++ ma.basepp ;
  st.pp = vref.pp ++ "!!" ++ ma.pp ;
  st.errors = vref.errors ++ ma.errors;
  st.defs = emptyDefs();
  vref.env = st.env;
  ma.env = st.env;
}


-- Assignments, increments, side-effects        --
--------------------------------------------------
abstract production assign_stmt
st::Stmt ::= vref::Expr a1::ASGN exp::Expr
{
 st.pp = vref.pp ++ "=" ++ exp.pp ++ "" ;
 st.basepp = vref.basepp ++ "=" ++ exp.basepp ++ "" ;
 st.errors = vref.errors ++ exp.errors;
 st.defs = emptyDefs();
 vref.env = st.env;
 exp.env = st.env;
}


abstract production incr_stmt
st::Stmt ::= vref::Expr
{
  st.basepp =  vref.basepp ++ "++";

  st.pp = vref.pp ++ "++";
  st.errors = vref.errors;
  st.defs = emptyDefs();
  vref.env = st.env;
}
abstract production decr_stmt
st::Stmt ::= vref::Expr
{
 st.basepp =  vref.basepp ++ "--";

 st.pp = vref.pp ++ "--";
 st.errors = vref.errors;
 vref.env = st.env;
 st.defs = emptyDefs();
}

abstract production print_stmt
st::Stmt ::= str::STRING par::Args
{
  st.basepp = if (par.pp == "") 
              then "printf" ++ "(" ++ str.lexeme ++ ")"
              else "printf" ++ "(" ++ str.lexeme ++ "," ++ par.basepp ++ ")";


  st.pp = if (par.pp == "")
          then "printf" ++ "(" ++ str.lexeme ++ ")"
          else "printf" ++ "(" ++ str.lexeme ++ "," ++ par.basepp ++ ")";


  st.errors = par.errors;
  st.defs = emptyDefs();
  par.env = st.env;
}

abstract production printm_stmt
st::Stmt ::= vref::Expr
{
  st.basepp = "printm" ++ "(" ++ vref.basepp ++ ")";

  st.pp = "printm" ++ "(" ++ vref.pp ++ ")";
  st.errors = vref.errors;
  vref.env = st.env;
  st.defs = emptyDefs();
}
abstract production printm_const
st::Stmt ::= cn::CONST
{
  st.basepp = "printm" ++ "(" ++ cn.lexeme ++ ")";

  st.pp = "printm" ++ "(" ++ cn.lexeme ++ ")";
  st.errors = [];
  st.defs = emptyDefs();
}

-- Block-type statements                        --
--------------------------------------------------
abstract production atomic_stmt
st::Stmt ::= b::Body
{
 st.pp = "atomic " ++  b.pp ;
 b.ppi = st.ppi;
 st.basepp = "atomic " ++ b.basepp ;
 st.errors = b.errors ;
 st.defs = b.defs;
 b.env = st.env;
}

abstract production dstep_stmt
st::Stmt ::= b::Body
{
 st.pp = "d_step" ++ "\n" ++ b.pp ;
 b.ppi = st.ppi;
 st.basepp = "d_step" ++ "\n" ++ b.basepp ;

 st.errors = b.errors ;
 st.defs = b.defs;
}
-- Misc. Statements                             --
--------------------------------------------------

abstract production assert_stmt
st::Stmt ::= fe::Expr
{
 st.basepp = "assert " ++ fe.basepp ;

 st.pp = "assert " ++ fe.pp ;
 st.errors = fe.errors;
 st.defs = emptyDefs();
 fe.env = st.env;
}



abstract production unless_stmt
st::Stmt ::= st1::Stmt st2::Stmt
{
  st.pp = st1.pp ++ "\n unless \n" ++ st2.pp ++ "\n" ;
  st1.ppi = st.ppi;
  st2.ppi = st.ppi;
  st.basepp = st1.basepp ++ "\n unless \n" ++ st2.basepp ++ "\n" ;


  st.errors = st1.errors ++ st2.errors;

  st.defs = mergeDefs(st1.defs,st2.defs);
  st1.env = st.env;
 st2.env = mergeDefs(st1.defs,st.env);
}

abstract production empty_stmt
st::Stmt ::= 
{
 st.pp = "" ;
 st.basepp = "" ;

 st.defs = emptyDefs();
 st.errors = [ ];
}

abstract production commented_stmt
st::Stmt ::= comm::String s2::Stmt
{
 st.pp = st.ppi ++ comm ++ s2.pp ;
 s2.ppi = st.ppi ;
 st.basepp = st.ppi ++ comm ++ s2.basepp ;

 st.errors = s2.errors ;
 st.defs = s2.defs; 

}

abstract production error_stmt
st::Stmt ::= er::String
{
 st.pp = "\n" ;
 st.basepp = "\n" ;

 st.defs = emptyDefs();
 st.errors = [ er ];
}


-}
