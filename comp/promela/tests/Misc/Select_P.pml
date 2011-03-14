active proctype main()
{
   int i;
   i = 4 ;
   do
   :: goto b0;
   :: ((i<10));
      i = (i+1);
   od;


/* Maybe a more direct translation?
   if 
   :: i=1;
   :: i=2;
   :: i=3;
   fi;
*/

   printf("The selection is: %d\n", i);
}
