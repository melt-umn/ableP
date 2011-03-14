grammar edu:umn:cs:melt:ableP:comp:aviation:tests ;

import lib:testing ;
import lib:langproc:errors hiding msg ;
import lib:extcore ;
import edu:umn:cs:melt:ableP:host ;
import edu:umn:cs:melt:ableP:host:tests ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
 local attribute testResults :: TestSuite ;
 testResults = consolidateTestSuite( [
                    tests(semanticsOKTestsIO.iovalue)
                 ] ) ;
 testResults.ioIn = semanticsOKTestsIO.io;

 return ioval ( print (
       "Test results: \n" ++ testResults.msg ++ "\n\n" ++ 
       "Passed " ++ toString (testResults.numPassed) ++
       " tests out of " ++ toString (testResults.numTests) ++ "\n\n"
      , testResults.ioOut ), testResults.numFailed
   );

  -- make tests to check all semantics are OK
  local semanticsOKTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "../PaperExamples" ], mkSemanticsOKTest, dirSkip, ioval(mainIO,[]) ) ;

}
