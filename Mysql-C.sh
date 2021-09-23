#! /bin/bash
##mysql管理命令
myisamchk -e -r *.MYI
mysql -u root --password=secretpassword foo < sqlcommands.sql
mysql > help\ edit\ exit\ go\ source <filename >\  status\ system <command>\ tee <filename>\ use <database>
mysqladmin create <database_name>\ drop <database_name>\ password <new_password>\ ping\ reload\ status\ shutdown\ variables\ version
mysqlbug 
mysqldump  --add-drop-table\ -e\ -t\ -d   ## 
mysqlimport 
mysqlshow 
###用户创建及权限
grant < privileges > on < project > to < user > [ identified by user-password ] [ with grant option ]
        ##alter create delete drop  index insert lock tables select update all
                          ### databasename.tablename *.*
                                        ### root@'%'
revoke  < a_privileges > on < an_object > from < a_usser >#剥夺用户权限,并删除该用户
mysql> use mysql
mysql> delete from user where user = "rick"
mysql> flush privileges;

##密码
mysql> use mysql
mysql> select host,user,password from user;

###数据类型

