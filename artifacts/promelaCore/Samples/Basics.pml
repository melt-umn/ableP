proctype hello()
{ printf("Hello from a process\n"); }

active proctype main()
{
 run hello();
 printf("hello world\n") ;
 int i ;
 int j ; int k ;
 i = 4 ;

 printf("i = %d, j = %d \n", i, j) ;
}

