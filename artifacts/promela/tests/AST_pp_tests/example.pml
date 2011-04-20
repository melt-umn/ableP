/* #define N	4
#define p	(x < 4)
*/
int x = 4;

active proctype A()
{
	do
	:: x%2 -> x = 3*x+1
	od
}

active proctype B()
{
	do
	:: !(x%2) -> x = x/2
	od
}

never {    /* <>[](x < 4) */
T0_init:
        if
        :: (x < 4) -> goto accept_S4
        :: true -> goto T0_init
        fi;
accept_S4:
        if
        :: (x < 4) -> goto accept_S4
        fi;
}
