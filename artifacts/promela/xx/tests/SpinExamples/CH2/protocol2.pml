/* The protocol from Figure 2.6 as it was intended to appear */

mtype = { ini, ack, dreq, data, shutup, quiet, dead };

chan M = [1] of { mtype };
chan W = [1] of { mtype };

active proctype Mproc()
{
    W!ini;                 /* connection      */
    M?ack;                 /* handshake       */

    timeout ->             /* wait            */
    if                     /* two options:    */
    :: W!shutup            /* start shutdown  */
    :: W!dreq;             /* or request data */
        do
        :: M?data ->W!data          /* send data       */
        :: M?data ->W!shutup;       /* or shutdown     */
            break
        od
    fi;

    M?shutup;              /* shutdown handshake */
    W!quiet;
    M?dead
}

active proctype Wproc()
{
    W?ini;                 /* wait for ini    */
    M!ack;                 /* acknowledge     */

    do                     /* 3 options:      */
    :: W?dreq ->           /* data requested  */
        M!data             /* send data       */
    :: W?data ->           /* receive data    */
        skip               /* no response     */
    :: W?shutup ->
        M!shutup;          /* start shutdown  */
        break
    od;

    W?quiet;
    M!dead
}
