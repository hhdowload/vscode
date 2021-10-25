#include <syslog.h>
#include <stdio.h>
#include <stdlib.h>




int main()
{
    FILE *f;
    f = fopen("noot here", "r");
    if(!f) 
        syslog(LOG_ERR|LOG_USER, "OOPS - %m\n");
    syslog(LOG_ERR|LOG_USER, "ITS TIME TO SAY goodby");
    exit(0);
}