grammar edu:umn:cs:melt:ableP:terminals ;

import edu:umn:cs:melt:ableC:terminals ;


terminal Bogus_t '@@' ;

--ignore terminal LineComment  /[\/][\/].*/ ;
--ignore terminal WhiteSpace   /[\n\t\ ]+/ ;


----------

lexer class promela_kwd;
lexer class promela;


-- Promela classifies identifiers as either:
--  - process type names 
--  - inline names
--  - other ??


parser attribute usedProcess :: Integer
     action { usedProcess = 0 ; } ;

parser attribute usedInline :: Integer
     action { usedInline = 0 ; };

parser attribute pnames :: [String]
     action { pnames = [  ] ; } ;

parser attribute inames :: [String]
     action { inames = [ ] ; } ;

parser attribute unames :: [String]
     action { unames = [ ] ; } ;

{-
disambiguate Identifier_t,TypeName_t
 {
   pluck if listContains(lexeme,head(typenames))
         then TypeName_t
         else Identifier_t;
 }
-}

-- Disambiguate ID & PNAME
--disambiguation group ProcessID with {ID,PNAME}
disambiguate ID, PNAME
 {
    pluck if listContains(lexeme,pnames)
          then PNAME
          else ID;
}


-- Disambiguate ID & INAME
--disambiguation group InlineID with {ID,INAME}
disambiguate ID, INAME
 {
    pluck if listContains(lexeme,inames)
          then INAME
          else ID;
}

-- Disambiguate ID & UNAME
--disambiguation group UserID with {ID,UNAME}
disambiguate ID, UNAME
 {
    pluck if listContains(lexeme,unames)
          then UNAME
          else ID;
}


-- Disambiguate ID,INAME & PNAME
--disambiguation group ProInID with {ID,PNAME,INAME}
disambiguate ID, PNAME, INAME
{
    pluck if listContains(lexeme,pnames)
          then PNAME
          else if listContains(lexeme,inames)
               then INAME
               else ID;
}

-- Disambiguate ID,UNAME & PNAME
--disambiguation group ProInID with {ID,PNAME,UNAME}
disambiguate ID, PNAME, UNAME
{
    pluck if listContains(lexeme,pnames)
          then PNAME
          else if listContains(lexeme,unames)
               then UNAME
               else ID;
}


-- Disambiguate ID,INAME,PNAME & UNAME
--disambiguation group ProInUseID with {ID,PNAME,INAME,UNAME}
disambiguate ID, PNAME, INAME, UNAME
 {
     pluck if listContains(lexeme,pnames)
           then PNAME
           else if listContains(lexeme,inames)
                then INAME
                else if listContains(lexeme,unames)
                     then UNAME
                     else ID;
}

                        
-- White space and comments --
------------------------------
lexer class p_WS_Comments ;
ignore terminal WhiteSpace_P /[\t\n\ ]+/ 
 lexer classes {promela, p_WS_Comments} , dominates { Ccomment } ;

ignore terminal BlockComment_P /[\/][\*]([^\*]|[\r\n]|([\*]+([^\*\/]|[\r\n])))*[\*]+[\/]/ 
 lexer classes {promela, p_WS_Comments} , dominates { Ccomment };

ignore terminal LineComment_P  /[\/][\/].*/ 
 lexer classes {promela, p_WS_Comments} , dominates { Ccomment } ;

