#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdio.h>

int main ()
{
  char *c;
  int in, out;

  in = open("file.in", O_RDONLY);
  out = open("file.out", O_WRONLY|O_CREAT, S_IRUSR);


  printf("please input somedata");
  
  nread = read(in, c ,sizeof(c));
  if (nread  == -1 )   
    write(2,"A read error has occured \n",12 );
  
  if ((write(out, c, nread)) != nread)
    write(2,"some fault has occurd on write",80);
  
exit(0);
}