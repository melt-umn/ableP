grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

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


-- declarations --
abstract production one_decl
st::Stmt ::= d::Decls
{
 st.pp = d.pp ++ " ";
 d.ppi = st.ppi ;
 d.ppsep = " ; \n" ;
 st.basepp = d.basepp ++ " " ;
 st.errors = d.errors;
 st.defs = d.defs;
 d.env = st.env ;
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

-- Control Flow                                 --
--------------------------------------------------
abstract production if_special
sc::Stmt ::= op::Options 
{ 
  op.ppi = sc.ppi;
  sc.basepp = "if\n" ++ sc.ppi ++ op.basepp ++ "\n" ++ sc.ppi ++ "fi";
  sc.pp = "if\n" ++ sc.ppi ++ op.pp ++ "\n" ++ sc.ppi ++ "fi";
  sc.errors = op.errors;
  sc.defs = emptyDefs();
  op.env = sc.env;
}

abstract production do_special
sc::Stmt ::= op::Options
{
  op.ppi = sc.ppi;
  sc.basepp = "do\n" ++ sc.ppi ++ op.basepp ++ "\n" ++ sc.ppi ++ "od";
  sc.pp = "do\n" ++ sc.ppi ++ op.pp ++ "\n" ++ sc.ppi ++ "od";
  sc.errors = op.errors;
  sc.defs = emptyDefs();
  op.env = sc.env;
}

abstract production break_special
sc::Stmt ::=
{
  sc.basepp = "break";

  sc.pp = "break";
  sc.errors = [];
  sc.defs = emptyDefs();

}
abstract production goto_special
sc::Stmt ::= id::ID
{ 
  sc.basepp = "goto " ++ id.lexeme;

  sc.pp = sc.ppi ++ "goto " ++ id.lexeme;
  sc.errors = [];
  sc.defs = emptyDefs();
}

abstract production stmt_special
sc::Stmt ::= id::ID st::Stmt
{
  st.ppi = sc.ppi;
  sc.basepp = id.lexeme ++ ":" ++ st.ppi ++ st.basepp;
  sc.pp = id.lexeme ++ ":" ++ st.ppi ++ st.pp;
  sc.errors = st.errors;
  sc.defs = st.defs;
  st.env = sc.env;
}

abstract production else_stmt
st::Stmt ::= 
{
  st.basepp = "else";
  st.pp = "else";
  st.errors = [];
  st.defs = emptyDefs();
}

-- Options --
abstract production single_option
ops::Options ::= st::Stmt
{
  ops.pp = ":: " ++ st.pp;
  st.ppi = ops.ppi ++ "   " ;
  ops.basepp = ":: " ++ st.basepp;
  st.env = ops.env;
  ops.errors = st.errors;
}
abstract production cons_option
ops::Options ::= st::Stmt ops_tail::Options
{
  ops.pp = ":: " ++ st.pp ++ "\n" ++ ops.ppi ++ ops_tail.pp;
  st.ppi = ops.ppi ++ "   ";
  ops_tail.ppi = ops.ppi;
  ops.basepp = ":: " ++ st.basepp ++ "\n" ++ ops.ppi ++ ops_tail.basepp;
  ops.errors = st.errors ++ ops_tail.errors;
  st.env = ops.env;
  ops_tail.env = ops.env;
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


abstract production fullexpr_stmt
st::Stmt ::= fe::Expr
{
  st.pp =  fe.pp ++ "" ;
  st.basepp = fe.basepp ++ "" ;

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
