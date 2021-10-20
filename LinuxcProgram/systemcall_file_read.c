#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
int main ()
{
  char buffer[128];
  int nread;

  nread=read(0,buffer,128);

  printf("please input somedata");

  if (nread  == -1 )   
    write(2,"A read error has occured \n",16 );
  if ((write(1,buffer,nread)) != nread)
    write(2,"some fault has occurd on write",80);
  
exit(0);
}