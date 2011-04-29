/* SpinExamples/CH2/prodcons2.pml */

int a = 1 ;
int b = 2 ;

inline assign(x, y) { x = y }

active proctype producer()
{
 assign(a,b) ;
}
