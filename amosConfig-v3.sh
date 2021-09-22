#!/bin/bash
#Date 20200712
#Author Y
#增加回车默认变量配置
#使用将jar包配置文件方式更换为跟新而非解压打包 2021.08.20；
#使用自定义路径
#增加ip正则限制、增加yml文件配置 20200824
#增加win2linux转换
clear
alias rm="rm" >/dev/null 2>&1
trap "alias rm='rm -i' && echo 'rm归位' && exit 1 " SIGINT  #2
###颜色定义###
Red="\e[1;91m"      ##### Colors Used #####
Green="\e[32m"
Yellow="\e[0;93m"
Blue="\e[1;94m"
White="\e[0m"
###############
Version="V3.0"
Date="2021-09-18"
####版本号查询###
 if [[ $1 == "-v" ]]; then
 	echo -e "${Green}"
 	echo "版本号:${Version}"
 	echo "版本时间:${Date}"
 	echo -e "${White}"
 	exit 0
 fi

 if whereis java && whereis jar >/dev/null 2<&1;then
	echo " "
 else
	echo "\e[31m请检查java、jar环境\e[0m"
	exit 0
 fi
######################################README##################################################
echo -e "\e[32m"
# echo -e "\033[44;37;5m"
# printf "%50s\n"  说明								     #
# echo "1.进入配置页面后，根据括号内默认信息核对配置，确认无误后点击回车进入下一步操作;"
# echo "2.如需更改配置，请按照默认配置格式进行修改，然后点击回车进入下一步;            "
# echo "3.服务包配置文件使用的数据库名称需要手动输入。                                 "			     #
# read -n 1  -t 20 -p  "按任意键继续。。。                                                   "							     #
# echo -e "\e[0m;"									     #
# clear		
clear
echo ""
echo ""
echo ""
printf "%50s\n"  "说   明"
echo -e  "\t1.进入配置页面后，根据括号内默认信息核对配置，确认无误后点击回车进入下一步操作;"
echo -e  "\t2.如需更改配置，请按照默认配置格式进行修改,然后点击回车进入下一步;"
echo -e  "\t3.服务包配置文件使用的数据库名称需要手动输入；                                 "
echo -e  "\t4.强制退出脚本使用 ctr+c 组合键。                                 "			     #
echo ""
read -n 1  -t 20 -p  "                         按任意键继续。。。                                                   "							     #
echo -e "\e[0m;"									     #
clear	
########################################配置环境变量####################################################
export WORKDIR=`echo $PWD`
export DIR=`echo $PWD`
export AMOS_DIR="${DIR}/amos"
export BUSINESS_DIR="${DIR}/business"
export STUDIO_DIR="${DIR}/studio"
######################################函数模块#################################################
function CONFIG_GET {
	echo "*****************输入配置文件初始化配置..." 
	echo "*****************直接回车将使用默认配置...."     
	while true;do
	read -p "********************* 输入消防自动化系统服务器IP地址(默认:localhost)："  SERVICE_IP
		if [ -z "$SERVICE_IP" ];then
			export SERVICE_IP="localhost"
			echo "已配置默认设置"
			break
		else
			echo "$SERVICE_IP" | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' >/dev/null 2>&1 && echo "已配置变量"  && break ||  echo "错误的IP格式。。再来"
		fi
	done

	read -p "********************* 输入MYSQL数据库端口/用户名/密码(默认:3306 root Yeejoin@2020) " SQL_PORT SQL_USER SQL_PASSWD
	if [ -z "$SQL_PORT" ];then
		export SQL_PORT="3306"
		export SQL_USER="root" 
		export SQL_PASSWD="Yeejoin@2020"
		echo "已配置默认设置"
	else
		echo "已配置变量"
	fi
    
	#echo "请确认数据库名称一致性："
	#echo -e "\tautosys_amos_project \tautosys_amos_studio  \tautosys_amos_workflow\tautosys_business_analysis\tautosys_business "
	#echo -e "\tautosys_exam         \tautosys_iot_platform    \tautosys_knowledge   \tautosys_mass_mdm         \tautosys_person "
	#read -n 1 "按任意键继续。。。"
	read -p "输入REDIS数据库编号/端口/密码(ex：1 6379  1234560): " REDIS_NUM REDIS_PORT REDIS_PASSWD
	if [ -z "$REDIS_NUM" ];then
		export REDIS_NUM="1"
		export REDIS_PORT="6379" 
		export REDIS_PASSWD="1234560"
		echo "已配置默认设置"
	else
		echo "已配置变量"
	fi


	read -p "输入EMQX服务tcp端口(默认:2883) " EMQX_PORT
	if [ -z "$EMQX_PORT" ];then
		export EMQX_PORT="2883"
		echo "已配置默认设置"
	else
		echo "已配置变量"
	fi


	read -p "输入ELASTICSEARCH服务tcp端口/http端口(默认:9300 9200) " ES_TCP_PORT ES_HTTP_PORT
	if [ -z "$ES_TCP_PORT" ];then
		export ES_TCP_PORT="9300"
		export ES_HTTP_PORT="9200"
		echo "已配置默认设置"
	else
		echo "已配置变量"
	fi

	read -p  "输入MINIO-TCP端口/用户名/密码(默认:9000 root yeejoin_1234) " MINIO_PORT  MINIO_USER  MINIO_PASSWD
	if [ -z "$MINIO_PORT" ];then
		export MINIO_PORT="9000"
		export MINIO_USER="root" 
		export MINIO_PASSWD="yeejoin_1234"
		echo "已配置默认设置"
	else
		echo "已配置变量"
	fi

	#read -p "输入FDFS文件服务端口(ex：8888)：" FDFS_PORT
	#read -p "输入infuxDB动态数据库的/http端口/用户名/密码/数据库名称(ex：8086 root 123456  iot-platform )：" INFLUXDB_PORT INFLUXDB_USER INFLUXDB_PASSWD INFLUXDB_SQL
}

