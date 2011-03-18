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

		 /* PROC Client */
	case 3: /* STATE 1 - client_server.pml:52 - [((nr_pr<=(2+3)))] (0:0:0 - 1) */
		IfNotBlocked
		reached[2][1] = 1;
		if (!((((int)now._nr_pr)<=(2+3))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: /* STATE 2 - client_server.pml:53 - [server!request,me] (0:0:0 - 1) */
		IfNotBlocked
		reached[2][2] = 1;
		if (q_full(now.server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", now.server);
		sprintf(simtmp, "%d", 5); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P2 *)this)->_5_me); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server, 0, 5, ((P2 *)this)->_5_me, 2);
		if (q_zero(now.server)) { boq = now.server; };
		_m = 2; goto P999; /* 0 */
	case 5: /* STATE 3 - client_server.pml:55 - [me?hold,agent] (0:0:1 - 1) */
		reached[2][3] = 1;
		if (q_zero(((P2 *)this)->_5_me))
		{	if (boq != ((P2 *)this)->_5_me) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(((P2 *)this)->_5_me) == 0) continue;

		XX=1;
		if (3 != qrecv(((P2 *)this)->_5_me, 0, 0, 0)) continue;
		(trpt+1)->bup.oval = ((P2 *)this)->_5_agent;
		;
		((P2 *)this)->_5_agent = qrecv(((P2 *)this)->_5_me, XX-1, 1, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", ((P2 *)this)->_5_me);
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P2 *)this)->_5_agent); strcat(simvals, simtmp);		}
#endif
		if (q_zero(((P2 *)this)->_5_me))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 6: /* STATE 4 - client_server.pml:56 - [me?deny,agent] (0:0:1 - 1) */
		reached[2][4] = 1;
		if (q_zero(((P2 *)this)->_5_me))
		{	if (boq != ((P2 *)this)->_5_me) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(((P2 *)this)->_5_me) == 0) continue;

		XX=1;
		if (4 != qrecv(((P2 *)this)->_5_me, 0, 0, 0)) continue;
		(trpt+1)->bup.oval = ((P2 *)this)->_5_agent;
		;
		((P2 *)this)->_5_agent = qrecv(((P2 *)this)->_5_me, XX-1, 1, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", ((P2 *)this)->_5_me);
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P2 *)this)->_5_agent); strcat(simvals, simtmp);		}
#endif
		if (q_zero(((P2 *)this)->_5_me))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 7: /* STATE 6 - client_server.pml:58 - [me?grant,agent] (0:0:1 - 1) */
		reached[2][6] = 1;
		if (q_zero(((P2 *)this)->_5_me))
		{	if (boq != ((P2 *)this)->_5_me) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(((P2 *)this)->_5_me) == 0) continue;

		XX=1;
		if (2 != qrecv(((P2 *)this)->_5_me, 0, 0, 0)) continue;
		(trpt+1)->bup.oval = ((P2 *)this)->_5_agent;
		;
		((P2 *)this)->_5_agent = qrecv(((P2 *)this)->_5_me, XX-1, 1, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", ((P2 *)this)->_5_me);
		sprintf(simtmp, "%d", 2); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P2 *)this)->_5_agent); strcat(simvals, simtmp);		}
