grammar edu:umn:cs:melt:ableP:host:driver;

import edu:umn:cs:melt:ableP:host:core:concretesyntax
   only Program_c, ast, cst_Program_c ;
import edu:umn:cs:melt:ableP:host:core:abstractsyntax ; 
-- only Program, pp, host, errors ;
import edu:umn:cs:melt:ableP:host:hostParser 
   only promelaParser ;

function driver
IOVal<Integer> ::= args::[String]
                   ext_parser::(ParseResult<Program_c>::=String String) 
                   driverIO::IO 
{
  local debugMode::Boolean = head(args) == "--debug" ;
  local filename::String = if debugMode then head(tail(args)) else head(args) ;
  production fileExists :: IOVal<Boolean>  = isFile(filename, driverIO);
  production text::IOVal<String> = readFile(filename, fileExists.io);

  local result::ParseResult<Program_c> = ext_parser(text.iovalue, filename);

  local r_cst::Program_c = result.parseTree ;
  local r_ast::Program = r_cst.ast ;

  local parseASTpp::ParseResult<Program_c> = ext_parser(r_ast.pp, "parseASTpp") ;
  local r_ast_cst::Program_c = parseASTpp.parseTree ;

  local ast_warnings::[Error] = getWarnings(r_ast.errors) ;
  local ast_errors::[Error] = getErrors(r_ast.errors) ;

  local r_hst::Program = r_ast.host ;
  local parseHOSTpp::ParseResult<Program_c>
     = promelaParser(r_hst.pp, "parseHOSTpp") ;
  local r_host_cst::Program_c = parseHOSTpp.parseTree ;

  local parsedInlined::ParseResult<Program_c>
    = ext_parser(r_ast.inlined.pp, "parseInlinedpp") ;
  local r_inlined_cst::Program_c = parsedInlined.parseTree ;
   
  local attribute print_debug :: IO ;
  print_debug = 
    if ! debugMode && parseHOSTpp.parseSuccess then text.io 
    else
    print( "\n" ++
           "Command line arguments: " ++ implode (" ", args) ++
           "\n\n" ++
           "CST pretty print: \n================= \n" ++ r_cst.pp ++
           "\n\n" ++ 
           "AST pretty print: \n================= \n" ++ r_ast.pp ++
           "\n\n" ++
           "AST host pretty print: \n================= \n" ++ r_hst.pp ++
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
                 --addLineNumbers(r_ast.pp) ++ "\n\n"
                 r_ast.pp ++ "\n\n"
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
                 --addLineNumbers(r_hst.pp) ++ "\n\n"
                 r_hst.pp ++ "\n\n"
           )
           ++ "\n\n"
           , text.io ) ;

  local attribute print_success :: IO ;
  print_success = 
    print( (if null(ast_warnings)  then "" --" No warnings to report.\n" 
            else "Warnings: \n" ++ showErrors(ast_warnings) ++ "\n"
           ) ++
           (if null(ast_errors)  then "No semantic errors detected.\n" 
            else "Errors: \n" ++ showErrors(ast_errors) ++ "\n"
           ) ++
           "\n"
           , print_debug ) ;

  local splitFileName::Pair<String String> = splitFileNameAndExtension(filename) ;

  local writeHostIO::IO
    = if   splitFileName.snd == "xpml" && parseHOSTpp.parseSuccess
      then writeFile( splitFileName.fst ++ ".pml", r_host_cst.pp,
                      print ("Writing pure-Promela version as \"" ++ 
                             splitFileName.fst ++ ".pml\" \n",
                             print_success ) )
      else print_success ;

  local inlinedFileName::String = splitFileName.fst ++ "_inlined." ++
                                  splitFileName.snd ;
  local writeInlinedIO::IO 
    = if   parseHOSTpp.parseSuccess
      then writeFile ( inlinedFileName, r_inlined_cst.pp, 
                      print ("Writing inlined version as \"" ++ 
                             inlinedFileName ++ "\" \n",
                             writeHostIO ) )
      else writeHostIO ;
      -- Write the inlined version of a .xpml or .pml file with the same 
      -- extension.

  local writeFilesIO::IO = writeInlinedIO ;

  local attribute print_failure :: IOVal<Integer>;
  print_failure =
   ioval (
    print("Encountered a parse error:\n" ++ result.parseErrors ++ "\n", 
          text.io) , 1 ) ;

  return if   ! fileExists.iovalue 
         then ioval(print ("\n\nFile \"" ++ filename ++ "\" not found.\n" ++
                           "usage:  java -jar <nameOfAblePjar>.jar " ++
                           " [ --debug ] <filename>\n\n", fileExists.io ),
                    -1 )
         else
         if   result.parseSuccess 
         then ioval(writeFilesIO, 0)
         else print_failure;
}