--ignore terminal CPPDirectiveLayout_P /[#].*/ dominates { p_WS_Comments, CPPDirectiveLayout_P, WhiteSpace }   ;


terminal ASSERT       'assert'       lexer classes {promela,promela_kwd};
terminal PRINTM       'printm'       lexer classes {promela,promela_kwd};
terminal PRINTF       'printf'       lexer classes {promela,promela_kwd};

terminal C_CODE  'c_code'   lexer classes {promela,promela_kwd};
terminal C_DECL  'c_decl'   lexer classes {promela,promela_kwd};
terminal C_EXPR  'c_expr'   lexer classes {promela,promela_kwd};
terminal C_STATE 'c_state'  lexer classes {promela,promela_kwd};
terminal C_TRACK 'c_track'  lexer classes {promela,promela_kwd};

terminal RUN          'run'          lexer classes {promela,promela_kwd};
terminal LEN          'len'          lexer classes {promela,promela_kwd};
terminal ENABLED      'enabled'      lexer classes {promela,promela_kwd};
terminal EVAL         'eval'         lexer classes {promela,promela_kwd};
terminal PC_VALUE     'pc_value'     lexer classes {promela,promela_kwd};

terminal TYPEDEF      'typedef'      lexer classes {promela,promela_kwd};
terminal MTYPE        'mtype'        lexer classes {promela,promela_kwd}; 
terminal INLINE       'inline'       lexer classes {promela,promela_kwd};
-- missing LABEL????
terminal OF           'of'           lexer classes {promela,promela_kwd};

terminal GOTO         'goto'         lexer classes {promela,promela_kwd};
terminal BREAK        'break'        lexer classes {promela,promela_kwd};
terminal ELSE         'else'         lexer classes {promela,promela_kwd};
terminal SEMI         /(\->)|(;)/    lexer classes {promela},
                                    precedence = 2, association = right;

terminal IF           'if'           lexer classes {promela,promela_kwd};
terminal FI           'fi'           lexer classes {promela,promela_kwd};
terminal DO           'do'           lexer classes {promela,promela_kwd};
terminal OD           'od'           lexer classes {promela,promela_kwd};
-- missing FOR - v6
-- missing SELECT - v6
-- missing IN - v6
terminal SEP          '::'           lexer classes {promela};
-- missing DOTDOT

terminal ATOMIC       'atomic'       lexer classes {promela,promela_kwd};
-- missing NON_ATOMIC
terminal D_STEP       'd_step'       lexer classes {promela,promela_kwd};
terminal UNLESS       'unless'       lexer classes {promela,promela_kwd};

terminal TIMEOUT      'timeout'      lexer classes {promela,promela_kwd};
terminal NONPROGRESS  'np_'          lexer classes {promela_kwd};

terminal ACTIVE       'active'       lexer classes {promela,promela_kwd};
terminal D_PROCTYPE   'D_proctype'   lexer classes {promela,promela_kwd};
terminal PROCTYPE     'proctype'     lexer classes {promela,promela_kwd};

terminal HIDDEN       'hidden'       lexer classes {promela,promela_kwd};
terminal SHOW         'show'         lexer classes {promela,promela_kwd};
terminal ISLOCAL      'local'        lexer classes {promela,promela_kwd};

terminal PRIORITY     'priority'     lexer classes {promela,promela_kwd};
terminal PROVIDED     'provided'     lexer classes {promela,promela_kwd};

terminal FULL         'full'         lexer classes {promela,promela_kwd};
terminal EMPTY        'empty'        lexer classes {promela,promela_kwd};
terminal NFULL        'nfull'        lexer classes {promela,promela_kwd};
terminal NEMPTY       'nempty'       lexer classes {promela,promela_kwd};

terminal CONST        /(true)|(false)|(skip)|[0-9]*/ 
                                     lexer classes {promela,promela_kwd};
-- terminal TYPE /(bit)|(bool)|(byte)|(chan)|(int)|(mtype)|(pid)|(short)|(unsigned)/
--                                       lexer classes {promela,promela_kwd};
-- New terminals for declaring Type Expression
terminal BIT          'bit'          lexer classes {promela,promela_kwd};
terminal BOOL         'bool'         lexer classes {promela,promela_kwd};
terminal BYTE         'byte'         lexer classes {promela,promela_kwd};
terminal CHAN         'chan'         lexer classes {promela,promela_kwd};
terminal INT          'int'          lexer classes {promela,promela_kwd};
-- MTYPE ???
terminal PID          'pid'          lexer classes {promela,promela_kwd};
terminal SHORT        'short'        lexer classes {promela,promela_kwd};
terminal UNSIGNED     'unsigned'     lexer classes {promela,promela_kwd};
--
terminal XU           /(xr)|(xs)/    lexer classes {promela_kwd};

terminal ID           /[a-zA-Z\_][a-zA-Z\_0-9]*/
                                     lexer classes {promela}, submits to {promela_kwd};
terminal PNAME        /[a-zA-Z\_][a-zA-Z\_0-9]*/
                                     lexer classes {promela}, submits to {promela_kwd};
terminal UNAME        /[a-zA-Z\_][a-zA-Z\_0-9]*/
                                     lexer classes {promela}, submits to {promela_kwd};
terminal INAME        /[a-zA-Z\_][a-zA-Z\_0-9]*/
                                     lexer classes {promela}, submits to {promela_kwd};

terminal STRING      /[\"]([^\"]|[\\][\"])*[\"]/
                                     lexer classes {promela};
terminal CLAIM        'never'        lexer classes {promela,promela_kwd};
terminal TRACE        /(trace)|(notrace)/  
                                     lexer classes {promela,promela_kwd};
terminal INIT         'init'         lexer classes {promela,promela_kwd};
-- missing LTL - v6

terminal ASGN         '='            lexer classes {promela},
                                     precedence = 1, association = right;

terminal R_RCV   '??' lexer classes {promela},precedence = 2,association = left;
terminal RCV     '?'  lexer classes {promela},precedence = 2,association = left;
terminal O_SND   '!!' lexer classes {promela},precedence = 2,association = left;
terminal SND     '!'  lexer classes {promela},precedence = 2,association = left;

-- missing IMPLIES
-- missing EQUIV

terminal OR      '||' lexer classes {promela},precedence = 5,association = left;

terminal AND     '&&' lexer classes {promela},precedence = 6,association = left;

-- missing ALWAYS
-- missing EVENTUALLY

-- missing UNTIL WEAK_UNTIL RELEASE
-- missing NEXT

terminal OR_T    '|'  lexer classes {promela},precedence = 11,association = left;
terminal XOR     '^'  lexer classes {promela},precedence = 12,association = left;
terminal AND_T   '&'  lexer classes {promela},precedence = 13,association = left;

-- EE maybe should be EQ
terminal EE      '==' lexer classes {promela},precedence = 15,association = left;
terminal NE      '!=' lexer classes {promela},precedence = 15,association = left;

terminal LE      '<=' lexer classes {promela},precedence = 20,association = left;
terminal LT      '<'  lexer classes {promela},precedence = 20,association = left;
terminal GE      '>=' lexer classes {promela},precedence = 20,association = left;
terminal GT      '>'  lexer classes {promela},precedence = 20,association = left;

terminal LSHIFT  '<<' lexer classes {promela},precedence = 25,association = left;
terminal RSHIFT  '>>' lexer classes {promela},precedence = 25,association = left;

terminal PLUS    '+'  lexer classes {promela},precedence = 30,association = left;
terminal MINUS   '-'  lexer classes {promela},precedence = 30,association = left;

terminal STAR    '*'  lexer classes {promela},precedence = 35,association = left;
terminal DIV     '/'  lexer classes {promela},precedence = 35,association = left;
terminal MOD     '%'  lexer classes {promela},precedence = 35,association = left;

terminal INCR    '++' lexer classes {promela},precedence = 40,association = right;
terminal DECR    '--' lexer classes {promela},precedence = 40,association = right;

terminal TILD    '~'  lexer classes {promela},precedence = 45,association = right;

terminal STOP    '.'  lexer classes {promela},precedence = 50,association = left;
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

terminal CHARLIT /[\']([^\']|[\\][\'])*[\']/ lexer classes {promela};
-- missing UMIN ?
-- missing NEG

-- missing DOT


terminal SKIP         'skip'         lexer classes {promela,promela_kwd};
--terminal XR           'xr'           lexer precedence = 10 ;
--terminal XS           'xs'           lexer precedence = 10 ;



-- note that one option clashes with MTYPE above --




-- Punctuation symbols not defines with named terminals
terminal LCURLY '{' lexer classes {promela};
terminal RCURLY '}' lexer classes {promela};

terminal LSQUARE '[' lexer classes {promela},precedence = 50,association = right;
terminal RSQUARE ']' lexer classes {promela},precedence = 50,association = right;

terminal LPAREN '(' lexer classes {promela},precedence = 50,association = left;
terminal RPAREN ')' lexer classes {promela},precedence = 50,association = left;
terminal COMMA  ',' lexer classes {promela};

terminal ATRATE  '@' lexer classes {promela};
terminal SCOLON  ':' lexer classes {promela},precedence = 2,association = right;



-- Keywords:
--	active		assert		atomic		bit
--	bool		break		byte		chan
--	d_step		D_proctype	do		else
--	empty		enabled		fi		full
--	goto		hidden		if		init
--	int		len		mtype		nempty
--	never		nfull		od		of
--	pc_value	printf		priority	proctype
--	provided	run		short		skip
--	timeout		typedef		unless		unsigned
--	xr		xs


function listContains
Boolean ::= element::String l::[String]
{
  return if length(l) == 0
         then false
         else if head(l) == element
              then true
              else listContains(element,tail(l));
}