######后端服务redis账号密码端口修改##############################
# function CONFIG_REDIS {
# 	sed -i -e  "/spring\.redis\.database/c spring.redis.database=$REDIS_NUM" -e "/spring\.redis\.port/c spring.redis.port=$REDIS_PORT" -e " /spring\.redis\.password/c spring.redis.password=$REDIS_PASSWD" $j && grep redis  $j && echo "${j}-redis配置完成"
# }
# #####后端服务emqx端口配置##########
# function CONFIG_EMQX {
# sed -i  "/emqx\.broker/c emqx.broker=tcp://$SERVICE_IP:$REDIS_PORT"  $j
# }

# #####后端服务elasticsearch端口配置##########
# function CONFIG_ES {
# sed -i -e "/elasticsearch\.cluster-nodes/c spring.data.elasticsearch.cluster-nodes=$SERVICE_IP:$ES_TCP_PORT" -e "/elasticsearch\.cluster-nodes/c spring.elasticsearch.rest.uris=http://$SERVICE_IP:$ES_HTTP_PORT"  $j
# }

# #####后端服务mysql端口配置##########
# function CONFIG_MYSQL {
# sed -i -e "/spring\.datasource\.username/c spring.datasource.username=$SQL_USER" -e "/spring\.datasource\.password/c spring.datasource.password=$SQL_PASSWD"  $j
# }
######################################################################


