grammar edu:umn:cs:melt:ableP:artifacts:aviation:tests ;

import silver:testing with msg as test_msg ;
import silver:testing:bin ;

import lib:extcore ;

import edu:umn:cs:melt:ableP:host ;
import edu:umn:cs:melt:ableP:extensions:tables ;
import edu:umn:cs:melt:ableP:extensions:enhancedSelect ;
import edu:umn:cs:melt:ableP:extensions:discreteTime ;

import edu:umn:cs:melt:ableP:host:tests ;
import edu:umn:cs:melt:ableP:artifacts:promela:tests ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
 local attribute testResults :: TestSuite ;
 testResults = consolidateTestSuite( [
                    tests(astPPTestsIO.iovalue) ,
                    tests(hostASTParseTestsIO.iovalue) ,
                    tests(semanticsOKTestsIO.iovalue)
                 ] ) ;
 testResults.ioIn = semanticsOKTestsIO.io;

 return ioval ( print (
       "Test results: \n" ++ testResults.test_msg ++ "\n\n" ++ 
       "Passed " ++ toString (testResults.numPassed) ++
       " tests out of " ++ toString (testResults.numTests) ++ "\n\n"
      , testResults.ioOut ), testResults.numFailed
   );

  -- make tests to check all semantics are OK
  local semanticsOKTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "../PaperExamples", "../../promela/tests/SemanticsOK" ],
         mkNoErrorsTest, dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to parse and compare pp of AST
  local astPPTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "../../promela/tests/AST_pp_tests"] ,
         mkASTppTest, dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to parse host AST
  local hostASTParseTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "../../promela/tests/Host_tests" ], mkHostASTppTest, dirSkip, 
         ioval(mainIO,[]) ) ;

  

}
