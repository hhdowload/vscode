#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc,char *argv[]) {

    char *var, *value;
    if(argc == 1 || argc > 3)
    {
        fprintf(stderr,"erro arguments,usage:environ var [value]\n");
        exit(1);
    }

    var = argv[1];
    value = getenv(var);
    if(value)
    {
        printf("variable %s has value %s \n", var, value);
    }
    else
        printf("variable %s has no value\n", var);
    
    if(argc == 3)
    {
        char *string;
        value = argv[2];
        string = malloc(strlen(var)+strlen(value)+2);
        if(!string)
        {
            fprintf(stderr,"out of memorry\n");
            exit(1);
        }

        strcpy(string, var);
        strcat(string,"=");
        strcat(string, value);
        printf("calling putenv with string:\n",string);
        if(putenv(string) != 0)
        {
            fprintf(stderr,"putenv failed\n");
            free(string);
            exit(1);
        }
    }

    value = getenv(var);
    if(value)
    {
        printf("new value of %s is %s\n", var, value);
    }
    else
    {
        printf("new value  %s set null??\n", var);
    }

    exit(0);
}