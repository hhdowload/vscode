#include <stdio.h>
#include <stdlib.h>
#include "mysql.h"

int main(int argc, char *argv[]) {
    MYSQL my_connection;

    mysql_init(&my_connection);
    if (mysql_real_connect(&my_connection, "localhost", "root", "passwd", "mysql", 0, NULL, 0)) {
        printf("connect sucessed\n");
        mysql_close(&my_connection);
    } else {
        fprintf(stderr,"conection failed\n");
        if (mysql_errno(&my_connection)) {
            fprintf(stderr, "mysql connect failed %d: %s\n", mysql_errno(&my_connection), mysql_error(&my_connection));
        }
    }

    return EXIT_SUCESS;
}