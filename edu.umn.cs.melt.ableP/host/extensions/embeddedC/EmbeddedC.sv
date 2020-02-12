grammar edu:umn:cs:melt:ableP:host:extensions:embeddedC ;

imports edu:umn:cs:melt:ableP:host:core:abstractsyntax ;
imports edu:umn:cs:melt:ableP:host:core:concretesyntax ;

imports edu:umn:cs:melt:ableC:concretesyntax 
 only Expr_c, DeclarationList_c, BlockItemList_c, Root, CompoundStatement_c, 
      LineComment_t, BlockComment_t, Spaces_t, NewLine_t
 with Expr_c as Ansi_C_Expr,
      DeclarationList_c as Ansi_C_DeclarationList,
      BlockItemList_c as Ansi_C_StmtList,
      Root as Ansi_C_Root,
      LineComment_t as CLineComment,
      BlockComment_t as CBlockComment,
      Spaces_t as CSpaces,
      NewLine_t as CNewLine ;

imports edu:umn:cs:melt:ableP:host:extensions:typeChecking ;
