active proctype main()
{
 int i, j, k ; 
 printf("hello world\n") ;
 i = 0 ;
 j = 2 ;
 do 
 :: i < 3 ;
    printf("i = %d\n", i);
    i = i + 1;
    j = j * 2;
 :: else ;
    goto stop;
 od;

 stop:  printf("The value of for j is: %d\n", j);
}