#######后端服务IP修改.当前工作路径为jar包路径
function CONFIG_UPDATE {
	###########初始化数据#######
	if [ -d log ] ;then
		sleep 1
	else
		mkdir  log 
	fi
	#############################
	echo "确认后端服务端口及基础服务端口:"

	AMOS_APP=`ls *.jar`
	for i in $AMOS_APP
	do
			MOUDLE=`echo $PWD |grep -o 'amos'  || echo $PWD |grep -o 'business' || echo $PWD |grep -o 'studio'`
			# printf "%-5s %-10s %-4s\n" NO Name Mark
			# printf "%-5s %-10s %-4.2f\n" 01 Tom 90.3456
			# printf "%-5s %-10s %-4.2f\n" 02 Jack 89.2345
			# printf "%-5s %-10s %-4.2f\n" 03 Jeff 98.4323
			if [[ "$MOUDLE" == "amos" ]] ;then
				echo -e "序号\tJar包服务\t\t\t\t对应数据库名称示例"
				echo -e "1\tamos-api-iot-platform\t\t\tautosys_iot_platform"
				echo -e "2\tamos-api-privileger\t\t\tautosys_amos_project"
				echo -e "3\tamos-api-workflow\t\t\tautosys_amos_workflow"
				echo -e "4\tamos-api-rule\t\t\t\tautosys_amos_project"
				echo -e "5\tamos-api-systemctl\t\t\tautosys_amos_project"
				echo -e "6\tamos-server-eurka\t\t\t无"
				echo -e "7\tamos-server-gateway\t\t\t无"
				echo -e "8\tamos-server-tracking\t\t\t无"
				echo -e "9\tamos-server-dashboard\t\t\t无"
			elif  [[ "$MOUDLE" == "business" ]];then
				echo -e "序号\tJar包服务\t\t\t对应数据库名称示例"
				echo -e "1\tAutosys-TrainingExamServer\tautosys_exam"
				echo -e "2\tAutosys-DutyModelStart\t\tautosys_businesssx"
				echo -e "3\tAutosys-Knowledgebase\t\tautosys_knowledge"
				echo -e "4\tAutosys-PatrolStart\t\tautosys_business"
				echo -e "5\tAutosys-EquipManageServer\tautosys_business"
				echo -e "6\tAutosys-PrecontrolServer\tautosys_person"
				echo -e "7\tAutosys-FireAutoSysStart\tautosys_business"
				echo -e "8\tAutosys-Renren-admin\t\trenren_security"
				echo -e "9\tAutosys-Gateway\t\t\t无"
				echo -e "10\tAutosys-JpushStart\t\t无"
				echo -e "11\tAutosys-DataProcessServer\t数字化站需要（高思库）"
			else
				echo -e "序号\tJar包服务\t\t\t\t对应数据库名称示例"
				echo -e "1\tvisual-api-graph3d\t\t\tautosys_amos_studio"
				echo -e "2\tvisual-api-studio\t\t\tautosys_amos_studio"
				echo -e "3\tvisual-api-hybrid\t\t\tautosys_amos_studio"
				echo -e "4\tvisual-api-morphic\t\t\tautosys_amos_studio"
				echo -e "5\tmass-application-mdml\t\t\tautosys_mass_mdm"
			fi
			read -p "请输入${i}服务包使用的数据库名称(如没有请直接回车)： " SQL_DB
			echo " "
			echo "配置${i}文件，请稍后。。。"
			echo "##########begining#################"
			echo " "
			sleep 1
			# cd  update/file
			###############判断配置文件是yml或者properties格式#####
			# jar -tf  $WORKDIR/$MOUDLE/$i >result.config.out
			jar -tf  $WORKDIR/$MOUDLE/$i BOOT-INF/classes/  >result.config.out
			if  cat  $WORKDIR/$MOUDLE/result.config.out | grep 'application.properties' ;then #######****if command*******不加` `#####
			# if ` jar -tf  $WORKDIR/$MOUDLE/$i |grep 'application.properties' `;then
			 	jar -xvf  $WORKDIR/$MOUDLE/$i  BOOT-INF/classes/{application.properties,application-dev.properties,application-qa.properties}  &&  cd $WORKDIR/$MOUDLE/BOOT-INF/classes
			else
				jar -xvf  $WORKDIR/$MOUDLE/$i  BOOT-INF/classes/{application.yml,application-dev.yml,application-qa.yml}   &&  cd $WORKDIR/$MOUDLE/BOOT-INF/classes
			fi


			if  ls  *.properties >Config.conf 2<&1 ;then
				while read j
				do
					#####修改ip###
					sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" $j && sed  -r -i  "s/localhost/$SERVICE_IP/g"  $j  && echo "${i}-${j}配置文件服务器IP配置完成"

					#####修改redis###
					sed -i -e  "/spring\.redis\.database/c spring.redis.database=$REDIS_NUM" -e "/spring\.redis\.port/c spring.redis.port=$REDIS_PORT" -e " /spring\.redis\.password/c spring.redis.password=$REDIS_PASSWD" $j && grep "password=$REDIS_PASSWD"  $j >/dev/null  && echo "${j}-redis配置完成"

					#####修改emqx####
					sed -i  "/emqx\.broker/c emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j && grep "emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j >/dev/null  && echo "${j}-emqx配置完成"
					
					#####修改elasticsearch####
					sed -i -e "/elasticsearch\.cluster-nodes/c spring.data.elasticsearch.cluster-nodes=${SERVICE_IP}:$ES_TCP_PORT" -e "/elasticsearch\.cluster-nodes/c spring.elasticsearch.rest.uris=http://${SERVICE_IP}:$ES_HTTP_PORT"  $j && grep "$ES_HTTP_PORT"  $j >/dev/null  && echo "${j}-es配置完成"
					

					#####修改mysql####
				
					sed -i -e "/spring\.datasource\.username/c spring.datasource.username=$SQL_USER" -e "/spring\.datasource\.password/c spring.datasource.password=$SQL_PASSWD" -e "/spring\.datasource\.url/c spring.datasource.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?characterEncoding=utf8&serverTimezone=Asia/Shanghai"  $j  &&  echo "${j}-mysql配置完成"			
					#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
		
					#####renren服务------修改mysql-----------####
					sed -i -e "/spring\.liquibase\.user=/c spring.liquibase.user=$SQL_USER" -e "/spring\.liquibase\.password=/c spring.liquibase.password=$SQL_PASSWD" -e "/spring\.liquibase\.url=/c  spring.liquibase.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?serverTimezone=GMT%2B8"  $j  &&  echo "${j}-mysql配置完成"			
					#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai

					######Minio文件服务器###
					sed -i -e  "/minio\.endpoint=/c minio.endpoint=${SERVICE_IP}" -e "/minio\.port=/c minio.port=$MINIO_PORT" -e " /minio\.accessKey=/c minio.accessKey=$MINIO_USER"  -e " /fileserver_domain=/c fileserver_domain=http://${SERVICE_IP}:$MINIO_USER" -e " /minio\.secretKey=/c minio.secretKey=$MINIO_PASSWD"  $j   && grep "$MINIO_PASSWD"  $j >/dev/null  && echo "${j}-Minio配置完成"

				done <Config.conf
			elif  ls *.yml ; then
					#####修改ip###
					sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" application-dev.yml && sed  -r -i  "s/localhost/$SERVICE_IP/g"  application-dev.yml  && echo "${i}-application-dev.yml配置文件服务器IP配置完成"
					#####修改ip###
					sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" application.yml && sed  -r -i  "s/localhost/$SERVICE_IP/g"  application.yml  && echo "${i}-application.yml配置文件服务器IP配置完成"
					
					#####修改mysql####
					sed -r -i -e "s/username: .*/username: $SQL_USER/" -e "s/password: .*/password: $SQL_PASSWD/" -e "s/jdbc:mysql:\/\/.*:[0-9]*\/.*\?/jdbc:mysql:\/\/${SERVICE_IP}:${SQL_PORT}\/${SQL_DB}\?/"  application-dev.yml  &&  echo "application-dev.yml-mysql配置完成"			
					#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
					
					#####修改redis###
					sed  -r -i -e  "s/ database: .*/ database: $REDIS_NUM/" -e "s/ host: .*/ host: $SERVICE_IP/" -e " s/ password: .*/ password: $REDIS_PASSWD/" application.yml && grep "$REDIS_PASSWD"  application.yml >/dev/null  && echo "application.yml-redis配置完成" 
	        
			else
				echo "错误的jar包文件,无配置文件"
				break
			fi





		##TIPs:windows文本转换为linux文本
		# cat file | col -b > file.1  // 这个可以去掉，但是生成文件里汉字变乱码(后一句据说）
		# sed -e 's/.$//g'  file       // 正确
		# sed ‘s/^M//' file           // 正确，但是 ^M = Ctrl + v, Ctrl + m	
		echo "##########ending#################"

		cd  $WORKDIR/$MOUDLE
		jar -uvf  $WORKDIR/$MOUDLE/$i   BOOT-INF   && rm -rf  $WORKDIR/$MOUDLE/BOOT-INF   && echo "${i}更新文件打包至$WORKDIR/$MOUDLE 目录下"
		sleep 0.3 
	done 
	#############删除studio/business/amos下脚本产生文件########
		rm jartmp*.tmp Config.conf  result.config.out   >/dev/null 2<&1
##################################################MASS文件配置##################################
	# if `echo $WORKDIR |grep -o 'studio'`; then
	# 	if `ls  | grep "[mM][aA][Ss]" | test -d`;then
	# 			 MASS_NAME=`ls  | grep '[mM][aA][Ss]'`
	# 	else     
	# 			echo "检查mass服务文件夹"
	# 	fi
	# else
	# 	echo " "
	# fi
	echo $MOUDLE | grep "studio" >/dev/null
	if [ $? -eq 0 ]; then
		export  MASSNAME=`ls $WORKDIR/$MOUDLE | grep '[mM][aA][Ss][Ss]'`
		echo $MASSNAME
		echo "开始配置mass服务文件"
	else
		echo " "
	fi

	if [  $MASSNAME ] &&  [[ $MOUDLE == "studio" ]];then 
			cd  $WORKDIR/$MOUDLE/$MASSNAME
			echo -e "1\tmass-application-mdm\t\t\tautosys_mass_mdm_v1.0.12_20210723"
			read -p "请输入$MASSNAME服务包使用的数据库名称(如没有请直接回车)： " SQL_DB
			echo " "
			echo "配置${MASSNAME}文件，请稍后。。。"
			echo "##########begining#################"
			echo " "
			sleep 1
			ls  *.properties >Config.conf
			while read j
			do
				#####修改ip###
				sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" $j && sed  -r -i  "s/localhost/$SERVICE_IP/g"  $j  && echo "${i}-${j}配置文件服务器IP配置完成"

				#####修改redis###
				sed -i -e  "/spring\.redis\.database=/c spring.redis.database=$REDIS_NUM" -e "/spring\.redis\.port=/c spring.redis.port=$REDIS_PORT" -e " /spring\.redis\.password=/c spring.redis.password=$REDIS_PASSWD" $j && grep "password=$REDIS_PASSWD"  $j >/dev/null  && echo "${j}-redis配置完成"

				#####修改emqx####
				sed -i  "/emqx\.broker=/c emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j && grep "emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j >/dev/null  && echo "${j}-emqx配置完成"
				
				#####修改elasticsearch####
				sed -i -e "/spring.data.elasticsearch\.cluster-nodes=/c spring.data.elasticsearch.cluster-nodes=${SERVICE_IP}:$ES_TCP_PORT" -e "/spring\.elasticsearch\.rest\.uris=/c spring.elasticsearch.rest.uris=http://${SERVICE_IP}:$ES_HTTP_PORT"  $j && grep "$ES_HTTP_PORT"  $j >/dev/null  && echo "${j}-es配置完成"
				

				#####修改mysql####
			
				sed -i -e "/spring\.datasource\.username=/c spring.datasource.username=$SQL_USER" -e "/spring\.datasource\.password=/c spring.datasource.password=$SQL_PASSWD" -e "/spring\.datasource\.url=/c spring.datasource.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?characterEncoding=utf8&serverTimezone=Asia/Shanghai"  $j  &&  echo "${j}-mysql配置完成"			
				#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
	
			done <Config.conf
			rm Config.conf


			cd  $WORKDIR/$MOUDLE/$MASSNAME/config
			ls  *.properties >Config.conf
			while read j
			do
				#####修改ip###
				sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" $j && sed  -r -i  "s/localhost/$SERVICE_IP/g"  $j  && echo "${i}-${j}配置文件服务器IP配置完成"

				#####修改redis###
				sed -i -e  "/spring\.redis\.database=/c spring.redis.database=$REDIS_NUM" -e "/spring\.redis\.port=/c spring.redis.port=$REDIS_PORT" -e " /spring\.redis\.password=/c spring.redis.password=$REDIS_PASSWD" $j && grep "password=$REDIS_PASSWD"  $j >/dev/null  && echo "${j}-redis配置完成"

				#####修改emqx####
				sed -i  "/emqx\.broker=/c emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j && grep "emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j >/dev/null  && echo "${j}-emqx配置完成"
				
				#####修改elasticsearch####
				sed -i -e "/elasticsearch\.cluster-nodes=/c spring.data.elasticsearch.cluster-nodes=${SERVICE_IP}:$ES_TCP_PORT" -e "/spring\.elasticsearch\.rest\.uris=/c spring.elasticsearch.rest.uris=http://${SERVICE_IP}:$ES_HTTP_PORT"  $j && grep "$ES_HTTP_PORT"  $j >/dev/null  && echo "${j}-es配置完成"
				

				#####修改mysql####
			
				sed -i -e "/spring\.datasource\.username=/c spring.datasource.username=$SQL_USER" -e "/spring\.datasource\.password=/c spring.datasource.password=$SQL_PASSWD" -e "/spring\.datasource\.url=/c spring.datasource.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?characterEncoding=utf8&serverTimezone=Asia/Shanghai"  $j  &&  echo "${j}-mysql配置完成"			
				#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
	
			done <Config.conf
			rm Config.conf
		echo "${MASSNAME}更新文件打包至$WORKDIR/$MOUDLE/${MASSNAME} 目录下"
	fi
	echo "" 
	echo ""
	echo "####################################"
	echo "$MOUDLE服务jar包配置完成"
	sleep 0.2
}




