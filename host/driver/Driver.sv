grammar edu:umn:cs:melt:ableP:host:driver;

import edu:umn:cs:melt:ableP:terminals;
import edu:umn:cs:melt:ableP:concretesyntax only Program_c, ast ;
import edu:umn:cs:melt:ableP:abstractsyntax only Program, pp ;

function driver
IOVal<Integer> ::= args::[String]
                   ext_parser::Function(ParseResult<Program_c>::=String String) 
                   host_parser::Function(ParseResult<Program_c>::=String String)
                   driverIO::IO 
{
  local filename::String = head(args) ;
  production fileExists :: IOVal<Boolean>  = isFile(filename, driverIO);

  production attribute text :: IOVal<String>;
  text = readFile(filename, fileExists.io);

  local attribute result :: ParseResult<Program_c>;
  result = ext_parser(text.iovalue, filename);

  local attribute r_cst :: Program_c ;
  r_cst = result.parseTree ;

-- local attribute write_c_io :: IO ;
-- write_c_io = writeFile("output.c", r_cst.c_code, text.io ) ;

  local attribute r_ast :: Program ;
  r_ast = r_cst.ast ;

  local attribute print_success :: IOVal<Integer>;
  print_success = 
   ioval (
    print( "\n" ++
           "Command line arguments: " ++ head(args) ++
           "\n\n" ++
           "CST pretty print: \n" ++ r_cst.pp ++
           "\n\n" ++ 
           "AST pretty print: \n" ++ r_ast.pp ++
           "\n\n" ++
 --          "Errors: " ++
 --          (if null(r_ast.errors)  then " No semantic errors!\n" 
 --           else "\n" ++
 --                implode("", r_ast.errors) 
 --          )
           "\n\n"
           , text.io )
        , 0 ) ;

--  local attribute write_success :: IO ;
--  write_success =
--    writeFile ( "output.c", r_ast.c_code, print_success ) ;

  local attribute print_failure :: IOVal<Integer>;
  print_failure =
   ioval (
    print("Encountered a parse error:\n" ++ result.parseErrors ++ "\n", 
          text.io) , 1 ) ;

  return if   ! fileExists.iovalue 
         then error ("\n\nFile \"" ++ filename ++ "\" not found.\n")
         else
         if   result.parseSuccess 
         then print_success 
         else print_failure;
}
