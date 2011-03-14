	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC Client */
;
		;
		
	case 4: /* STATE 2 */
		;
		_m = unsend(now.server);
		;
		goto R999;

	case 5: /* STATE 3 */
		;
		XX = 1;
		unrecv(((P2 *)this)->_5_me, XX-1, 0, 3, 1);
		unrecv(((P2 *)this)->_5_me, XX-1, 1, ((P2 *)this)->_5_agent, 0);
		((P2 *)this)->_5_agent = trpt->bup.oval;
		;
		;
		goto R999;

	case 6: /* STATE 4 */
		;
		XX = 1;
		unrecv(((P2 *)this)->_5_me, XX-1, 0, 4, 1);
		unrecv(((P2 *)this)->_5_me, XX-1, 1, ((P2 *)this)->_5_agent, 0);
		((P2 *)this)->_5_agent = trpt->bup.oval;
		;
		;
		goto R999;

	case 7: /* STATE 6 */
		;
		XX = 1;
		unrecv(((P2 *)this)->_5_me, XX-1, 0, 2, 1);
		unrecv(((P2 *)this)->_5_me, XX-1, 1, ((P2 *)this)->_5_agent, 0);
		((P2 *)this)->_5_agent = trpt->bup.oval;
		;
		;
		goto R999;

	case 8: /* STATE 7 */
		;
		_m = unsend(((P2 *)this)->_5_agent);
		;
		goto R999;

	case 9: /* STATE 15 */
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Server */
;
		;
		
	case 11: /* STATE 2 */
		;
		_m = unsend(((P1 *)this)->_4_pool);
		;
		goto R999;

	case 12: /* STATE 3 */
		;
		((P1 *)this)->_4_i = trpt->bup.oval;
		;
		goto R999;

	case 13: /* STATE 9 */
		;
		XX = 1;
		unrecv(now.server, XX-1, 0, 5, 1);
		unrecv(now.server, XX-1, 1, ((P1 *)this)->_4_client, 0);
		((P1 *)this)->_4_client = trpt->bup.oval;
		;
		;
		goto R999;
;
		;
		
	case 15: /* STATE 11 */
		;
		_m = unsend(((P1 *)this)->_4_client);
		;
		goto R999;
;
		;
		
	case 17: /* STATE 13 */
		;
		XX = 1;
		unrecv(((P1 *)this)->_4_pool, XX-1, 0, ((P1 *)this)->_4_agent, 1);
		((P1 *)this)->_4_agent = trpt->bup.oval;
		;
		;
		goto R999;

	case 18: /* STATE 14 */
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 19: /* STATE 17 */
		;
		XX = 1;
		unrecv(now.server, XX-1, 0, 1, 1);
		unrecv(now.server, XX-1, 1, ((P1 *)this)->_4_agent, 0);
		((P1 *)this)->_4_agent = trpt->bup.oval;
		;
		;
		goto R999;

	case 20: /* STATE 18 */
		;
		_m = unsend(((P1 *)this)->_4_pool);
		;
		goto R999;

	case 21: /* STATE 22 */
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Agent */

	case 22: /* STATE 1 */
		;
		_m = unsend(((P0 *)this)->talk);
		;
		goto R999;

	case 23: /* STATE 2 */
		;
		_m = unsend(((P0 *)this)->talk);
		;
		goto R999;

	case 24: /* STATE 4 */
		;
		_m = unsend(((P0 *)this)->talk);
		;
		goto R999;

	case 25: /* STATE 5 */
		;
		XX = 1;
		unrecv(((P0 *)this)->listen, XX-1, 0, 1, 1);
		;
		;
		goto R999;

	case 26: /* STATE 10 */
		;
		_m = unsend(now.server);
		;
		goto R999;

	case 27: /* STATE 11 */
		;
		p_restor(II);
		;
		;
		goto R999;
	}

