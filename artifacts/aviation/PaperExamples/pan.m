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

		 /* PROC monitorStatus */
	case 3: /* STATE 1 - AltSwitch.pml:34 - [printf('monitor status ... \\n')] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][1] = 1;
		Printf("monitor status ... \n");
		_m = 3; goto P999; /* 0 */
	case 4: /* STATE 2 - AltSwitch.pml:35 - [-end-] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][2] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC determineStatus */
	case 5: /* STATE 1 - AltSwitch.pml:10 - [printf('determine status ... \\n')] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][1] = 1;
		Printf("determine status ... \n");
		_m = 3; goto P999; /* 0 */
	case 6: /* STATE 2 - AltSwitch.pml:13 - [altStatus = Above] (0:0:1 - 5) */
		IfNotBlocked
		reached[0][2] = 1;
		(trpt+1)->bup.oval = ((P0 *)this)->_3_altStatus;
		((P0 *)this)->_3_altStatus = 2;
#ifdef VAR_RANGES
		logval("determineStatus:altStatus", ((P0 *)this)->_3_altStatus);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: /* STATE 3 - AltSwitch.pml:15 - [((altStatus==Above))] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][3] = 1;
		if (!((((P0 *)this)->_3_altStatus==2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 8: /* STATE 5 - AltSwitch.pml:16 - [(((altStatus==Below)||(altStatus==Unknown)))] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][5] = 1;
		if (!(((((P0 *)this)->_3_altStatus==1)||(((P0 *)this)->_3_altStatus==3))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 9: /* STATE 9 - AltSwitch.pml:20 - [printm(altStatus)] (0:0:0 - 3) */
		IfNotBlocked
		reached[0][9] = 1;
		printm(((P0 *)this)->_3_altStatus);
		_m = 3; goto P999; /* 0 */
	case 10: /* STATE 11 - AltSwitch.pml:25 - [printm(altStatus)] (0:0:0 - 2) */
		IfNotBlocked
		reached[0][11] = 1;
		printm(((P0 *)this)->_3_altStatus);
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

