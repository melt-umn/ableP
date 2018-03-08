grammar edu:umn:cs:melt:ableP:artifacts:promelaCore:tests ;

import silver:testing ;
import silver:testing:bin ;

import lib:extcore ;

import edu:umn:cs:melt:ableP:host:core hiding msg ;
import edu:umn:cs:melt:ableP:host:tests ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
 local attribute testResults :: TestSuite ;
 testResults = consolidateTestSuite( 
      [
        -- check parsing.  Runs on most Spin-provided examples
        tests(parseTestsIO.iovalue) 

        -- check that AST is created, and its generated pp is parseable
--        tests(astPPTestsIO.iovalue) ,


--                    tests(hostASTParseTestsIO.iovalue) ,

        -- check that there are no semantic errors on original AST or host AST.
--        tests(noErrorsTestsIO.iovalue)
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
       ( ".", [ "SpinExamples" ], mkParseOnlyTest, 
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
           then [ parseOnlyTestAfterCPP(fn, promelaCoreParser) ] ++ ioIn.iovalue
           else ioIn.iovalue ) ;
}

function mkASTppTest
IOVal<[Test]> ::= fn::String ioIn::IOVal<[Test]> 
{ return
    ioval( ioIn.io,
           if   endsWith(".pml",fn)
           then [ postCPPParsingTest(fn, promelaCoreParser, -- ppOfASTParsable_test
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
           then [ postParsingTest(fn, promelaCoreParser, parsePPofHost_test) ] ++ 
                ioIn.iovalue
           else ioIn.iovalue ) ;
}