#endif
		if (q_zero(((P2 *)this)->_5_me))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 8: /* STATE 7 - client_server.pml:59 - [agent!return] (0:0:0 - 1) */
		IfNotBlocked
		reached[2][7] = 1;
		if (q_full(((P2 *)this)->_5_agent))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P2 *)this)->_5_agent);
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P2 *)this)->_5_agent, 0, 1, 0, 1);
		if (q_zero(((P2 *)this)->_5_agent)) { boq = ((P2 *)this)->_5_agent; };
		_m = 2; goto P999; /* 0 */
	case 9: /* STATE 15 - client_server.pml:63 - [-end-] (0:0:0 - 1) */
		IfNotBlocked
		reached[2][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Server */
	case 10: /* STATE 1 - client_server.pml:25 - [((i<2))] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][1] = 1;
		if (!((((int)((P1 *)this)->_4_i)<2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 11: /* STATE 2 - client_server.pml:25 - [pool!agents[i]] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][2] = 1;
		if (q_full(((P1 *)this)->_4_pool))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P1 *)this)->_4_pool);
		sprintf(simtmp, "%d", ((P1 *)this)->_4_agents[ Index(((int)((P1 *)this)->_4_i), 2) ]); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P1 *)this)->_4_pool, 0, ((P1 *)this)->_4_agents[ Index(((int)((P1 *)this)->_4_i), 2) ], 0, 1);
		if (q_zero(((P1 *)this)->_4_pool)) { boq = ((P1 *)this)->_4_pool; };
		_m = 2; goto P999; /* 0 */
	case 12: /* STATE 3 - client_server.pml:25 - [i = (i+1)] (0:0:1 - 1) */
		IfNotBlocked
		reached[1][3] = 1;
		(trpt+1)->bup.oval = ((int)((P1 *)this)->_4_i);
		((P1 *)this)->_4_i = (((int)((P1 *)this)->_4_i)+1);
#ifdef VAR_RANGES
		logval("Server:i", ((int)((P1 *)this)->_4_i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: /* STATE 9 - client_server.pml:30 - [server?request,client] (0:0:1 - 1) */
		reached[1][9] = 1;
		if (q_zero(now.server))
		{	if (boq != now.server) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(now.server) == 0) continue;

		XX=1;
		if (5 != qrecv(now.server, 0, 0, 0)) continue;
		(trpt+1)->bup.oval = ((P1 *)this)->_4_client;
		;
		((P1 *)this)->_4_client = qrecv(now.server, XX-1, 1, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server);
		sprintf(simtmp, "%d", 5); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)this)->_4_client); strcat(simvals, simtmp);		}
