// Promela code generated by ableP.

mtype = { Unknown, Above, Below } mtype = { Good, Bad } 
active proctype determineStatus () 
{
  int altitude;
 int threshold;
 int hyst;
 mtype altQuality;
 mtype altStatus;
 printf ("determine status ... \n" );

check:  altStatus = Above ;

if
 :: (altStatus == Above) ;

    goto above ;
 :: ((altStatus == Below) || (altStatus == Unknown)) ;

    goto trouble ;

 fi ;

above: printm(altStatus) ;

 goto check ;

trouble: printm(altStatus) ;

 goto check ;

}

active proctype monitorStatus () 
{
  printf ("monitor status ... \n" );

}
//end
