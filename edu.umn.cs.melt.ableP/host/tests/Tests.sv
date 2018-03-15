grammar edu:umn:cs:melt:ableP:host:tests ;

import silver:testing ;
import lib:extcore ;
import edu:umn:cs:melt:ableP:host:core:abstractsyntax hiding msg ;
import edu:umn:cs:melt:ableP:host:core:concretesyntax ;
import edu:umn:cs:melt:ableP:host:hostParser ;


-- Functions to make tests that check that there are no errors on the
-- trees. It checks both the initial AST and the host AST.
----------------------------------------------------------------------
function mkNoErrorsTest
IOVal<[Test]> ::= fn::String ioIn::IOVal<[Test]> 
{ return 
    ioval( ioIn.io,
           if   endsWith(".pml",fn)
           then [ postParsingTest(fn, promelaParser, semanticsOK_test) ] ++ 
                ioIn.iovalue
           else ioIn.iovalue ) ;
}

abstract production semanticsOK_test 
t::Test ::= cst_tree::Program_c fn::String
            parseF::(ParseResult<Program_c> ::= String String)
{
 -- a test to check that there are no warnings or errors on the
 -- tree ast_tree nor host_tree
 -- eventually check the same for inlined tree.

 local ast_tree::Program = cst_tree.ast ;
 local host_tree::Program = ast_tree.host ;

 t.msg = -- "Semantics errors on file \"" ++ fn ++ "\".\n" ++
         showErrors(ast_tree.errors) ++ showErrors(host_tree.errors) ;
 t.pass = t.msg == "" ;
 t.ioOut = t.ioIn ;
}


abstract production postParsingTest
t::Test ::= fn::String parseF::(ParseResult<a> ::= String String)
            custom::(Test ::= a String (ParseResult<a> ::= String String))
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

 local pt::Test = custom (pr1.parseTree, fn, parseF) ;
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

