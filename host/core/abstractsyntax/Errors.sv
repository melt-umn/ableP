grammar edu:umn:cs:melt:ableP:host:core:abstractsyntax;

nonterminal Error with msg, loc ;
synthesized attribute msg::String ;
synthesized attribute loc::Loc ;

abstract production mkError
e::Error ::= m::String l::Loc
{ e.msg = l.pp ++ ": " ++ m ;
  e.loc = l ;
}

function mkErrorNoLoc
Error ::= m::String
{ return mkError (m, noLoc()) ; }

abstract production mkWarning
e::Error ::= m::String l::Loc
{ e.msg = l.pp ++ ": " ++ m ;
  e.loc = l ;
}

function mkWarningNoLoc
Error ::= m::String
{ return mkWarning (m, noLoc()) ; }

function showErrors
String ::= errs::[Error]
{ return if null(errs)
         then ""
         else head(errs).msg ++ "\n" ++ showErrors(tail(errs)) ;
}

function getErrors
[Error] ::= errs::[Error]
{ return if null(errs)
         then [ ] 
         else case e of
                mkError(_,_) -> [ head(errs) ]
              | _ -> [ ] end
              ++ getErrors(tail(errs)) ;
 -- ToDo: get rid of this when bug 1424 is fixed.
 local e :: Decorated Error = decorate head(errs) with {};
}

function getWarnings
[Error] ::= errs::[Error]
{ return if null(errs)
         then [ ] 
         else case e of
                mkWarning(_,_) -> [ head(errs) ]
              | _ -> [ ] end
              ++ getWarnings(tail(errs)) ;
 -- ToDo: get rid of this when bug 1424 is fixed.
 local e :: Decorated Error = decorate head(errs) with {} ;

}
