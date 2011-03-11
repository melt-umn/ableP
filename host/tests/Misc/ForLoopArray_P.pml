active proctype main()
{
   int a[10];
   int i ;
   i = 0;
   do
   ::
      ((i<=9));
      printf("a[%d] = %d\n",i,a[i]);
      i = (i+1);

   ::
      else;
      goto b0;

   od;
b0: printf("") ;
}


/* Output from  spin -I ForLoopArray.pml
proctype main()
{
   i = 0;
   do
   ::
      ((i<=9));
      printf('a[%d] = %d\\n',i,a[i]);
      i = (i+1);

   ::
      else;
      goto :b0;

   od;
:b0:
}
*/
