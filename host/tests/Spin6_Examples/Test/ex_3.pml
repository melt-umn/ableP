/* http://spinroot.com/spin/Doc/Exercises.pdf ex.3 */

/* CCITT Recommendation X.21 -- based on paper by C.H. West, 1978 */

mtype = { a, b, c, d, e, i, l, m, n, q, r, u, v };

chan dce = [0] of { mtype };
chan dte = [0] of { mtype };

active proctype dte_proc()
{
state01:
	do
	:: dce!b -> /* state21 */ dce!a
	:: dce!i -> /* state14 */
			if
			:: dte?m -> goto state19
			:: dce!a
			fi
	:: dte?m -> goto state18
	:: dte?u -> goto state08
	:: dce!d -> break
	od;

	/* state02: */
	if
	:: dte?v
	:: dte?u -> goto state15
	:: dte?m -> goto state19
	fi;
state03:
	dce!e;
	/* state04: */
	if
	:: dte?m -> goto state19
	:: dce!c
	fi;
	/* state05: */
	if
	:: dte?m -> goto state19
	:: dte?r
	fi;
	/* state6A: */
	if
	:: dte?m -> goto state19
	:: dte?q
	fi;
state07:
	if
	:: dte?m -> goto state19
	:: dte?r
	fi;
	/* state6B: */
	if		/* non-deterministic select */
	:: dte?q -> goto state07
	:: dte?q
	:: dte?m -> goto state19
	fi;
	/* state10: */
	if
	:: dte?m -> goto state19
	:: dte?r
	fi;
state6C:
	if
	:: dte?m -> goto state19
	:: dte?l
	fi;
	/* state11: */
	if
	:: dte?m -> goto state19
	:: dte?n
	fi;
	/* state12: */
	if
	:: dte?m -> goto state19
	:: dce!b -> goto state16
	fi;

state15:
	if
	:: dte?v -> goto state03
	:: dte?m -> goto state19
	fi;
state08:
	if
	:: dce!c
	:: dce!d -> goto state15
	:: dte?m -> goto state19
	fi;
	/* state09: */
	if
	:: dte?m -> goto state19
	:: dte?q
	fi;
	/* state10B: */
	if
	:: dte?r -> goto state6C
	:: dte?m -> goto state19
	fi;
state18:
	if
	:: dte?l -> goto state01
	:: dte?m -> goto state19
	fi;
state16:
	dte?m;
	/* state17: */
	dte?l;
	/* state21: */
	dce!a; goto state01;
state19:
	dce!b;
	/* state20: */
	dte?l;
	/* state21: */
	dce!a; goto state01
}

active proctype dce_proc()
{
state01:
	do
	:: dce?b -> /* state21 */ dce?a
	:: dce?i -> /* state14 */
			if
			:: dce?b -> goto state16
			:: dce?a
			fi
	:: dte!m -> goto state18
	:: dte!u -> goto state08
	:: dce?d -> break
	od;

	/* state02: */
	if
	:: dte!v
	:: dte!u -> goto state15
	:: dce?b -> goto state16
	fi;
state03:
	dce?e;
	/* state04: */
	if
	:: dce?b -> goto state16
	:: dce?c
	fi;
	/* state05: */
	if
	:: dce?b -> goto state16
	:: dte!r
	fi;
	/* state6A: */
	if
	:: dce?b -> goto state16
	:: dte!q
	fi;
state07:
	if
	:: dce?b -> goto state16
	:: dte!r
	fi;
	/* state6B: */
	if		/* non-deterministic select */
	:: dte!q -> goto state07
	:: dte!q
	:: dce?b -> goto state16
	fi;
	/* state10: */
	if
	:: dce?b -> goto state16
	:: dte!r
	fi;
state6C:
	if
	:: dce?b -> goto state16
	:: dte!l
	fi;
	/* state11: */
	if
	:: dce?b -> goto state16
	:: dte!n
	fi;
	/* state12: */
	if
	:: dce?b -> goto state16
	:: dte!m -> goto state19
	fi;

state15:
	if
	:: dte!v -> goto state03
	:: dce?b -> goto state16
	fi;
state08:
	if
	:: dce?c
	:: dce?d -> goto state15
	:: dce?b -> goto state16
	fi;
	/* state09: */
	if
	:: dce?b -> goto state16
	:: dte!q
	fi;
	/* state10B: */
	if
	:: dte!r -> goto state6C
	:: dce?b -> goto state16
	fi;
state18:
	if
	:: dte!l -> goto state01
	:: dce?b -> goto state16
	fi;
state16:
	dte!m;
	/* state17: */
	dte!l;
	/* state21: */
	dce?a; goto state01;
state19:
	dce?b;
	/* state20: */
	dte!l;
	/* state21: */
	dce?a; goto state01
}
