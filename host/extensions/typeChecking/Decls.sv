grammar edu:umn:cs:melt:ableP:host:extensions:typeChecking ;

attribute typerep, typereps occurs on Decls ;

inherited attribute typerep_in :: TypeRep ;
attribute typerep, typerep_in occurs on Declarator ;

aspect production seqDecls
ds::Decls ::= ds1::Decls ds2::Decls
{ ds.typerep = errorTypeRep() ; 
  ds.typereps = ds1.typereps ++ ds2.typereps ;
}
aspect production emptyDecl
ds::Decls ::= 
{ ds.typerep = errorTypeRep() ; 
  ds.typereps = [ ];
}

aspect production defaultVarDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator
{ ds.typerep = v.typerep ;
  ds.typereps = [ ds.typerep ] ;
  v.typerep_in = t.typerep;
  
}
aspect production defaultVarAssignDecl
ds::Decls ::= vis::Vis t::TypeExpr v::Declarator e::Expr
{ ds.typerep = v.typerep ;
  ds.typereps = [ ds.typerep ] ;
  v.typerep_in = t.typerep;
}

aspect production vd_id
vd::Declarator ::= id::ID
{ vd.typerep = vd.typerep_in ;
}
aspect production vd_idconst
vd::Declarator ::= id::ID cnt::CONST
{ vd.typerep = vd.typerep_in ; -- ToDo - are there typing issues here?
}
aspect production vd_array
vd::Declarator ::= id::ID cnt::CONST
{ vd.typerep = arrayTypeRep(vd.typerep_in);
}

aspect production mtypeDecl
ds::Decls ::= v::Vis name::ID
{ ds.typerep = mtypeTypeRep() ;
}


aspect production procDecl
proc::Decls ::= i::Inst procty::ProcType nm::ID dcl::Decls
                pri::Priority ena::Enabler 
                b::Stmt
{  proc.typerep = procTypeRep( dcl.typereps ) ;
}


