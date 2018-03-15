#define Place	byte

Place P1, P2, P4, P5, RC, CC, RD, CD;
Place p1, p2, p4, p5, rc, cc, rd, cd;

#define inp1(x)		(x>0) -> x--
#define inp2(x,y)	(x>0&&y>0) -> x--; y--
#define out1(x)		x++
#define out2(x,y)	x++; y++

init
{	P1 = 1; p1 = 1;	/* initial marking */
	do
	:: atomic { inp1(P1)	-> out2(rc,P2)	}
	:: atomic { inp2(P2,CC)	-> out1(P4)	}
	:: atomic { inp1(P4)	-> out2(P5,rd)	}
	:: atomic { inp2(P5,CD)	-> out1(P1)	}
	:: atomic { inp2(P1,RC)	-> out2(P4,cc)	}
	:: atomic { inp2(P4,RD) -> out2(P1,cd)	}
	:: atomic { inp2(P5,RD)	-> out1(P1)	}

	:: atomic { inp1(p1)	-> out2(RC,p2)	}
	:: atomic { inp2(p2,cc)	-> out1(p4)	}
	:: atomic { inp1(p4)	-> out2(p5,RD)	}
	:: atomic { inp2(p5,cd)	-> out1(p1)	}
	:: atomic { inp2(p1,rc)	-> out2(p4,CC)	}
	:: atomic { inp2(p4,rd) -> out2(p1,CD)	}
	:: atomic { inp2(p5,rd)	-> out1(p1)	}
	od
}
