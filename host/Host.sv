grammar edu:umn:cs:melt:ableP:host ;

exports edu:umn:cs:melt:ableP:terminals ;
exports edu:umn:cs:melt:ableP:concretesyntax ;
--exports edu:umn:cs:melt:ableP:host:driver ;

import edu:umn:cs:melt:ableP:concretesyntax only Root_c ;

parser hostParser :: Root_c {
 edu:umn:cs:melt:ableP:terminals ;
 edu:umn:cs:melt:ableP:concretesyntax ;
}
