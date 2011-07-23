#include <stdio.h>
#define HOW_MANY_TIMES_TO_SAY_HELLO 3
void say_three_hi();

int main(int argc, const *argvc[])
{	
    say_three_hi();
	return 0;
}


void say_three_hi()
{ 
     int i;
     for(i=0; i < HOW_MANY_TIMES_TO_SAY_HELLO; i++)
     {
         printf("hello,World!\n");
     }
}
   
