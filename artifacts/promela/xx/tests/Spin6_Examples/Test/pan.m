#define rand	pan_rand
#if defined(HAS_CODE) && defined(VERBOSE)
	cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC loop */
	case 3: /* STATE 1 - loops.pml:5 - [a = ((a+1)%3)] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)this)->_1_a);
		((P0 *)this)->_1_a = ((((int)((P0 *)this)->_1_a)+1)%3);
#ifdef VAR_RANGES
		logval("loop:a", ((int)((P0 *)this)->_1_a));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 4: /* STATE 2 - loops.pml:7 - [b = (2*a)] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][2] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)this)->_1_b);
		((P0 *)this)->_1_b = (2*((int)((P0 *)this)->_1_a));
#ifdef VAR_RANGES
		logval("loop:b", ((int)((P0 *)this)->_1_b));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 5: /* STATE 4 - loops.pml:8 - [b = (2*a)] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][4] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)this)->_1_b);
		((P0 *)this)->_1_b = (2*((int)((P0 *)this)->_1_a));
#ifdef VAR_RANGES
		logval("loop:b", ((int)((P0 *)this)->_1_b));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 6: /* STATE 8 - loops.pml:10 - [b = (b-1)] (0:0:2 - 3) */
		IfNotBlocked
		reached[0][8] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P0 *)this)->_1_b);
		((P0 *)this)->_1_b = (((int)((P0 *)this)->_1_b)-1);
#ifdef VAR_RANGES
		logval("loop:b", ((int)((P0 *)this)->_1_b));
#endif
		;
		/* dead 2: _1_b */  
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P0 *)this)->_1_b = 0;
		_m = 3; goto P999; /* 0 */
	case 7: /* STATE 12 - loops.pml:12 - [-end-] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][12] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

