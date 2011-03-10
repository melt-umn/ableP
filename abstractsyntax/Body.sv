grammar edu:umn:cs:melt:ableP:abstractsyntax;

import edu:umn:cs:melt:ableP:terminals;

nonterminal Body with pp,basepp,ppi;
nonterminal Stmt with pp,basepp,ppi;
nonterminal MS with pp,basepp;

abstract production body_stmts
b::Body ::= s::Stmt
{
 b.pp = "\n{\n" ++ s.ppi ++ s.pp ++ b.ppi ++ "\n}\n";
 s.ppi = b.ppi ++ " ";
 b.basepp = "\n{\n" ++ s.ppi ++ s.pp ++ b.ppi ++ "\n}\n";
 b.errors = s.errors;
 b.defs = s.defs;
 s.env = b.env;
}

abstract production stmt_block
s::Stmt ::= b::Body
{
 s.pp = b.pp;
 b.ppi = s.ppi;
 s.basepp = b.basepp;
 s.errors = b.errors;
 s.defs = b.defs;
 b.env = s.env;
}

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
  
