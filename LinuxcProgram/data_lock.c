#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>



const char *lock_file = "/tmp/Lock.te";

int main()
{
    int try = 10;
    int file_ds;
    while(try--)
    {
        file_ds = open(lock_file, O_RDWR | O_CREAT | O_EXCL, 0444);
        if(file_ds == -1)
        {
            printf("%d i have a locke file fail\n", getpid());
            sleep(3);

        }
        else
        {
            printf("%d i have open success", getpid());
            (void)close(file_ds);
             (void)unlink(lock_file);   
            sleep(2);
        }


    }
    exit(EXIT_SUCCESS);

}