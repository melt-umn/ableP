c_decl {
   typedef struct Coord {
	int x, y;
   } Coord;
}

c_state "Coord pt" "Global"

int z = 3;	/* a standard global declaration */

active proctype example()
{
   c_code { now.pt.x = now.pt.y = 0; };

   do
   :: c_expr { now.pt.x == now.pt.y } ->
		c_code { now.pt.y++; }
   :: else ->
		break
   od;
   c_code {
	printf("values %d: %d, %d,%d\n",
	  Pexample->_pid, now.z, now.pt.x, now.pt.y);
   };
   assert(false)	/* trigger an error trail */
}
