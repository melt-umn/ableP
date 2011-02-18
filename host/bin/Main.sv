grammar edu:umn:cs:melt:ableP:host:bin ;

import edu:umn:cs:melt:ableP:host ;

import lib:langproc ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{ return simpleDriver (head(args), hostParser, processParseTree, mainIO) ;
}

function processParseTree
IOVal<Integer> ::= r_cst::Program_c pptIO::IO
{
 local attribute print_pp :: IO;
 print_pp =  print (
   "CST pp: \n" ++ r_cst.pp ++ "\n\n" ++
   "" , pptIO ) ;

 return ioval(print_pp,0);
}

