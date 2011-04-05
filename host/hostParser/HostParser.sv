grammar edu:umn:cs:melt:ableP:host:hostParser ;

--exports edu:umn:cs:melt:ableP:terminals ;
--exports edu:umn:cs:melt:ableP:concretesyntax ;
--exports edu:umn:cs:melt:ableP:abstractsyntax ;
--exports edu:umn:cs:melt:ableP:host:driver ;

-- Need to allow qualifications and renaming on exports.
--exports edu:umn:cs:melt:ableC:terminals as AbleC ;
--exports edu:umn:cs:melt:ableC:concretesyntax as AbleC ;

import edu:umn:cs:melt:ableP:concretesyntax only Program_c ;

parser promelaParser :: Program_c {
 edu:umn:cs:melt:ableP:terminals ;
 edu:umn:cs:melt:ableP:concretesyntax ;

 edu:umn:cs:melt:ableC:terminals ;
 edu:umn:cs:melt:ableC:concretesyntax ;
}
