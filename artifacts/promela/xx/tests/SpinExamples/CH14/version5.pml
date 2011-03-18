#define NS	2	/* nr of sessions in 3way call */

mtype = { offhook, digits, flash, onhook };
mtype = { iam, acm, anm, rel, rlc };
mtype = { idle, busy, setup, threeway };

chan tpc      = [1] of { mtype };
chan rms[NS]  = [1] of { mtype };
chan sess[NS] = [0] of { mtype };

mtype s_state = idle;

active proctype subscriber()
{
Idle:	tpc!offhook;

Busy:	if
	:: tpc!digits -> goto Busy
	:: tpc!flash -> goto Busy
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
	:: inp?digits ->
		goto Wait
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
	:: inp?digits ->
		goto Connect
	fi;
Busy:		/* offhook, waiting for onhook */
	if
	:: inp?onhook ->
		printf("MSC: notone\n");
		goto Idle
	:: inp?digits ->
		goto Busy
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
	:: inp?acm ->
		goto Zombie1
	:: inp?anm ->
		goto Zombie1
	fi;
Zombie2:	/* offhook, waiting for rlc */
	if
	:: inp?rlc ->
		goto Busy
	:: inp?onhook ->
		goto Zombie1
	:: inp?digits ->
		goto Zombie2
	:: inp?rel ->
		out!rlc;
		goto Zombie2
	fi
}

active proctype switch()
{	mtype x;

	atomic
	{	run session_ss7(sess[0], rms[0]);
		run session_ss7(sess[1], rms[1]);
		run remote_ss7(rms[0], sess[0]);
		run remote_ss7(rms[1], sess[1])
	};
end:	do
	:: tpc?x ->
		if
		:: x == offhook ->
			assert(s_state == idle);
			s_state = busy;
			sess[0]!x
		:: x == onhook ->
			assert(s_state != idle);
			if
			:: s_state == busy ->
				sess[0]!x
			:: else ->
				sess[0]!x; sess[1]!x
			fi;
			s_state = idle
		:: x == flash ->
			assert(s_state != idle);
			if
			:: s_state == busy ->
				sess[1]!offhook;
				s_state = setup
			:: s_state == setup ->
				s_state = threeway
			:: s_state == threeway ->
				sess[1]!onhook;
				s_state = busy
			fi
		:: else ->
			if
			:: s_state == idle
				/* ignored */
			:: s_state == busy ->
				sess[0]!x
			:: else ->
				sess[1]!x
			fi
		fi
	od
}

proctype remote_ss7(chan inp; chan out)
{
Idle:
	if
	:: inp?iam -> goto Dialing
	fi;
Dialing:
	if
	:: out!acm -> goto Ringing
	:: out!rel -> goto Hangup
	:: inp?rel -> goto Busy
	fi;
Ringing:
	if
	:: out!anm -> goto Talking
	:: out!rel -> goto Hangup
	:: inp?rel -> goto Busy
	fi;
Talking:
	if
	:: out!rel -> goto Hangup
	:: inp?rel -> goto Busy
	fi;
Hangup:
	if
	:: inp?rlc -> goto Idle
	:: inp?rel -> goto Race
	fi;
Busy:
	if
	:: inp?rlc -> goto Idle
	fi;

Race:	if
	:: out!rlc -> goto Busy
	:: inp?rlc ->
		out!rlc -> goto Idle
	fi
}

#define Final \
	subscriber@Idle && switch@end \
	&& remote_ss7[4]@Idle && remote_ss7[5]@Idle \
	&& session_ss7[2]@Idle && session_ss7[3]@Idle

#define Event(x,y) \
	do \
	:: !tpc??[y] &&  tpc?[x] -> break \
	:: !tpc??[y] && !tpc?[x] \
	od

never {
	/* sample of a 3way call: */
	Event(offhook, onhook);
	Event(digits,  onhook);
	Event(flash,   onhook);
	Event(digits,  onhook);
	Event(flash,   onhook);
	Event(digits,  onhook);
	Event(flash,   onhook);
	Event(onhook,  offhook);
	do
	:: Final -> break
	:: else
	od
}
