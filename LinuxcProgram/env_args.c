#include <stdlib.h>
#include <stdio.h>


int main(int argc, char *argv[])
{
    int arg;
    for ( arg = 0; arg <= argc; arg++ )
    {
        if(argv[arg][0] == '-')
        {
            printf("%s is a option", argv[arg]+1);
        }
        else
            printf("%s is a argument", argv[arg]);
    }
    
    exit(0);
}