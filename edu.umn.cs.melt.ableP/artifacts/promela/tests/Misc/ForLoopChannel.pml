
typedef utype { bit b; byte c; };

active proctype main()
{

chan c = [10] of { utype };
 utype x;
 for (x in c) {
  printf("b=%d c=%d\n", x.b, x.c)
 }
}
