#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>



void printdir(char *dir ,int depth)
{
  DIR *dp;
  struct dirent *entry;
  struct stat statbuff;

  if(( dp = opendir(dir)) == NULL) {
    fprintf(stderr,"cant open dir : %s\n", dir);
    return;
  }

  chdir(dir);
  while((entry = readdir(dp)) != NULL) {
    lstat(entry->d_name, &statbuff);
    if(S_ISDIR(statbuff.st_mode)) {
      /*found a directory  */
      if (strcmp("..",entry->d_name) == 0 || strcmp(".",entry->d_name) == 0) 
      continue;
      printf ("%*s%s\n",depth,"",entry->d_name);
      printdir(entry->d_name, depth+4);
    }

    else printf("%*s%s\n",depth,"",entry->d_name);

  }
  chdir("..");
  closedir(dp);
  
}

int main()
{
  printf("directory scan of /home:\n");
  printdir("/home",0);
  printf("done.\n");
  exit(0);

}