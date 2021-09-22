#!/bin/bash
#消防自动化v1.0三维取点工具
#DATE 20200707


read -p "请输入三维坐标点mini" PICKER
X=`echo $PICKER | cut -d "," -f 1 `
echo "x横坐标是$X"

Y=`echo $PICKER | cut -d "," -f 2 `
echo "y高坐标是$Y"


Z=`echo $PICKER | cut -d "," -f 3 `
echo "z纵坐标是$Z"



read -p "请输入三维坐标点max" MAXPICKER
A=`echo $MAXPICKER | cut -d "," -f 1 `
echo "x横坐标是$A"


S=`echo $MAXPICKER | cut -d "," -f 2 `
echo "y高坐标是$S"


D=`echo $MAXPICKER | cut -d "," -f 3 `
echo "z纵坐标是$D"


####生成3d范围内的点
read -p "请输入区域内生成的点数量" COUNT

RANDONF(){
awk 'BEGIN{srand();print rand()}'
}

RANDONS(){
	if [[ ! $1 == -* ]] && [[ ! $2 == -* ]];then
		shuf -i $1-$2 -n1 |head -n1
	elif [[ $1 == -* ]] && [[  $2 == -* ]];then
		shuf -i `echo $2  |gawk -F"-" '{print $2}'`-`echo $1|gawk -F"-" '{print $2}'` -n1  |head -n1 |awk '{OFS="";print "-" ,$0}'
				
	else
		echo  $(shuf -i 0-`echo " -1*$1 + $2" |bc` -n1 |head -n1) + $1 |bc
		
	fi
		
}





#######################
for (( i = 1;i <= $COUNT; i++ ));
do

	var=$( echo `RANDONF` + `RANDONS $X $A `| bc )
	X[$i]=$var 
	echo "X[$i]=${X[i]}"
	

	var=$( echo `RANDONF` + `RANDONS $Z $D `| bc )
	Z[$i]=$var 
	echo "Z[$i]=${Z[$i]}"

	


	sleep 0.005

done 




####################
j=1
while [ $j -le $COUNT ]
do
	echo "${X[$j]},${Y},${Z[$j]}"
	j=`expr $j + 1 `
done


