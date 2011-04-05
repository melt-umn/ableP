grammar edu:umn:cs:melt:ableP:host:driver;

import edu:umn:cs:melt:ableP:terminals;
import edu:umn:cs:melt:ableP:concretesyntax only Program_c, ast, cst_Program_c ;
import edu:umn:cs:melt:ableP:abstractsyntax ; -- only Program, pp, host, errors ;
import edu:umn:cs:melt:ableP:host:hostParser only promelaParser ;

import lib:extcore ;

function driver
IOVal<Integer> ::= args::[String]
                   ext_parser::Function(ParseResult<Program_c>::=String String) 
                   driverIO::IO 
{
  local filename::String = head(args) ;
  production fileExists :: IOVal<Boolean>  = isFile(filename, driverIO);
  production text::IOVal<String> = readFile(filename, fileExists.io);

  local result::ParseResult<Program_c> = ext_parser(text.iovalue, filename);

  local r_cst::Program_c = result.parseTree ;
  local r_ast::Program = r_cst.ast ;

  local parseASTpp::ParseResult<Program_c> = ext_parser(r_ast.pp, "parseASTpp") ;
  local r_ast_cst::Program_c = parseASTpp.parseTree ;
                          -- = r_ast.cst_Program_c ;

  local ast_warnings::[Error] = getWarnings(r_ast.errors) ;
  local ast_errors::[Error] = getErrors(r_ast.errors) ;

  local r_hst::Program = r_ast.host ;
  local parseHOSTpp::ParseResult<Program_c> = promelaParser(r_hst.pp, "parseHOSTpp") ;
  local r_host_cst::Program_c = parseHOSTpp.parseTree ;
                           -- = r_hst.cst_Program_c ;

  local attribute print_success :: IO ;
  print_success = 
    print( "\n" ++
           "Command line arguments: " ++ head(args) ++
           "\n\n" ++
           "CST pretty print: \n================= \n" ++ r_cst.pp ++
           "\n\n" ++ 
           "AST pretty print: \n================= \n" ++ r_ast.pp ++
           "\n\n" ++
           (if   parseASTpp.parseSuccess
            then "AST pretty print (from parsed CST): \n" ++
                 "=================================== \n" ++ 
                 r_ast_cst.pp ++
                 "\n\n"
            else "Failed to parse AST pp: \n" ++
                 "======================= \n" ++
                 parseASTpp.parseErrors ++ "\n\n" ++
                 "r_ast.pp (which did not parse) is shown  below: \n" ++
                 "=============================================== \n" ++
                 addLineNumbers(r_ast.pp) ++ "\n\n"
           )
           ++
           (if   parseHOSTpp.parseSuccess
            then "HOST pretty print (from parsed CST): \n" ++
                 "==================================== \n" ++ 
                 r_host_cst.pp ++
                 "\n\n"
            else "Failed to parse HOST pp: \n" ++
                 "======================== \n" ++
                 parseHOSTpp.parseErrors ++ "\n\n" ++
                 "r_host.pp (which did not parse) is shown below: \n" ++
                 "=============================================== \n" ++
                 addLineNumbers(r_hst.pp) ++ "\n\n"
           )
           ++
           "Warnings: " ++
           (if null(ast_warnings)  then " No warnings.\n" 
            else "\n" ++ showErrors(ast_warnings) ++ "\n"
           ) ++
           "Errors:   " ++
           (if null(ast_errors)  then " No semantic errors.\n" 
            else "\n" ++ showErrors(ast_errors) ++ "\n"
           ) ++
           "\n\n"
           , text.io ) ;
 
  local host_filenameOld::String 
    = substring(0, length(filename)-5, filename) ++ "_HOST_Old.pml" ;
  local host_filename::String 
    = substring(0, length(filename)-5, filename) ++ "_HOST.pml" ;

  local writeHostIOOld::IO
    = if   endsWith(".xpml", filename)
      then writeFile( host_filenameOld , r_hst.pp,
                      print ("writing host as " ++ host_filenameOld ++ "\n",
                             print_success ) )
      else print_success ;
  local writeHostIO::IO
    = if   endsWith(".xpml", filename) && parseHOSTpp.parseSuccess
      then writeFile( host_filename , r_host_cst.pp,
                      print ("writing host from CST as " ++ host_filename ++ "\n",
                             writeHostIOOld ) )
      else writeHostIOOld ;

  local attribute print_failure :: IOVal<Integer>;
  print_failure =
   ioval (
    print("Encountered a parse error:\n" ++ result.parseErrors ++ "\n", 
          text.io) , 1 ) ;

  return if   ! fileExists.iovalue 
         then error ("\n\nFile \"" ++ filename ++ "\" not found.\n")
         else
         if   result.parseSuccess 
         then ioval(writeHostIO, 0)
         else print_failure;
}


{-
function header
String ::= str::String
{ return 
-}
