grammar edu:umn:cs:melt:ableP:host:tests ;

import lib:testing ;
import lib:langproc:errors hiding msg ;
import lib:extcore ;
import edu:umn:cs:melt:ableP:host ;



function mkSemanticsOKTest
IOVal<[Test]> ::= fn::String ioIn::IOVal<[Test]> 
{ return
    ioval( ioIn.io,
           if   endsWith(".pml",fn)
           then [ postParsingTest(fn, promelaParser, semanticsOK_test) ] ++ 
                ioIn.iovalue
           else ioIn.iovalue ) ;
}

abstract production semanticsOK_test 
t::Test ::= cst_tree::Program_c 
            parseF::Function(ParseResult<Program_c> ::= String String)
{
 -- a test to check that there are no warnings or errors on the
 -- tree ast_tree nor host_tree
 -- eventually check the same for inlined tree.

 local ast_tree::Program = cst_tree.ast ;
 local host_tree::Program = ast_tree.host ;

 t.msg = showErrors(ast_tree.errors) ++ showErrors(host_tree.errors) ;
 t.pass = t.msg == "" ;
 t.ioOut = t.ioIn ;
}


abstract production postParsingTest
t::Test ::= fn::String parseF::Function(ParseResult<a> ::= String String)
            custom::Production(Test ::= a Function(ParseResult<a> ::= String String))
{
 local exists::IOVal<Boolean> = isFile(fn, t.ioIn);
 local text::IOVal<String> = readFile(fn, exists.io);
 local pr1::ParseResult<a> = parseF(text.iovalue, fn) ;

 local result :: Maybe<String> 
  = if   ! exists.iovalue
    then just("File \"" ++ fn ++ "\" not found.\n")
    else
    if   ! pr1.parseSuccess
    then just ("Parse errors on input file: " ++ pr1.parseErrors ++ "\n")
    else nothing();

 local pt::Test = custom (pr1.parseTree, parseF) ;
 pt.ioIn = text.io ;

 t.msg = case result of
           nothing() -> pt.msg
         | just(m) -> m end ;
 t.pass = case result of
           nothing() -> pt.pass
         | just(m) -> false end ;
 t.ioOut = case result of
           nothing() -> pt.ioOut
         | just(_) -> exists.io end ;
 }

abstract production ppOfAST_test 
t::Test ::= tree::Program_c parseF::Function(ParseResult<Program_c> ::= String String)
{
 local p_ast1::Program = tree.ast ;
 local p_ast1_pp::String = p_ast1.pp ;

 local pr2::ParseResult<Program_c> = parseF(p_ast1_pp, "generated pp p_ast1" ) ;
 local p_ast2::Program = pr2.parseTree.ast ;
 local p_ast2_pp::String = p_ast2.pp ;
 
 local wr1::IO = writeFile("d1", p_ast1_pp, t.ioIn) ;
 local wr2::IO = writeFile("d2", p_ast2_pp, wr1) ;
 local dff::IOVal<Integer> = system("rm -f diff_res; diff d1 d2 > diff_res", wr2) ;
 local rd::IOVal<String> = readFile("diff_res", dff.io);

 local result :: Maybe<String>
  = if   ! pr2.parseSuccess
    then just ("Parse errors on generated pp of ast (p_ast_1): " ++
               pr2.parseErrors ++ "\n.....\n" ++
               addLineNumbers(p_ast1_pp) ++ 
               "\n.....\n" )
    else 
    if   p_ast1_pp != p_ast2_pp   -- dff.iovalue >= 1  --         
    then just ("p_ast1_pp != p_ast2_pp \n\n" ++ 
               "p_ast1_pp:\n" ++ p_ast1_pp ++ "\n.....\n\n" ++
               "p_ast2_pp:\n" ++ p_ast2_pp ++ "\n.....\n\n" ++
               "diff is: \n" ++ rd.iovalue ++ "\n" )
    else nothing() ;

 t.msg = case result of
           nothing() -> "" 
         | just(m) -> m end ;
 t.pass = ! result.isJust ;
 t.ioOut = t.ioIn ;
         --  if   ! exists.iovalue
         --  then exists.io 
         --  else text.io ;
}

abstract production parsePPofHost_test 
t::Test ::= tree::Program_c parseF::Function(ParseResult<Program_c> ::= String String)
{
 local f_ast::Program = tree.ast.host ;
 local f_ast_pp::String = f_ast.pp ;

 local pr2::ParseResult<Program_c> = parseF(f_ast_pp, "generated pp p_ast1" ) ;
 local p_ast2::Program = pr2.parseTree.ast ;
 
 local result :: Maybe<String>
  = if   ! pr2.parseSuccess
    then just ("Parse errors on generated pp of host ast (tree.ast.host.ast): " ++
               pr2.parseErrors ++ "\n.....\n" ++
               addLineNumbers(f_ast_pp) ++ 
               "\n.....\n" )
    else nothing() ;

 t.msg = case result of
           nothing() -> "" 
         | just(m) -> m end ;
 t.pass = ! result.isJust ;
 t.ioOut = t.ioIn ;
}


function addLineNumbers
String ::= code::String
{ return addLineNums(1, 2, lines) ;
  local lines::[String] = explode("\n",code) ;
}

function addLineNums
String ::= next::Integer width::Integer lines::[String]
{ return if null(lines)
         then ""
         else pad ++ ln ++ ": " ++ head(lines) ++ "\n" ++
              addLineNums(next+1, width, tail(lines)) ;
  local ln::String = toString(next); 
  local pad::String = implode("", repeat(" ", width - length(ln)) ) ;
}


function repeat
[a] ::= v::a times::Integer
{ return if   times <= 0
         then [ ]
         else v :: repeat(v, times-1) ;
}
         

function zipWith
[c] ::= l1::[a]  l2::[b] f::Function(c::= a b)
{ return
   if   null(l1) || null(l2)
   then [ ]
   else f( head(l1), head(l2) ) :: zipWith (tail(l1), tail(l2), f) ;
}
