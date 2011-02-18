grammar edu:umn:cs:melt:ableP:host ;

exports edu:umn:cs:melt:ableP:terminals ;
exports edu:umn:cs:melt:ableP:concretesyntax ;
--exports edu:umn:cs:melt:ableP:host:driver ;

import edu:umn:cs:melt:ableP:concretesyntax only Program_c ;

parser hostParser :: Program_c {
 edu:umn:cs:melt:ableP:terminals ;
 edu:umn:cs:melt:ableP:concretesyntax ;
}