#######################################自定义路径jar包配置#############################################################
function ZDY_CONFIG_UPDATE {

	AMOS_APP=`ls *.jar`
	for i in $AMOS_APP
	do
			read -p "请输入${i}服务包使用的数据库名称(如没有请直接回车)： " SQL_DB
			echo " "
			echo "配置${i}文件，请稍后。。。"
			echo "##########begining#################"
			echo " "
			sleep 1
			# cd  update/file
			# jar -xvf  $SELFPATH_JAR/$i  BOOT-INF/classes/{application-dev.properties,application-qa.properties} >/dev/null 2>&1  &&  cd  $SELFPATH_JAR/BOOT-INF/classes
			jar -tf  $SELFPATH_JAR/$i BOOT-INF/classes/  >result.config.out
			if  cat  $SELFPATH_JAR/result.config.out | grep 'application.properties' ;then 
				jar -xvf  $SELFPATH_JAR/$i  BOOT-INF/classes/{application.properties,application-dev.properties,application-qa.properties}  &&  cd $SELFPATH_JAR/BOOT-INF/classes
			else
				jar -xvf  $SELFPATH_JAR/$i  BOOT-INF/classes/{application.yml,application-dev.yml,application-qa.yml}   &&  cd $SELFPATH_JAR/BOOT-INF/classes
			fi
			
			if  ls  *.properties >Config.conf 2<&1 ;then
				while read j
				do
					#####修改ip###
					sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" $j && sed  -r -i  "s/localhost/$SERVICE_IP/g"  $j  && echo "${i}-${j}配置文件服务器IP配置完成"

					#####修改redis###
					sed -i -e  "/spring\.redis\.database/c spring.redis.database=$REDIS_NUM" -e "/spring\.redis\.port/c spring.redis.port=$REDIS_PORT" -e " /spring\.redis\.password/c spring.redis.password=$REDIS_PASSWD" $j && grep "password=$REDIS_PASSWD"  $j >/dev/null  && echo "${j}-redis配置完成"

					#####修改emqx####
					sed -i  "/emqx\.broker/c emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j && grep "emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j >/dev/null  && echo "${j}-emqx配置完成"
					
					#####修改elasticsearch####
					sed -i -e "/elasticsearch\.cluster-nodes/c spring.data.elasticsearch.cluster-nodes=${SERVICE_IP}:$ES_TCP_PORT" -e "/elasticsearch\.cluster-nodes/c spring.elasticsearch.rest.uris=http://${SERVICE_IP}:$ES_HTTP_PORT"  $j && grep "$ES_HTTP_PORT"  $j >/dev/null  && echo "${j}-es配置完成"
					

					#####修改mysql####
				
					sed -i -e "/spring\.datasource\.username/c spring.datasource.username=$SQL_USER" -e "/spring\.datasource\.password/c spring.datasource.password=$SQL_PASSWD" -e "/spring\.datasource\.url/c spring.datasource.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?characterEncoding=utf8&serverTimezone=Asia/Shanghai"  $j  &&  echo "${j}-mysql配置完成"			
					#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
		

					#####renren服务------修改mysql-----------####
					sed -i -e "/spring\.liquibase\.user=/c spring.liquibase.user=$SQL_USER" -e "/spring\.liquibase\.password=/c spring.liquibase.password=$SQL_PASSWD" -e "/spring\.liquibase\.url=/c  spring.liquibase.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?serverTimezone=GMT%2B8"  $j  &&  echo "${j}-mysql配置完成"			
					#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai

					######Minio文件服务器###
					sed -i -e  "/minio\.endpoint=/c minio.endpoint=${SERVICE_IP}" -e "/minio\.port=/c minio.port=$MINIO_PORT" -e " /minio\.accessKey=/c minio.accessKey=$MINIO_USER"  -e " /fileserver_domain=/c fileserver_domain=http://${SERVICE_IP}:$MINIO_USER" -e " /minio\.secretKey=/c minio.secretKey=$MINIO_PASSWD"  $j   && grep "$MINIO_PASSWD"  $j >/dev/null  && echo "${j}-Minio配置完成"

				done <Config.conf
			elif  ls *.yml ;then
					#####修改ip###
					sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" application-dev.yml && sed  -r -i  "s/localhost/$SERVICE_IP/g"  application-dev.yml  && echo "${i}-application-dev.yml配置文件服务器IP配置完成"
					#####修改ip###
					sed -r -i   "s/[0-9]{2,3}\.([0-9]{1,3}\.){2}[0-9]{1,3}/$SERVICE_IP/g" application.yml && sed  -r -i  "s/localhost/$SERVICE_IP/g"  application.yml  && echo "${i}-application.yml配置文件服务器IP配置完成"
					
					#####修改mysql####
					sed -r -i -e "s/username: .*/username: $SQL_USER/" -e "s/password: .*/password: $SQL_PASSWD/" -e "s/jdbc:mysql:\/\/.*:[0-9]*\/.*\?/jdbc:mysql:\/\/${SERVICE_IP}:${SQL_PORT}\/${SQL_DB}\?/"  application-dev.yml  &&  echo "application-dev.yml-mysql配置完成"			
					#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
					
					#####修改redis###
					sed  -r -i -e  "s/ database: .*/ database: $REDIS_NUM/" -e "s/ host: .*/ host: $SERVICE_IP/" -e " s/ password: .*/ password: $REDIS_PASSWD/" application.yml && grep "$REDIS_PASSWD"  application.yml >/dev/null  && echo "application.yml-redis配置完成" 

			else
				echo "错误的jar包文件,无配置文件"
				break
			fi
			
			
			
			# ls  *.properties >Config.conf
			# while read j
			# do
			# 	#####修改ip###
			# 	sed -r -i   "s/([0-9]{1,3}\.){3}[0-9]{1,3}/$SERVICE_IP/g" $j && sed  -r -i  "s/localhost/$SERVICE_IP/g"  $j  && echo "${i}-${j}配置文件服务器IP配置完成"

			# 	#####修改redis###
			# 	sed -i -e  "/spring\.redis\.database/c spring.redis.database=$REDIS_NUM" -e "/spring\.redis\.port/c spring.redis.port=$REDIS_PORT" -e " /spring\.redis\.password/c spring.redis.password=$REDIS_PASSWD" $j && grep "password=$REDIS_PASSWD"  $j >/dev/null  && echo "${j}-redis配置完成"

			# 	#####修改emqx####
			# 	sed -i  "/emqx\.broker/c emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j && grep "emqx.broker=tcp://${SERVICE_IP}:$EMQX_PORT"  $j >/dev/null  && echo "${j}-emqx配置完成"
				
			# 	#####修改elasticsearch####
			# 	sed -i -e "/elasticsearch\.cluster-nodes/c spring.data.elasticsearch.cluster-nodes=${SERVICE_IP}:$ES_TCP_PORT" -e "/elasticsearch\.cluster-nodes/c spring.elasticsearch.rest.uris=http://${SERVICE_IP}:$ES_HTTP_PORT"  $j && grep "$ES_HTTP_PORT"  $j >/dev/null  && echo "${j}-es配置完成"
				

			# 	#####修改mysql####
			
			# 	sed -i -e "/spring\.datasource\.username/c spring.datasource.username=$SQL_USER" -e "/spring\.datasource\.password/c spring.datasource.password=$SQL_PASSWD" -e "/spring\.datasource\.url/c spring.datasource.url=jdbc:mysql://${SERVICE_IP}:${SQL_PORT}/${SQL_DB}?characterEncoding=utf8&serverTimezone=Asia/Shanghai"  $j  &&  echo "${j}-mysql配置完成"			
			# 	#spring.datasource.url=jdbc:mysql://localhost:3306/safety-knowledge-3.0.0?characterEncoding=utf8&serverTimezone=Asia/Shanghai
	
			# done <Config.conf

		
		##TIPs:windows文本转换为linux文本
		# cat file | col -b > file.1  // 这个可以去掉，但是生成文件里汉字变乱码(后一句据说）
		# sed -e 's/.$//g'  file       // 正确
		# sed ‘s/^M//' file           // 正确，但是 ^M = Ctrl + v, Ctrl + m	
		echo "##########ending#################"

		cd  $SELFPATH_JAR
		jar -uvf  $SELFPATH_JAR/$i   BOOT-INF   &&  rm -rf  $SELFPATH_JAR/BOOT-INF   && echo "${i}更新文件打包至$SELFPATH_JAR 目录下"
		rm jartmp*.tmp Config.conf  result.config.out  >/dev/null  2<&1
		sleep 0.3 
	done 

	echo "" 
	echo ""
	echo "####################################"

	sleep 0.2
}
########################################自定义路径jar包配置###############################


