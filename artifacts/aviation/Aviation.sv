grammar edu:umn:cs:melt:ableP:comp:aviation ;

import edu:umn:cs:melt:ableP:host ;
import edu:umn:cs:melt:ableP:extensions:tables ;

import lib:langproc ;

parser aviationParser :: Program_c {
 edu:umn:cs:melt:ableP:host ;

-- edu:umn:cs:melt:ableC:terminals ;
-- edu:umn:cs:melt:ableC:concretesyntax ;

 edu:umn:cs:melt:ableP:extensions:tables ;
 edu:umn:cs:melt:ableP:extensions:enhancedSelect ;
}

function main
IOVal<Integer> ::= args::[String] mainIO::IO
{ return driver (args, aviationParser, promelaParser, mainIO) ;
}

