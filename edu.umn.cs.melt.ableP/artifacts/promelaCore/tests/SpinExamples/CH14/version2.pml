mtype = { offhook, digits, onhook };
mtype = { iam, acm, anm, rel, rlc }; /* ss7 messages */

chan tpc = [0] of { mtype };
chan rms = [1] of { mtype }; /* channel to remote switch */

active proctype subscriber()
{
Idle:	tpc!offhook;

Busy:	if
	:: tpc!digits -> goto Busy
	:: tpc!onhook -> goto Idle
	fi
}

active proctype switch_ss7()
{
Idle:
	if
	:: tpc?offhook ->
		printf("MSC: dialtone\n");
		goto Dial
	fi;
Dial:
	if
	:: tpc?digits ->
		printf("MSC: notone\n");
		rms!iam;
		goto Wait
	:: tpc?onhook ->
		printf("MSC: notone\n");
		goto Idle
	fi;
Wait:
	if
	:: tpc?acm ->
		printf("MSC: ringtone\n");
		goto Wait
	:: tpc?anm ->
		printf("MSC: notone\n");
		goto Connect
	:: tpc?rel ->
		rms!rlc; printf("MSC: busytone\n");
		goto Busy
	:: tpc?onhook ->
		rms!rel;
		goto Zombie1
	fi;
Connect:
	if
	:: tpc?rel ->
		rms!rlc;
		printf("MSC: busytone\n");
		goto Busy
	:: tpc?onhook ->
		rms!rel;
		goto Zombie1
	fi;
Busy:		/* offhook, waiting for onhook */
	if
	:: tpc?onhook ->
		printf("MSC: notone\n");
		goto Idle
	fi;

Zombie1:	/* onhook, waiting for rlc */
	if
	:: tpc?rel ->
		rms!rlc;
		goto Zombie1
	:: tpc?rlc ->
		goto Idle
	:: tpc?offhook ->
		goto Zombie2
	fi;
Zombie2:	/* offhook, waiting for rlc */
	if
	:: tpc?rel ->
		rms!rlc;
		goto Zombie2
	:: tpc?rlc ->
		goto Busy
	:: tpc?onhook ->
		goto Zombie1
	fi
}

active proctype remote_ss7()
{
Idle:
	if
	:: rms?iam -> goto Dialing
	fi;
Dialing:
	if
	:: tpc!acm -> goto Ringing
	:: tpc!rel -> goto Hangup
	:: rms?rel -> goto Busy
	fi;
Ringing:
	if
	:: tpc!anm -> goto Talking
	:: tpc!rel -> goto Hangup
	:: rms?rel -> goto Busy
	fi;
Talking:
	if
	:: tpc!rel -> goto Hangup
	:: rms?rel -> goto Busy
	fi;
Hangup:
	if
	:: rms?rlc -> goto Idle
	:: rms?rel -> goto Race
	fi;
Busy:
	if
	:: rms?rlc -> goto Idle
	fi;

Race:	if
	:: tpc!rlc -> goto Busy
	fi
}
