grammar edu:umn:cs:melt:ableP:host:core:coreParser ;

import edu:umn:cs:melt:ableP:host:core:concretesyntax
  only Program_c ;

parser promelaCoreParser :: Program_c {
 edu:umn:cs:melt:ableP:host:core:terminals ;
 edu:umn:cs:melt:ableP:host:core:concretesyntax ;

 -- We need to import the ableC terminals since they define a lexer class,
 -- Ccomment, that Promela coments and white space take precedence over.
 -- Without including this, Copper raises an error.
 -- ToDo: file a bug about this and put bug# here.
 edu:umn:cs:melt:ableC:concretesyntax ;
}
