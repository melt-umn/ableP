grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Body with pp, ppi, errors, host<Body> ;

-- Body
abstract production bodyStmt
b::Body ::= s::Stmt
{
 b.pp = "\n{\n" ++ s.ppi ++ s.pp ++ b.ppi ++ "\n}\n";
 s.ppi = b.ppi ++ " ";
 b.errors := s.errors ;
 b.host = bodyStmt(s.host) ;
-- b.basepp = "\n{\n" ++ s.ppi ++ s.pp ++ b.ppi ++ "\n}\n";
-- b.errors = s.errors;
-- b.defs = s.defs;
-- s.env = b.env;
}

abstract production stmt_block
s::Stmt ::= b::Body
{
 s.pp = b.pp;
 b.ppi = s.ppi;
 s.errors := b.errors ;
 s.host = stmt_block(b.host);
-- s.basepp = b.basepp;
-- s.errors = b.errors;
-- s.defs = b.defs;
-- b.env = s.env;
}

{-
nonterminal Stmts with pp, ppi ;
abstract production noneStmts
ss::Stmts ::=
{ ss.pp = "" ; }

abstract production oneStmts
ss::Stmts ::= s::Stmt
{ ss.pp = s.pp ; }

abstract production snocStmts
ss::Stmts ::= more::Stmts s::Stmt
{ ss.pp = more.pp ++ s.pp ; }
-}



{- I think we can get rid of these and just be sure that the pp
attibutes on the Stmt and Block nonterminal generate correct
semicolons - even if they are different that what was in the original
program and the original concrete syntax tree.  There is no real
reason to keep that information here.

nonterminal MS with pp,basepp;

abstract production os_no_semi
os::OS ::=
{
 os.basepp = "";
 os.pp = "";
}

abstract production os_semi
os::OS ::=
{
 os.basepp = ";";
 os.pp = ";";
}

abstract production ms_one_semi
ms::MS ::=
{
 ms.basepp = ";";
 ms.pp = ";";
}

abstract production ms_many_semi
ms::MS ::= ms2::MS
{
 ms.basepp = ms2.basepp ++ " ;";
 ms.pp = ms2.pp ++ " ;";
}
  
-}
