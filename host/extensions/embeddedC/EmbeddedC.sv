grammar edu:umn:cs:melt:ableP:host:extensions:embeddedC ;

imports edu:umn:cs:melt:ableP:host:core:abstractsyntax ;
imports edu:umn:cs:melt:ableP:host:core:concretesyntax ;
imports edu:umn:cs:melt:ableP:host:core:terminals ;

imports edu:umn:cs:melt:ableC:terminals 
 only pp with pp as ansi_c_pp ;

imports edu:umn:cs:melt:ableC:concretesyntax 
 only Expr_c, DeclarationList_c, StmtList_c, Root_c, CompoundStatement_c 
 with Expr_c as Ansi_C_Expr,
      DeclarationList_c as Ansi_C_DeclarationList,
      StmtList_c as Ansi_C_StmtList,
      Root_c as Ansi_C_Root ;
