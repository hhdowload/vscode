#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> 

int main(int argc, char *argv[])
{
    int opt;
    while((opt = getopt(argc, argv, ":if:lr")) !== -1 ) {
        switch (opt)
        {
        case 'i':
        case 'l':
        case 'r':
            printf("option: %c\n", opt);
            break;
        case 'f':
            printf("filename is %s\n", optarg);
            break;
        case ':':
            printf("option neeed avalue\n");
            break;
        case '?':
            printf("got a unkonw option\n");
        }
    }
    for(; optind < argc; optind++ )
    {
        printf("argument is %s\n", argv[optind]);
    }

    exit(0);
}