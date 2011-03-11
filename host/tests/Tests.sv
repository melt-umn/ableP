grammar edu:umn:cs:melt:ableP:host:tests ;

import lib:testing ;
import lib:extcore ;

import edu:umn:cs:melt:ableP:host ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
 local attribute testResults :: TestSuite ;
 testResults = --consolidateTestSuite(
                 -- [ ableP_host_tests() ] ,
                --  tests(parseTestsIO.iovalue) ,
                  tests(astPPTestsIO.iovalue) ;
 testResults.ioIn = parseTestsIO.io;

 return
   ioval (
     print (
       "Test results: \n" ++
       testResults.msg ++ "\n\n" ++ 
       "Passed " ++ toString (testResults.numPassed) ++
       " tests out of " ++ 
       toString (testResults.numTests) ++ "\n\n"
      , testResults.ioOut ), testResults.numFailed
   );

  -- make tests for all .pml files
  local parseTestsIO::IOVal<[Test]>
   = traverseDirectoriesAndPerform
       ( ".", [ "SpinExamples", "Spin6_Examples" ], mkParseOnlyTest, 
         dirSkip, ioval(mainIO,[]) ) ;
  -- make tests to parse and compare pp of AST
  local astPPTestsIO::IOVal<[Test]>
   = traverseDirectoriesAndPerform
       ( ".", [ "AST_pp_tests" ], mkASTppTest,
         dirSkip, ioval(mainIO,[]) ) ;
}

makeTestSuite ableP_host_tests ;

aspect production ableP_host_tests 
top::TestSuite ::=
{ testsToPerform
     <- [ parseOnlyTest("SpinExamples/CH3/counter.pml", promelaParser),
          parseFailTest("ErroneousFiles/ParseErrors/counter.pml", promelaParser) ] ; 
} 


function mkParseOnlyTest
IOVal<[Test]> ::= fn::String ioIn::IOVal<[Test]> 
{ return
    ioval( ioIn.io,
           if   endsWith(".pml",fn)
           then [ parseOnlyTestAfterCPP(fn, promelaParser) ] ++ ioIn.iovalue
           else ioIn.iovalue ) ;
}

function mkASTppTest
IOVal<[Test]> ::= fn::String ioIn::IOVal<[Test]> 
{ return
    ioval( ioIn.io,
           if   endsWith(".pml",fn)
           then [ parsePPofAST(fn, promelaParser) ] ++ ioIn.iovalue
           else ioIn.iovalue ) ;
}

abstract production parsePPofAST
t::Test ::= fn::String parseF::Function(ParseResult<Program_c> ::= String String)
{
 local exists::IOVal<Boolean> = isFile(fn, t.ioIn);
 local text::IOVal<String> = readFile(fn, exists.io);

 local pr1::ParseResult<Program_c> = parseF(text.iovalue, fn) ;
 local p_ast1::Program = pr1.parseTree.ast ;
 local p_ast1_pp::String = p_ast1.pp ;

 local pr2::ParseResult<Program_c> = parseF(p_ast1_pp, fn ++ "-p_ast1" ) ;
 local p_ast2::Program = pr2.parseTree.ast ;
 local p_ast2_pp::String = p_ast2.pp ;

 --local pr3::ParseResult<Program_c> = parseF(p_ast2_pp, fn ++ "-p_ast2" ) ;
 --local p_ast3::Program = pr3.parseTree.ast ;
 --local p_ast3_pp::String = p_ast3.pp ;
 
 local wr1::IO = writeFile("d1", p_ast1_pp, text.io) ;
 local wr2::IO = writeFile("d2", p_ast2_pp, wr1) ;
 local dff::IOVal<Integer> = system("rm -f diff_res; diff d1 d2 > diff_res", wr2) ;
 local rd::IOVal<String> = readFile("diff_res", dff.io);

 local result :: Maybe<String> 
  = if   ! exists.iovalue
    then just("File \"" ++ fn ++ "\" not found.\n")
    else
    if   ! pr1.parseSuccess
    then just ("Parse errors on input file: " ++ pr1.parseErrors ++ "\n")
    else 
    if   ! pr2.parseSuccess
    then just ("Parse errors on p_ast_1: " ++ pr2.parseErrors ++ "\n.....\n" ++
               p_ast1_pp ++ "\n.....\n" )
    else 
    if   -- dff.iovalue >= 1  --         
         p_ast1_pp != p_ast2_pp
    then just ("p_ast1_pp != p_ast2_pp \n\n" ++ 
               "p_ast1_pp:\n" ++ p_ast1_pp ++ "\n.....\n\n" ++
               "p_ast2_pp:\n" ++ p_ast2_pp ++ "\n.....\n\n" ++
               "diff is: \n" ++ rd.iovalue ++ "\n" )
    else nothing() ;


 t.msg = case result of
           nothing() -> "" 
         | just(m) -> m end ;
 t.pass = ! result.isJust ;

{-
 t.pass = exists.iovalue && pr.parseSuccess ;

 t.msg = if   ! exists.iovalue
         then "File \"" ++ fn ++ "\" not found.\n"
         else
         if   ! pr.parseSuccess
         then "Parser error: " ++ pr.parseErrors ++ "\n"
         else "" ;
-}
 t.ioOut = if   ! exists.iovalue
           then exists.io 
           else text.io ;
}

