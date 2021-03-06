/* Fig 13.4 and 13.5 */

mtype = { offhook, digits, onhook };

chan tpc = [0] of { mtype };

active proctype subscriber()
{
Idle:	tpc!offhook;

Busy:	if
	:: tpc!digits -> goto Busy
	:: tpc!onhook -> goto Idle
	fi
}

active proctype switch()	/* outgoing calls only */
{
Idle:
	if
	:: tpc?offhook -> printf("MSC: dialtone\n"); goto Dial
	fi;
Dial:
	if
	:: tpc?digits -> printf("MSC: notone\n"); goto Wait
	:: tpc?onhook -> printf("MSC: notone\n"); goto Idle
	fi;
Wait:
	if
	:: printf("MSC: ringtone\n") -> goto Connect;
	:: printf("MSC: busytone\n") -> goto Busy
	fi;
Connect:
	if
	:: printf("MSC: busytone\n") -> goto Busy
	:: printf("MSC: notone\n")   -> goto Busy	/* no remote hang up */
	fi;
Busy:
	tpc?onhook -> printf("MSC: notone\n"); goto Idle
}
