#define N 2

init {	/* example ex2 */
	chan dummy = [N] of { byte };
	do
	:: dummy!85
	:: dummy!170
	od
}
