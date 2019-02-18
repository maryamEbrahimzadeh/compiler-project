#include <stdio.h>
#include <stdlib.h>
#include <string.h>



void main(){

int tmp = 1;
int b = 5;
L2: if( b > 0 )  goto L;
goto L3 ;
L: tmp =  tmp * b ;
b =  b - 1 ;
goto L2 ;
L3:
printf("%d",tmp);

}
