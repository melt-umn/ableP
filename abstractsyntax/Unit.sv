grammar edu:umn:cs:melt:ableP:abstractsyntax;

nonterminal Unit with pp, ppi, host<Unit> ;

nonterminal Args with basepp,pp;
nonterminal NS with basepp,pp;
---nonterminal Error with basepp,pp;
nonterminal OptPriority with basepp,pp;

--synthesized attribute inlined_Units   :: Units   occurs on Units ;
--synthesized attribute inlined_Unit    :: Unit    occurs on Unit ;
--synthesized attribute inlined_Body    :: Body    occurs on Body ;
--synthesized attribute inlined_Args    :: Args    occurs on Args ;
--synthesized attribute inlined_Stmt    :: Stmt    occurs on Stmt ;
--synthesized attribute inlined_NS      :: NS      occurs on NS   ;
--synthesized attribute inlined_Error   :: Error   occurs on Error ;
--synthesized attribute inlined_OptPriority   :: OptPriority   occurs on OptPriority ;


{-  Will go back and add these as necessesary.


-- Unit --
----------
abstract production unit_semi
u::Unit ::= 
{ u.pp = ";\n";
--  u.basepp = ";\n";
--  u.errors = [];
--  u.defs = emptyDefs(); 
--  u.inlined_Unit = unit_semi();
}

abstract production unit_empty
u::Unit ::= 
{ u.pp = "";
-- u.basepp = "";
-- u.errors = [];
-- u.defs = emptyDefs(); 
-- u.inlined_Unit = unit_empty();
}

abstract production commented_unit
u::Unit ::= comm::String u2::Unit
{
 u.pp = comm ++ u2.pp ;
 u.basepp = comm ++ u2.basepp ;

 u.errors = [];
 u.defs = emptyDefs(); 

 u.inlined_Unit = unit_empty();
}


abstract production unitDecls
un::Unit ::= ds::Decls
{
 un.pp = ds.pp;
 ds.ppi = un.ppi;
 ds.ppsep = "; \n" ;
 un.basepp = ds.basepp;

 un.errors = ds.errors;
 un.defs = ds.defs;
 ds.env = un.env ;

 un.inlined_Unit = unitDecls(ds.inlined_Decls);
}

abstract production claim
c::Unit ::= body::Body
{
 c.pp = "\n" ++ "never " ++ body.ppi ++ body.pp;
 body.ppi = "   ";
 c.basepp = "\n" ++ "never " ++ body.ppi ++ body.basepp;

 c.errors = body.errors;
 c.defs = body.defs;
 body.env = c.env;

 c.inlined_Unit = claim(body.inlined_Body); 
}

abstract production events
e::Unit ::= body::Body
{
 e.pp = "\n" ++ "trace " ++ body.pp;
 body.ppi = "   ";
 e.basepp = "\n" ++ "trace " ++ body.basepp;

 e.errors = body.errors;
 e.defs = body.defs;
 body.env = e.env;

 e.inlined_Unit = events(body.inlined_Body);
}
abstract production init
i::Unit ::= op::OptPriority body::Body
{
 i.pp = "\n" ++ "init " ++ op.pp ++ body.ppi ++ body.pp ;
 body.ppi = "  ";
 i.basepp = "\n" ++ "init " ++ op.basepp ++ body.ppi ++ body.basepp;

 i.errors = body.errors;

 i.defs = body.defs;
 body.env = i.env;

 i.inlined_Unit = init(op.inlined_OptPriority, body.inlined_Body);
}

abstract production utype_dcllist
u::Unit ::= id::ID dl::Decls
{
 u.pp = "\n" ++ "typedef " ++ id.lexeme ++ " \n{" ++ dl.pp ++ " \n} \n";
 dl.ppi = "  ";
 dl.ppsep = "; \n ";
 u.basepp = "\n" ++ "typedef " ++ id.lexeme ++ " \n{" ++ dl.basepp ++ " \n} \n";

 u.errors = dl.errors;
 u.defs = valueBinding(id.lexeme, user_type(dl.defs)); 

 u.inlined_Unit = utype_dcllist(id,dl.inlined_Decls);
}



 
abstract production error_type_const
er::Error ::= ty::Type ct::CONST
{
 er.basepp = ty.basepp ++ ":" ++ ct.lexeme ;
 er.pp = ty.pp ++ ":" ++ ct.lexeme ;
 er.inlined_Error = error_type_const(ty,ct);
}
-}