abstract production postCPPParsingTest
t::Test ::= fn::String parseF::(ParseResult<a> ::= String String)
            custom::(Test ::= a String (ParseResult<a> ::= String String))
{
 local exists::IOVal<Boolean> = isFile(fn, t.ioIn);

 local cppCommand :: String
   = "cpp -P " ++ fn ++ " > " ++ fn ++ ".cpp" ;
 {- Removing the 'tail' call.
   = "cpp -P " ++ fn ++ " | tail -n +3 > " ++ fn ++ ".cpp" ;
   -- even the -P option to cpp leaves 2 blanks lines, so we also
   -- use tail to remove these blank lines


   cpp in versions 4.2.1 and earlier would leave 2 blank lines in the
   resulting file when the -P flag is used.  Later versions do not do
   this.  If one loads the soft/gcc on CS machines the default is 4.2.
   On Mac OS X the default is also 4.2, at least on 10.5.  Maybe 10.6
   moves to a newer version.

 -}
 local mkCPPfile::IOVal<Integer> = system (cppCommand, exists.io ) ;
 local text::IOVal<String> = readFile(fn++".cpp", mkCPPfile.io);

 local pr1::ParseResult<a> = parseF(text.iovalue, fn) ;

 local result :: Maybe<String> 
  = if   ! exists.iovalue
    then just("File \"" ++ fn ++ "\" not found.\n")
    else
    if   ! pr1.parseSuccess
    then just ("Parse errors on input file: " ++ pr1.parseErrors ++ "\n")
    else nothing();

 local pt::Test = custom (pr1.parseTree, fn, parseF) ;
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


abstract production ppOfASTParsable_test 
t::Test ::= tree::Program_c fn::String
            parseF::(ParseResult<Program_c> ::= String String)
{
 local p_ast1::Program = tree.ast ;
 local p_ast1_pp::String = p_ast1.pp ;

 local pr2::ParseResult<Program_c> = parseF(p_ast1_pp, "generated pp p_ast1" ) ;
 local p_ast2::Program = pr2.parseTree.ast ;
 local p_ast2_pp::String = p_ast2.pp ;


 local result :: Maybe<String>
  = if   ! pr2.parseSuccess
    then just ("Parse errors on generated pp of ast (p_ast_1): " ++
               pr2.parseErrors ++ "\n.....\n" ++
               addLineNumbers(p_ast1_pp) ++ 
               "\n.....\n" )
    else nothing() ;

 t.msg = case result of
           nothing() -> "" 
         | just(m) -> "AST pretty-print errors on \"" ++ fn ++ "\".\n" ++ m
         end ;
 t.pass = ! result.isJust ;
 t.ioOut = t.ioIn ;
         --  if   ! exists.iovalue
         --  then exists.io 
         --  else text.io ;
}

abstract production ppOfAST_test 
t::Test ::= tree::Program_c fn::String
            parseF::(ParseResult<Program_c> ::= String String)
{
 -- compute 'unparse' of tree
 local p1_ast::Program = tree.ast ;
 local p1_ast_pp::String = p1_ast.pp ;
 local pr1::ParseResult<Program_c> = parseF(p1_ast_pp,
                                            "generated pp of p1_ast of file " ++ fn ) ;
 local p1_ast_pp_cst::Program_c = pr1.parseTree ;
 local p1_unparse::String = p1_ast_pp_cst.pp ;

 -- compute 'unparse' of 'unparse' of tree
 local pr2::ParseResult<Program_c> = parseF(p1_unparse,
                                            "unparse of tree from file " ++ fn ) ;
 local p2_ast::Program = pr2.parseTree.ast ;
 local p2_ast_pp::String = p2_ast.pp ;
 local pr3::ParseResult<Program_c> = parseF(p2_ast_pp,
                                            "generated pp of p2_ast of file " ++ fn ) ;
 local p2_ast_pp_cst::Program_c = pr3.parseTree ;
 local p2_unparse::String = p2_ast_pp_cst.pp ;

 local wr1::IO = writeFile("d1", p1_unparse, t.ioIn) ;
 local wr2::IO = writeFile("d2", p2_unparse, wr1) ;
 local dff::IOVal<Integer> = system("rm -f diff_res; diff d1 d2 > diff_res", wr2) ;
 local rd::IOVal<String> = readFile("diff_res", dff.io);

 local result :: Maybe<String>
  = if   ! pr1.parseSuccess
    then just ("Parse errors on generated pp of p1_ast of file " ++ fn ++ ":\n" ++
               pr1.parseErrors ++ "\n.....\n" ++
               addLineNumbers(p1_ast_pp) ++ 
               "\n.....\n" )
    else 
    if   ! pr2.parseSuccess
    then just ("Parse errors on unparse of tree from file " ++ fn ++ ":\n" ++
               pr2.parseErrors ++ "\n.....\n" ++
               addLineNumbers(p1_unparse) ++ 
               "\n.....\n" )
    else 
    if   ! pr3.parseSuccess
    then just ("Parse errors on generated pp of p2_ast of file " ++ fn ++ ":\n" ++
               pr3.parseErrors ++ "\n.....\n" ++
               addLineNumbers(p2_ast_pp) ++ 
               "\n.....\n" )
    else 
    if   p1_unparse != p2_unparse   -- dff.iovalue >= 1  --         
    then just ("p1_unparse != p2_unparse \n\n" ++ 
               "p1_unparse:\n" ++ p1_unparse ++ "\n.....\n\n" ++
               "p2_unparse:\n" ++ p2_unparse ++ "\n.....\n\n" ++
               "diff is: \n" ++ rd.iovalue ++ "\n\n" ++
               "Hacky UnParse of trees:\n" ++
               "p1_ast:\n" ++ hackUnparse(p1_ast) ++ "\n\n" ++
               "p2_ast:\n" ++ hackUnparse(p2_ast) ++ "\n\n"
              )
    else nothing() ;

 t.msg = case result of
           nothing() -> "" 
         | just(m) -> "AST pretty-print errors on \"" ++ fn ++ "\".\n" ++ m
         end ;
 t.pass = ! result.isJust ;
 t.ioOut = t.ioIn ;
         --  if   ! exists.iovalue
         --  then exists.io 
         --  else text.io ;
}

abstract production parsePPofHost_test 
t::Test ::= tree::Program_c fn::String 
            parseF::(ParseResult<Program_c> ::= String String)
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