########HYBRID_APP_PAGE表数据库IP修改
function HYBRID_IP {
	read -p "输入studio数据库名称" STUDIO_SQL
	mysqldump -h $SERVICE_IP -P $SQL_PORT  -u $SQL_USER -p$SQL_PASSWD $STUDIO_SQL hybrid_app_page > /tmp/hybrid_app_page.sql
	echo "hybrid_app_page数据表中的IP有： "
	grep -Eo  '([0-9]{1,3}\.){3}[0-9]{1,3}' /tmp/hybrid_app_page.sql |sort -rn| uniq
	read -n 1 -p "按任意键继续。。"
	sed  -r -i "s/([0-9]{1,3}\.){3}[0-9]{1,3}/$SERVICE_IP/g" /tmp/hybrid_app_page.sql
	echo "数据库表已配置，请确认服务器IP: "
	grep -Eo  '([0-9]{1,3}\.){3}[0-9]{1,3}' /tmp/hybrid_app_page.sql  |sort -rn| uniq 
	read -p "请确认继续[y|n]" ANSWER
	case $ANSWER in 
			y|Y)
				echo "确认配置正确，开始数据库导入。。"
				mysql -h $SERVICE_IP -P 30306  -u $SQL_USER -p$SQL_PASSWD $STUDIO_SQL  < /tmp/hybrid_app_page.sql
				if [ $? -eq 0 ];then
					echo "数据库导入成功。。"
				else
					echo "数据库导入失败，请重试。。"
					exit 1
				fi		
				;;
				
			n|N)
				echo "配置错误，请检查输入服务器IP正确。。。"
				;;
			*)
				echo "错误"
				;;
	esac

}


