c_code { int x; }
c_track "&x" "sizeof(int)"

active proctype simple()
{
   c_code { x = 2; };
   if
   :: c_code { x = x+2; }; assert(c_expr { x==4 })
   :: c_code { x = x*3; }; assert(c_expr { x==6 })
   fi
}
