active proctype main()
{
   printf("hello ... a for loop over a range...\\n");
   int i;
   i = 1;
   do
   ::
      (i<=9);
      printf("i=%d\n",i);
      i = (i+1);

   ::
      else;
      goto b0;

   od;
b0: printf("") ;
}

/* Broken output from spin -I ForLoopRange.pml
proctype main()
{
   printf('hello ... a for loop over a range...\\n');
   i = 1;
   do
   ::
      ((i<=9));
      printf('i=%d\\n',i);
      i = (i+1);

   ::
      else;
      goto :b0;

   od;
:b0:
}
*/
