typedef elem_a
{
  int col[4]
};

typedef timer
{
  short val = 0 ;
};

elem_a a[4];

active proctype main()

{
 printf("hello ... a for loop over a range...\n") ;

 int i, j ;
 timer t ;
 t.val = 0;
 a[1].col[1] = 9 ;
 j = a[i].col[1] ;
 for (i : 1 .. 9) {
  printf("i=%d\n", i)
 }

}


init {
 printf("hello 2 ... a for loop over a range...\n") ;
}

init {
 printf("hello 3 ... a for loop over a range...\n") ;
}
