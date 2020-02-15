{- This grammar defines some extensions to the core Promela
   specification that add new features added for versions 5 and 6.
   The core Promela specification, in the ableP:host:core grammar, is
   based on an earlier specification of Promela version 4.2.9.  The
   core does, however, implement the new version 6 scope rules of
   Promela.

   Add these "version 6" features as extensions is done primarily to
   show how features can be added as language extensions.
 -}

grammar edu:umn:cs:melt:ableP:host:extensions:v6 ;

imports edu:umn:cs:melt:ableP:host:core:concretesyntax ;
imports edu:umn:cs:melt:ableP:host:core:abstractsyntax ;

imports edu:umn:cs:melt:ableP:host:extensions:typeChecking;
