#!/bin/bash
#AUTHOR Y
#DATE 20210623

trap   "echo waring,data is dealing...." 2

function VISIO {
	clear
	echo 
	echo -e "\033[33m"
	echo -e "\t\t\t换流站风险模型数据整理\t\t\t"
	echo -e "\t\t1.请在当前目录下创建xx-hlz/xx-hlz.svg源文件\t\t"
	echo -e "\t\t2.确认换流站svg原始文件是否为linux文本文件，否则执行sed -i "s/.$//g" *.svg命令，或者执行windows2unix命令"
	echo -e "\t\t3.生成文件后请在web页面测试脚本生成的文件，与源文件是否有出入；\e[0m"
	echo -e "\e[32m\t\t##########################WARNIGN########################"
	echo -e "\t\t\t此命令可移植使用，使用前将命令放在/usr/bin目录下即可"
	read -n 1 -p "按任意键继续"
	echo -e "\033[0m"
}


function INFO {
	>info.list
	>$PWD/${station}-hlz/info.svg
	echo 
	echo "#######处理info.svg信息"
	for (( i=1; i<=${regionum}; i++ ))
	do
		
	#	sed -en '$[ ${regionum} + 12 ],$p'  $PWD/${station}-hlz/${station}-hlz.svg |cut -d "^" -f 1 | grep -A 8  "_12-${i}[^0-9]" | grep -Eo 'd=\"M.*[0-9Z]\"|x1=.*\"' >>info.list 
		tail -n  "+$(($regionum + 12))"  $PWD/${station}-hlz/${station}-hlz.svg |cut -d "^" -f 1 | grep -A 8  "_12-${i}$" | grep -Eo 'd=\"M.*[0-9Z]\"|x1=.*\"' >>info.list 
		if [ $? -ne 0 ];then
			break
		fi
	done
        exec 3>&1
	exec 1>$PWD/${station}-hlz/info.svg
	ITEM=1
	while read  LIST
	do
		echo "  <path data-member=\"mapItem-$ITEM\" name=\"mapItemDot-$ITEM\" class=\"dot-one dot\" $LIST/>" 
		read LIST1 
		echo "  <path data-member=\"mapItem-$ITEM\" id=\"mapItemLine-$ITEM\" class=\"line-one line\" $LIST1/>" 
		read LIST2
		echo "  <path data-member=\"mapItem-$ITEM\" class=\"face-one msgblock\" $LIST2/>" 
		read LIST3
		echo "  <path data-member=\"mapItem-$ITEM\" class=\"edge-one edge\" $LIST3/>" 
		echo ""



		ITEM=$[ $ITEM + 1 ]
	done <info.list

	echo " </svg>" 
	exec 1>&3
	unset ITEM
	unset i
	sed -i '1i\<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 983 432.53">' $PWD/${station}-hlz/info.svg
	echo "$PWD/${station}-hlz目录下查看文件"
}

function SITMAP {
	>sit.list
	>$PWD/${station}-hlz/sit-map.svg
	#sed -i '6,$d' $PWD/${station}-hlz/sit-map.svg
	echo 
	echo  -e "########处理sit-map信息"
	##sitmap信息行数范围
	NUM_SIT=$[ 12 + $regionum ]
	sed -n "1,${NUM_SIT}p" $PWD/${station}-hlz/${station}-hlz.svg  | sed -n '/_12/p' | grep -o 'M[^>].*Z' > sit.list
	ITEM=1
	while read  LIST
	do
		echo "<path id=\"mapItem-${ITEM}\" class=\"face-fourfive\" d=\"$LIST\"/>" >>$PWD/${station}-hlz/sit-map.svg
		ITEM=$[ $ITEM + 1 ]
	done<sit.list
	echo "$PWD/${station}-hlz/目录下查看文件g"
	echo '</svg>' >>$PWD/${station}-hlz/sit-map.svg
	sed  -i '1i\<svg\n  xmlns="http://www.w3.org/2000/svg"\n  viewBox="0 0 983 432.53"\n  aria-label="风险评估 -- 区域"\n>' $PWD/${station}-hlz/sit-map.svg
	}

function TEXT {
	>text.list
#	sed -i '5,$d' $PWD/${station}-hlz/text.svg
	>$PWD/${station}-hlz/text.svg
	echo
	echo "#####处理text.svg信息"
	for (( i=1; i<20; i++ ))
	do
		cut -d "^" -f 1 $PWD/${station}-hlz/${station}-hlz.svg  | grep -A 17 "_12-${i}$" | grep  -A 5 'txt' | grep -Eo '\"translate.*\)\"' >>text.list
		if [ $? -ne 0 ];then
			break
		fi
	done

	ITEM=1
	while read  LIST
	do
		echo "<text data-member=\"mapItem-$ITEM\" transform=$LIST class=\"info-name\">RPNr</text>" >>$PWD/${station}-hlz/text.svg
		read LIST1 
		echo "<text data-member=\"mapItem-$ITEM\" transform=$LIST1 class=\"info-value\">350</text>" >>$PWD/${station}-hlz/text.svg
		echo " " >>text.svg
		ITEM=$[ $ITEM + 1 ]
	done<text.list
	sed  -i '1i\<svg\n  xmlns="http://www.w3.org/2000/svg"\n  viewBox="0 0 983 432.53"\n>' $PWD/${station}-hlz/text.svg
	echo "</svg>" >>$PWD/${station}-hlz/text.svg
	echo "在$PWD/${station}-hlz/目录下查看文件"
}


function REGION {
	
	sed -n '11,25p' $PWD/${station}-hlz/${station}-hlz.svg|cut -d "\"" -f 2 |grep  '_12'|cut -d "-" -f 2 |sort -rn |sed -n '1p'
	
}


function INIT {
read -p "###输入换流站名称[中州-zz]： " station
echo "###你要配置的换流站为：$station"

read -n 3 -t 5 -p  "###确认此换流站风险区域数量小于15个[yes/no]:" count
	case $count in
	yes|y|YES)
		echo "好，我们继续。。"
		;;
	no|NO|N|n)
		echo "不符合要求，请确认。。。"
		read -p "还要继续吗[yes/no]" sure
			case  $sure in
				yes|y|YES)
                			echo "好，我们继续。。"
                			;;
		        	no|NO|N|n)
					echo "退出。。"
					exit
					；；
			esac


	esac
}


function main {

	INFO
	SITMAP
	TEXT
	ARCHIVE
}

function ARCHIVE {
zip -r $PWD/${station}-hlz/${station}-hlz.zip $PWD/${station}-hlz
echo -e  "\e[31m"
echo "请在$PWD/${station}-hlz/${station}-hlz.zip路径下查看文件"
read -n 1 -p "按任意键继续"
echo 
echo -e "ENDING.....\e[0m"
}


############
############

VISIO
INIT

until [ -d ${station}-hlz ] 
do
	echo "请在当前目录下创建${station}-hlz 文件夹,并放置${station}-hlz/${station}-hlz.svg文件"
	exit 1	
done

until   [ -e  $PWD/${station}-hlz/${station}-hlz.svg ]
do
	echo "请在当前目录下创建${station}-hlz 文件夹,并放置${station}-hlz/${station}-hlz.svg文件"
	exit 1
done

regionum=$(REGION)
main