#endif
		if (q_zero(now.server))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 14: /* STATE 10 - client_server.pml:32 - [(empty(pool))] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][10] = 1;
		if (!((q_len(((P1 *)this)->_4_pool)==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 15: /* STATE 11 - client_server.pml:33 - [client!deny,0] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][11] = 1;
		if (q_full(((P1 *)this)->_4_client))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P1 *)this)->_4_client);
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 0); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P1 *)this)->_4_client, 0, 4, 0, 2);
		if (q_zero(((P1 *)this)->_4_client)) { boq = ((P1 *)this)->_4_client; };
		_m = 2; goto P999; /* 0 */
	case 16: /* STATE 12 - client_server.pml:34 - [(nempty(pool))] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][12] = 1;
		if (!((q_len(((P1 *)this)->_4_pool)>0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 17: /* STATE 13 - client_server.pml:35 - [pool?agent] (0:0:1 - 1) */
		reached[1][13] = 1;
		if (q_zero(((P1 *)this)->_4_pool))
		{	if (boq != ((P1 *)this)->_4_pool) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(((P1 *)this)->_4_pool) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((P1 *)this)->_4_agent;
		;
		((P1 *)this)->_4_agent = qrecv(((P1 *)this)->_4_pool, XX-1, 0, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", ((P1 *)this)->_4_pool);
		sprintf(simtmp, "%d", ((P1 *)this)->_4_agent); strcat(simvals, simtmp);		}
#endif
		if (q_zero(((P1 *)this)->_4_pool))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 18: /* STATE 14 - client_server.pml:36 - [(run Agent(agent))] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][14] = 1;
		if (!(addproc(0, ((P1 *)this)->_4_agent, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 19: /* STATE 17 - client_server.pml:38 - [server?return,agent] (0:0:1 - 1) */
		reached[1][17] = 1;
		if (q_zero(now.server))
		{	if (boq != now.server) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(now.server) == 0) continue;

		XX=1;
		if (1 != qrecv(now.server, 0, 0, 0)) continue;
		(trpt+1)->bup.oval = ((P1 *)this)->_4_agent;
		;
		((P1 *)this)->_4_agent = qrecv(now.server, XX-1, 1, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.server);
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)this)->_4_agent); strcat(simvals, simtmp);		}
#endif
		if (q_zero(now.server))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 20: /* STATE 18 - client_server.pml:39 - [pool!agent] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][18] = 1;
		if (q_full(((P1 *)this)->_4_pool))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P1 *)this)->_4_pool);
		sprintf(simtmp, "%d", ((P1 *)this)->_4_agent); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P1 *)this)->_4_pool, 0, ((P1 *)this)->_4_agent, 0, 1);
		if (q_zero(((P1 *)this)->_4_pool)) { boq = ((P1 *)this)->_4_pool; };
		_m = 2; goto P999; /* 0 */
	case 21: /* STATE 22 - client_server.pml:41 - [-end-] (0:0:0 - 1) */
		IfNotBlocked
		reached[1][22] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Agent */
	case 22: /* STATE 1 - client_server.pml:10 - [talk!hold,listen] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][1] = 1;
		if (q_full(((P0 *)this)->talk))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P0 *)this)->talk);
		sprintf(simtmp, "%d", 3); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->listen); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P0 *)this)->talk, 0, 3, ((P0 *)this)->listen, 2);
		if (q_zero(((P0 *)this)->talk)) { boq = ((P0 *)this)->talk; };
		_m = 2; goto P999; /* 0 */
	case 23: /* STATE 2 - client_server.pml:11 - [talk!deny,listen] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][2] = 1;
		if (q_full(((P0 *)this)->talk))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P0 *)this)->talk);
		sprintf(simtmp, "%d", 4); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->listen); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P0 *)this)->talk, 0, 4, ((P0 *)this)->listen, 2);
		if (q_zero(((P0 *)this)->talk)) { boq = ((P0 *)this)->talk; };
		_m = 2; goto P999; /* 0 */
	case 24: /* STATE 4 - client_server.pml:12 - [talk!grant,listen] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][4] = 1;
		if (q_full(((P0 *)this)->talk))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", ((P0 *)this)->talk);
		sprintf(simtmp, "%d", 2); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->listen); strcat(simvals, simtmp);		}
#endif
		
		qsend(((P0 *)this)->talk, 0, 2, ((P0 *)this)->listen, 2);
		if (q_zero(((P0 *)this)->talk)) { boq = ((P0 *)this)->talk; };
		_m = 2; goto P999; /* 0 */
	case 25: /* STATE 5 - client_server.pml:13 - [listen?return] (0:0:0 - 1) */
		reached[0][5] = 1;
		if (q_zero(((P0 *)this)->listen))
		{	if (boq != ((P0 *)this)->listen) continue;
		} else
		{	if (boq != -1) continue;
		}
		if (q_len(((P0 *)this)->listen) == 0) continue;

		XX=1;
		if (1 != qrecv(((P0 *)this)->listen, 0, 0, 0)) continue;
		if (q_flds[((Q0 *)qptr(((P0 *)this)->listen-1))->_t] != 1)
			Uerror("wrong nr of msg fields in rcv");
		;
		qrecv(((P0 *)this)->listen, XX-1, 0, 1);
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", ((P0 *)this)->listen);
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		}
#endif
		if (q_zero(((P0 *)this)->listen))
		{	boq = -1;
#ifndef NOFAIR
			if (fairness
			&& !(trpt->o_pm&32)
			&& (now._a_t&2)
			&&  now._cnt[now._a_t&1] == II+2)
			{	now._cnt[now._a_t&1] -= 1;
#ifdef VERI
				if (II == 1)
					now._cnt[now._a_t&1] = 1;
#endif
#ifdef DEBUG
			printf("%3d: proc %d fairness ", depth, II);
			printf("Rule 2: --cnt to %d (%d)\n",
				now._cnt[now._a_t&1], now._a_t);
#endif
				trpt->o_pm |= (32|64);
			}
#endif

		};
		_m = 4; goto P999; /* 0 */
	case 26: /* STATE 10 - client_server.pml:15 - [server!return,listen] (0:0:0 - 5) */
		IfNotBlocked
		reached[0][10] = 1;
		if (q_full(now.server))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d!", now.server);
		sprintf(simtmp, "%d", 1); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P0 *)this)->listen); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.server, 0, 1, ((P0 *)this)->listen, 2);
		if (q_zero(now.server)) { boq = now.server; };
		_m = 2; goto P999; /* 0 */
	case 27: /* STATE 11 - client_server.pml:16 - [-end-] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][11] = 1;
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

