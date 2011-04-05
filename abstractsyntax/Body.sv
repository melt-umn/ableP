grammar edu:umn:cs:melt:ableP:abstractsyntax;

-- Block
abstract production blockStmt
s::Stmt ::= body::Stmt
{
 s.pp = "\n{\n" ++ body.ppi ++ body.pp ++ s.ppi ++ "\n}\n";
 body.ppi = s.ppi ++ " ";
 body.ppsep = "; \n" ;
 s.errors := body.errors ;
 s.host = blockStmt(body.host) ;
 s.defs = emptyDefs() ;
 body.env = s.env;
 s.uses = body.uses ;
}
