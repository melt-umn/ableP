grammar edu:umn:cs:melt:ableP:artifacts:promela ;

import edu:umn:cs:melt:ableP:host ;

function main
IOVal<Integer> ::= args::[String] mainIO::IOToken
{ return driver (args, promelaParser, mainIO) ;  }

