#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define ONE_K (1024)

int main()
{
    char *some_memory;
    int size_to_allocate = ONE_K;
    int ks_obtained = 0;
    int obtain_meg = 0;
    while(1){
      for(ks_obtained = 0 ; ks_obtained < 1024; ks_obtained++ ) {
         some_memory = (char *)malloc(size_to_allocate);
         if(some_memory == NULL) exit(EXIT_FAILURE);
         sprintf(some_memory, "hellow word");
        }
      obtain_meg++;
      printf("%s now,youhave %d Mbytes\n", some_memory, obtain_meg);
    }
    exit(EXIT_SUCCESS);

}