grammar edu:umn:cs:melt:ableP:host:tests ;

import lib:testing ;
import lib:extcore ;

import edu:umn:cs:melt:ableP:host ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{
 local attribute testResults :: TestSuite ;
 testResults = -- consolidateTestSuite(
                 -- [ ableP_host_tests() ] ,
                  tests(parseTestsIO.iovalue)   ;
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
       ( ".", [ "SpinExamples", "Spin6_Examples" ], mkParseOnlyTest, dirSkip, ioval(mainIO,[]) ) ;
}

makeTestSuite ableP_host_tests ;

equalityTest ("A", "A", String, ableP_host_tests) ;

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


