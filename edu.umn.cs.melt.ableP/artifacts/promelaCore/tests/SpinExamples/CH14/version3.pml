mtype = { offhook, digits, onhook };
mtype = { iam, acm, anm, rel, rlc };
mtype = { idle, busy };	/* session states */

chan tpc  = [0] of { mtype };
chan sess = [0] of { mtype };
chan rms  = [1] of { mtype };

mtype s_state = idle;

active proctype subscriber()
{
Idle:	tpc!offhook;

Busy:	if
	:: tpc!digits -> goto Busy
	:: tpc!onhook -> goto Idle
	fi
}

proctype session_ss7(chan inp; chan out)
{
Idle:
	if
	:: inp?offhook ->
		printf("MSC: dialtone\n");
		goto Dial
	fi;
Dial:
	if
	:: inp?digits ->
		printf("MSC: notone\n");
		out!iam;
		goto Wait
	:: inp?onhook ->
		printf("MSC: notone\n");
		goto Idle
	fi;
Wait:
	if
	:: inp?acm ->
		printf("MSC: ringtone\n");
		goto Wait
	:: inp?anm ->
		printf("MSC: notone\n");
		goto Connect
	:: inp?rel ->
		out!rlc;
		printf("MSC: busytone\n");
		goto Busy
	:: inp?onhook ->
		out!rel;
		goto Zombie1
	fi;
Connect:
	if
	:: inp?rel ->
		out!rlc;
		printf("MSC: busytone\n");
		goto Busy
	:: inp?onhook ->
		out!rel;
		goto Zombie1
	fi;
Busy:		/* offhook, waiting for onhook */
	if
	:: inp?onhook ->
		printf("MSC: notone\n");
		goto Idle
	fi;
Zombie1:	/* onhook, waiting for rlc */
	if
	:: inp?rel ->
		out!rlc;
		goto Zombie1
	:: inp?rlc ->
		goto Idle
	:: inp?offhook ->
		goto Zombie2
	fi;
Zombie2:	/* offhook, waiting for rlc */
	if
	:: inp?rel ->
		out!rlc;
		goto Zombie2
	:: inp?rlc ->
		goto Busy
	:: inp?onhook ->
		goto Zombie1
	fi
}

active proctype switch()
{	mtype x;

	atomic
	{	run session_ss7(sess, rms);
		run remote_ss7(rms, sess)
	};
end:	do
	:: tpc?x ->
		if
		:: x == offhook ->
			assert(s_state == idle);
			s_state = busy
		:: x == onhook ->
			assert(s_state == busy);
			s_state = idle
		:: else
		fi;
		sess!x
	od
}

proctype remote_ss7(chan inp; chan out)
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
