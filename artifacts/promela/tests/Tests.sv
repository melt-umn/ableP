grammar edu:umn:cs:melt:ableP:artifacts:promela:tests ;

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
                 -- [ ableP_host_tests() ] ,
                 --   tests(parseTestsIO.iovalue) ,
                    tests(astPPTestsIO.iovalue) ,
                    tests(hostASTParseTestsIO.iovalue) ,
                    tests(semanticsOKTestsIO.iovalue)
                 ] ) ;
 testResults.ioIn = semanticsOKTestsIO.io;

 return ioval ( print (
       "Test results: \n" ++ testResults.msg ++ "\n\n" ++ 
       "Passed " ++ toString (testResults.numPassed) ++
       " tests out of " ++ toString (testResults.numTests) ++ "\n\n"
      , testResults.ioOut ), testResults.numFailed
   );

  -- make tests for all .pml files
  local parseTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "SpinExamples", "Spin6_Examples" ], mkParseOnlyTest, 
         dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to parse and compare pp of AST
  local astPPTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "AST_pp_tests", "../../aviation/PaperExamples" ], 
         mkASTppTest, dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to parse host AST
  local hostASTParseTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "Host_tests" ], mkHostASTppTest, dirSkip, ioval(mainIO,[]) ) ;

  -- make tests to check all semantics are OK
  local semanticsOKTestsIO::IOVal<[Test]> = traverseDirectoriesAndPerform
       ( ".", [ "SemanticsOK" ], mkSemanticsOKTest, dirSkip, ioval(mainIO,[]) ) ;

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
           then [ postParsingTest(fn, promelaParser, ppOfAST_test) ]
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



