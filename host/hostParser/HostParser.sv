grammar edu:umn:cs:melt:ableP:host:hostParser ;

import edu:umn:cs:melt:ableP:host:core:concretesyntax
  only Program_c ;

parser promelaParser :: Program_c {
 edu:umn:cs:melt:ableP:host:core:terminals ;
 edu:umn:cs:melt:ableP:host:core:concretesyntax ;

 edu:umn:cs:melt:ableP:host:extensions:embeddedC ;
 edu:umn:cs:melt:ableP:host:extensions:v6 ;

 edu:umn:cs:melt:ableC:terminals ;
 edu:umn:cs:melt:ableC:concretesyntax ;
}
