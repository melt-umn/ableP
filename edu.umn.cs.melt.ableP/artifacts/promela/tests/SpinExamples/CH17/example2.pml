c_decl {
   typedef struct Coord {
	int x, y;
   } Coord;
}

c_code { Coord pt; }	/* embed the declaration of pt in C */
c_track "&pt" "sizeof(Coord)"	/* but track its value */

int z = 3;	/* a standard global declaration */

active proctype example()
{
   c_code { pt.x = pt.y = 0; };	/* no prefix needed */

   do
   :: c_expr { pt.x == pt.y } ->
		c_code { pt.y++; }
   :: else ->
		break
   od;
   c_code {
	printf("values %d: %d, %d,%d\n",
	  Pexample->_pid, now.z, pt.x, pt.y);
   };
   assert(false)	/* trigger an error trail */
}
