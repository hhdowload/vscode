#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>



void printdir (char *dir ,int depth)
{
  DIR *dp;
  struct dirent *entry;
  struct stat statbuff;

  if (( dp =opendir(dir)) == NULL) {
    fprintf (stderr,"cant open dir : %s\n", dir);
    return;
  }

  chdir(dir);
  while ((entry = readdir(dp)) != NULL) {
    lstat(entry->d_name, &statbuff)；
    if (S_ISDIR(statbuff.st_mode)) {
      /*found a directory  */
      if (strcmp("..",entry->d_name) == 0 || strcmp(".",entry->d_name) == 0) 
      continue;
      printf ("%*s%s\n",depth,"",entry->d_name);
      printdir(entry->d_name, depth+4)
    }

    else printf("%*s%s\n",depth,"",entry->d_name);

  }
  chdir("..");
  closedir(dp);
  
}

int main()
{
  printf("directory scan of /home:\n");
  printdir("/homr",0);
  printf("done.\n");
  exit(0);

}








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