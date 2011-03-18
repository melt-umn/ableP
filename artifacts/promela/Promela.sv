grammar edu:umn:cs:melt:ableP:artifacts:promela ;

import edu:umn:cs:melt:ableP:host ;

import lib:langproc ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{ return -- simpleDriver (head(args), promelaParser, processParseTree, mainIO) ;
         driver (args, promelaParser, promelaParser, mainIO) ;
}

