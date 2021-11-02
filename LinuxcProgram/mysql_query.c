#include <stdlib.h>
#include <stdio.h>
#include "mysql.h"

int main() {
    MYSQL my_connection;
    int res;


    mysql_init(&my_connection);
    
    if (mysql_real_connect(&my_connection, "localhsot", "root", "admin_1234", "linuxc", 0, NULL, 0)) {
        printf("mysql connect");
        res = mysql_query(&my_connection, "insert into children(fname, age) value('liu', 12)");
        if (!res) {
            printf("insert into %lu rows\n", (unsigned long)mysql_affected_rows(&my_connection));
        }

    } else {
        fprintf(stderr, "connect failed %d: %s\n", mysql_errno(&my_connection), mysql_error(&my_connection));
    }
    
}