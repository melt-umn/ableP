grammar edu:umn:cs:melt:ableP:artifacts:promela ;

import edu:umn:cs:melt:ableP:host ;

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{ return driver (args, promelaParser, mainIO) ;  }

