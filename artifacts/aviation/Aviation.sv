grammar edu:umn:cs:melt:ableP:artifacts:aviation ;

import edu:umn:cs:melt:ableP:host ;
import edu:umn:cs:melt:ableP:extensions:tables ;
import edu:umn:cs:melt:ableP:extensions:enhancedSelect ;
import edu:umn:cs:melt:ableP:extensions:typeChecking ;
import edu:umn:cs:melt:ableP:extensions:discreteTime ;

parser aviationParser :: Program_c {
 edu:umn:cs:melt:ableP:host ;
 edu:umn:cs:melt:ableP:extensions:tables ;
 edu:umn:cs:melt:ableP:extensions:enhancedSelect ;
 edu:umn:cs:melt:ableP:extensions:discreteTime ;       }

function main  IOVal<Integer> ::= args::[String] mainIO::IO
{ return driver (args, aviationParser, mainIO) ;  }