########################自定义路径确认函数##############
function FUNC_SELFPATH_JAR {
while true;do				
	read -p "输入待配置jar包所在【绝对】路径[ex:在jar包目录下使用 pwd 命令/home/path/to/jar]: "  SELFPATH_JAR			
	if cd $SELFPATH_JAR && [[ "$SELFPATH_JAR" == /* ]];then
		echo "配置$SELFPATH_JAR下文件"
		break
	else
		echo "错误的路径，重新输入"
	fi
done
}

function UPSTEP_TRUE {
	if [ $? -eq 0 ];then
		echo "进入$PWD目录，继续"
	else 
		echo "错误的路径，退出脚本"
		exit 1
	fi
}

#####################################变量配置确认##########################
while : ;do
	CONFIG_GET
	echo -e "\e[32m"
	echo "请确认配置的变量："
	echo -e "\t\t服务器IP:${SERVICE_IP}"
	echo -e "\t\t数据库端口：${SQL_PORT}\t数据库用户名:${SQL_USER}\t数据库密码:${SQL_PASSWD}"
	echo -e "\t\tREDIS编号：${REDIS_NUM}\t\tREDIS端口: ${REDIS_PORT}\t\tREDIS密码: ${REDIS_PASSWD}"
	echo -e "\t\tEMQX端口:${EMQX_PORT}"
	echo -e "\t\tES-TCP端口:${ES_TCP_PORT}\t\tES-HTTP端口:${ES_HTTP_PORT}"
	echo -e "\t\tMinio-TCP端口:${MINIO_PORT}\tMinio用户名:${MINIO_USER}\t数据库密码:${MINIO_PASSWD}"
	echo -e "\e[0m"
	read -n 1 -p  "确认变量配置正确,输入y/n:" SURE
	case $SURE in
		[yY])  echo " "
		gawk '{printf ("%-10s完成基础服务变量配置%10s",#,#)}' amos
		echo
		break ;;
		[nN]) 
			continue 	;;
	esac
 done


#############################################################################
while true
do
	clear
	echo " "
	echo "################################"
	PS3="*****请选择你要配置jar包的服务模块[自定义配置文件路径]: "
	OPERATE=("AMOS-JAR" "BUSINESS-JAR" "STUDIO-JAR" "ZDY-PATH" "QUIT"  "HYBRID-IP" )
	select OPTION in ${OPERATE[@]}
	do
		echo "*****请选择你要配置jar包的服务模块[自定义配置文件路径]: "
		case $OPTION in
			AMOS-JAR)
			    cd $AMOS_DIR
				UPSTEP_TRUE
				CONFIG_UPDATE ;;
			BUSINESS-JAR) 
			    cd  $BUSINESS_DIR
				UPSTEP_TRUE 
				CONFIG_UPDATE ;;
			STUDIO-JAR) 
				cd  $STUDIO_DIR
				UPSTEP_TRUE
				CONFIG_UPDATE ;;
			ZDY-PATH) 
				FUNC_SELFPATH_JAR
				ZDY_CONFIG_UPDATE ;;	
			HYBRID-IP) HYBRID_IP ;;		
		 	QUIT) exit 0 ;;
		esac
	done
done
