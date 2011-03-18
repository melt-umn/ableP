typedef elem_a
{
  int col[4]
};

elem_a a[4];

active proctype main()
{
   printf("hello ... a for loop over a range...\\n");
   int i;
   i = 1;
   do
   ::
      (i<=a);
      printf("i=%d\n",i);
      i = (i+1);

   ::
      else;
      goto b0;

   od;
b0: skip;

   printf("End...\n") ;
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
