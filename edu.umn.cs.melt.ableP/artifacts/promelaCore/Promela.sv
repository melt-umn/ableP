grammar edu:umn:cs:melt:ableP:artifacts:promelaCore ;

{- This grammar defines the promelaCore instantiation of ableP.  This
   is an artifact that processes a subset of Promela programs.  This
   subset is essentially Promela from version 4 of SPIN without
   embedded C code.

   The 'main' function defined below reads in a '.pml' file, checks it
   for errors, and outputs the inlined version of the program.

 -}

import edu:umn:cs:melt:ableP:host:core ;

function main
IOVal<Integer> ::= args::[String] mainIO::IOToken
{ 
  return 
    if   length(args) != 1
    then exitWithErrors ("Usage: java -jar promelaCore.jar <filename.pml>",
                         mainIO)
    else 
    if   fileNameExtension != "pml"
    then exitWithErrors ("Filename must end in \".pml\".", 
                         mainIO)
    else
    if   ! fileExists.iovalue 
    then exitWithErrors ("File \"" ++ fileName ++ "\" not found.", 
                         fileExists.io)
    else
    if   ! parseText.parseSuccess
    then exitWithErrors (parseText.parseErrors ++ "\n",
                         text.io)
    else
    if   ! null(ast_errors)
    then exitWithErrors (showErrors(ast_errors), displayWarnings )

    else exitWithoutErrors (writeInlined) ;

  -- attributes for filename and tests of its existence
  local fileName::String = head(args) ;
  local fileNameExtension::String = splitFileName.snd ;
  local fileNameBase::String = splitFileName.fst ;
  local splitFileName::Pair<String String>
    = splitFileNameAndExtension(fileName) ;
  
  local fileExists :: IOVal<Boolean> = isFileT(fileName, mainIO);

  -- attributes to read and parse the file, and generate the concrete and
  -- abstract syntax trees
  local text::IOVal<String> = readFileT(fileName, fileExists.io);
  local parseText::ParseResult<Program_c> = promelaCoreParser(text.iovalue, fileName);

  local r_cst::Program_c = parseText.parseTree ;
  local r_ast::Program = r_cst.ast ;
  r_ast.rwrules_Program = [];

  -- attributes to compute warning and errors and display the warnings
  local ast_warnings::[Error] = getWarnings(r_ast.errors) ;
  local ast_errors::[Error] = getErrors(r_ast.errors) ;

  local displayWarnings::IOToken =
    printT( if   null(ast_warnings)
           then "" --" No warnings to report.\n" 
           else "Warnings: \n" ++ showErrors(ast_warnings) ++ "\n"
           , text.io ) ;

  -- attributes to compute the inlined version and write it to a file.
  local writeInlined::IOToken 
    = if   parsedInlined.parseSuccess
      then writeFileT ( inlinedFileName, r_inlined_cst.pp, displayWarnings )
      else printT ("Internal error: parsing generated inlined program failed.",
                  displayWarnings) ;
  local inlinedFileName::String = splitFileName.fst ++ "_inlined." ++
                                  splitFileName.snd ;
  local parsedInlined::ParseResult<Program_c>
    = promelaCoreParser(r_ast.inlined.pp, "parsedInlinedpp") ;
  local r_inlined_cst::Program_c = parsedInlined.parseTree ;
}

function exitWithErrors
IOVal<Integer> ::= msg::String eIO::IOToken
{
  return ioval ( printT (msg ++"\n\n", eIO), 1) ;
}
function exitWithoutErrors
IOVal<Integer> ::= eIO::IOToken
{
  return ioval (eIO, 0) ;
}
