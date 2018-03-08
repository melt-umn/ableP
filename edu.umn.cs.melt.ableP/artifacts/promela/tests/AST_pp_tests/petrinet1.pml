# 1 "petrinet1.pml"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "petrinet1.pml"


byte p1, p2, p3;
byte p4, p5, p6;







init
{	p1 = 1; p4 = 1;	
	do
	:: atomic { (p1>0) -> p1--	-> p2++ }
	:: atomic { (p2>0&&p4>0) -> p2--; p4--	-> p3++ }
	:: atomic { (p3>0) -> p3--	-> p1++; p4++ }
	:: atomic { (p4>0) -> p4--	-> p5++ }
	:: atomic { (p1>0&&p5>0) -> p1--; p5-- -> p6++ }
	:: atomic { (p6>0) -> p6--	-> p4++; p1++ }
	od
}
