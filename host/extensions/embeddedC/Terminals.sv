grammar edu:umn:cs:melt:ableP:host:extensions:embeddedC ;

import edu:umn:cs:melt:ableC:concretesyntax:ansiC89 ;

terminal C_CODE  'c_code'   lexer classes {promela,promela_kwd};
terminal C_DECL  'c_decl'   lexer classes {promela,promela_kwd};
terminal C_EXPR  'c_expr'   lexer classes {promela,promela_kwd};
terminal C_STATE 'c_state'  lexer classes {promela,promela_kwd};
terminal C_TRACK 'c_track'  lexer classes {promela,promela_kwd};
