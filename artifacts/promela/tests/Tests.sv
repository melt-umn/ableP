grammar edu:umn:cs:melt:ableP:artifacts:promela:tests ;

import lib:testing ;
import lib:extcore ;

import edu:umn:cs:melt:ableP:host:core:abstractsyntax hiding msg ;
import edu:umn:cs:melt:ableP:host:core:concretesyntax ;
import edu:umn:cs:melt:ableP:host:core:terminals ;
import edu:umn:cs:melt:ableP:host:hostParser ;
import edu:umn:cs:melt:ableP:host:tests ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
 local attribute testResults :: TestSuite ;
 testResults = consolidateTestSuite( 
      [
        -- check parsing.  Runs on most Spin-provided examples
        tests(parseTestsIO.iovalue) ,

        -- check that AST is created, and its generated pp is parseable
        tests(astPPTestsIO.iovalue) ,


--                    tests(hostASTParseTestsIO.iovalue) ,

        -- check that there are no semantic errors on original AST or host AST.
        tests(noErrorsTestsIO.iovalue)
      ] ) ;
 testResults.ioIn = noErrorsTestsIO.io;

 return ioval ( print (
       "Test results: \n" ++ testResults.msg ++ "\n\n" ++ 
       "Passed " ++ toString (testResults.numPassed) ++
       " tests out of " ++ toString (testResults.numTests) ++ "\n\n"
      , testResults.ioOut ), testResults.numFailed
   );

  -- make parse-only tests for all .pml files
  local parseTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "SpinExamples", "Spin6_Examples" ], mkParseOnlyTest, 
         dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to parse and compare pp of AST
  local astPPTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "AST_pp_tests", "SpinExamples" ] , -- , "../../aviation/PaperExamples" ], 
         mkASTppTest, dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to parse host AST
  local hostASTParseTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "Host_tests" ], mkHostASTppTest, dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to check all semantics are OK
  local noErrorsTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "SemanticsOK", "AST_pp_tests" ] , -- , "SpinExamples" ], 
         mkNoErrorsTest, dirSkip, ioval(mainIO,[]) ) ;
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
           then [ postCPPParsingTest(fn, promelaParser, -- ppOfASTParsable_test
                                                     ppOfAST_test
                                 ) ]
                ++ ioIn.iovalue
           else ioIn.iovalue ) ;
}

function mkHostASTppTest
IOVal<[Test]> ::= fn::String ioIn::IOVal<[Test]> 
{ return
    ioval( ioIn.io,
           if   endsWith(".pml",fn)
           then [ postParsingTest(fn, promelaParser, parsePPofHost_test) ] ++ 
                ioIn.iovalue
           else ioIn.iovalue ) ;
}



makeTestSuite ableP_host_tests ;

aspect production ableP_host_tests 
top::TestSuite ::=
{ testsToPerform
     <- [ parseOnlyTest("SpinExamples/CH3/counter.pml", promelaParser),
          parseFailTest("ErroneousFiles/ParseErrors/counter.pml", promelaParser) ] ; 
} 

