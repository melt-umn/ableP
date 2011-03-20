/* The hand-coded translation of AltSwitch.pml to plain pml */

mtype = {Unknown, Above, Below } ;   /* altitude status */
mtype = {Good, Bad} ;                /* quality of instrument readings */

active proctype determineStatus ()
{
 int altitude, threshold, hyst ;
 mtype altQuality, altStatus ;
 
 printf("determine status ... \n") ;

 check:
 altStatus = Above ;   /* to be replaced by a table */

 if :: altStatus == Above -> goto above; 
    :: altStatus == Below || altStatus == Unknown -> goto trouble;
 fi ;

 above:
   printm (altStatus) ;
   /* delay */
   goto check ;

 trouble:
   printm (altStatus) ;
   /* send msg to monitor */
   /* delay */
   goto check ;

}

active proctype monitorStatus () 
{
 printf("monitor status ... \n") ;
}