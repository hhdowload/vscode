#!/bin/bash
#2020/07/23
#Y
#0802增加服务启动情况检查选项

clear
trap " echo 'BYE..' && exit 1 " SIGINT  #2

######################################README##################################################
echo -e "\e[32m"                                                                             #
echo -e      "---------------------------README------------------------------------------"   #
echo ""
echo ""
echo "1、将该程序放在服务studio.amos.business同级目录下，执行$0 命令"                        #
echo "2、将JAR-path.sh配置文件放在studio.amos.business同级目录下，配置jar包文件名称端口等信息" #
echo "3、程序执行脚本时，会检查配置信息，如果未正确配置将退出脚本，请维护脚本的jar包信息"    #
echo ""
echo ""
echo ""
read -n 1 -p  "************************按任意键继续***************************************"  #
echo -e "\e[0m;"                                                                             #
clear                                                                                        #
###########################################变量配置###############################################################
source  ./JAR-path.sh
DIR=`echo $PWD`
AMOS_DIR="${DIR}/amos"
BUSINESS_DIR="${DIR}/business"
STUDIO_DIR="${DIR}/studio"

if `ls $STUDIO_DIR  | grep "[mM][aA][Ss]" | test -d`;then
        MASS_NAME=`ls $STUDIO_DIR  | grep '[mM][aA][Ss]'`
else     
        echo "检查mass服务文件夹"
fi

STUDIO_MASS_DIR=$STUDIO_DIR/$MASS_NAME
##################################################AMOS#############################################################
function EURE_KA {
        ## 启动eureka
        cd $AMOS_DIR
        echo "--------EUREKA 开始启动--------------"
        nohup java -Xms256m -Xmx256m -jar $EUREKA --spring.profiles.active=$DEPLOY_EVN >/dev/null &
            echo "started"
        EUREKA_pid=`lsof -i:$EUREKA_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$EUREKA_pid" ]
            do
              EUREKA_pid=`lsof -i:$EUREKA_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "EUREKA pid is $EUREKA_pid"
        echo "--------EUREKA 启动成功--------------"
            echo "-------------------------------------"
        }
function EUREKA_stop {
         P_ID=`ps -ef | grep -w $EUREKA | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===EUREKA process not exists or stop success"
        else
            kill -9 $P_ID
            echo "EUREKA killed success"
        fi

}

function DASH_BOARD {
        ## 启动DASHBOARD
        cd $AMOS_DIR
        echo "-------- DASHBOARD 开始启动---------------"
        nohup java -Xms256m -Xmx256m  -jar $DASHBOARD --spring.profiles.active=$DEPLOY_EVN >/dev/null &
        echo "started"
        DASHBOARD_pid=`lsof -i:$DASHBOARD_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$DASHBOARD_pid" ]
            do
              DASHBOARD_pid=`lsof -i:$DASHBOARD_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "DASHBOARD pid is $DASHBOARD_pid"
        echo "---------DASHBOARD 启动成功-----------"
        echo "--------------------------------------"
        }
function DASHBOARD_stop {
         P_ID=`ps -ef | grep -w $DASHBOARD | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===DASHBOARD process not exists or stop success"
        else
            kill -9 $P_ID
            echo "DASHBOARD killed success"
        fi

}

function GATE_WAY { 
        ## 启动gateway
        cd $AMOS_DIR
        echo "-------- GATEWAY 开始启动---------------"
        nohup java -Xms256m -Xmx256m  -jar $GATEWAY --spring.profiles.active=$DEPLOY_EVN >/dev/null  &
        echo "started"
        GATEWAY_pid=`lsof -i:$GATEWAY_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$GATEWAY_pid" ]
            do
              GATEWAY_pid=`lsof -i:$GATEWAY_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "GATEWAY pid is $GATEWAY_pid"
        echo "---------GATEWAY 启动成功-----------"
        echo "------------------------------------"
        }
function GATEWAY_stop {
         P_ID=`ps -ef | grep -w $GATEWAY | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===GATEWAY process not exists or stop success"
        else
            kill -9 $P_ID
            echo "GATEWAY killed success"
        fi

}

function PRI_VILEGE {
        ## 启动PRIVILEGE
        cd $AMOS_DIR
        echo "-------- PRIVILEGE 开始启动---------------"
        nohup java -Xms256m -Xmx256m  -jar $PRIVILEGE --spring.profiles.active=$DEPLOY_EVN >/dev/null &
            echo "started"
        PRIVILEGE_pid=`lsof -i:$PRIVILEGE_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$PRIVILEGE_pid" ]
            do
              PRIVILEGE_pid=`lsof -i:$PRIVILEGE_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "PRIVILEGE pid is $PRIVILEGE_pid"
        echo "--------- PRIVILEGE 启动成功-----------"
        echo "---------------------------------------"
        }
function PRIVILEGE_stop {
                P_ID=`ps -ef | grep -w $PRIVILEGE | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===PRIVILEGE process not exists or stop success"
        else
            kill -9 $P_ID
            echo "PRIVILEGE killed success"
        fi

}


function SYS_TEMCTL {
        ## 启动SYSTEMCTL
        cd $AMOS_DIR
        echo "-------- SYSTEMCTL 开始启动---------------"
        nohup java -Xms256m -Xmx256m  -jar $SYSTEMCTL --spring.profiles.active=$DEPLOY_EVN >/dev/null  &
            echo "started"
        SYSTEMCTL_pid=`lsof -i:$SYSTEMCTL_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$SYSTEMCTL_pid" ]
            do
              SYSTEMCTL_pid=`lsof -i:$SYSTEMCTL_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "SYSTEMCTL pid is $SYSTEMCTL_pid"
        echo "--------- SYSTEMCTL 启动成功-----------"
            echo "---------------------------------------"
            }
function SYSTEMCTL_stop {
       P_ID=`ps -ef | grep -w $SYSTEMCTL | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===SYSTEMCTL process not exists or stop success"
        else
            kill -9 $P_ID
            echo "SYSTEMCTL killed success"
        fi
}


function RU_LE {
        ## 启动RULE
        cd $AMOS_DIR
        echo "-------- RULE 开始启动---------------"
        nohup java -Xms256m -Xmx256m  -jar $RULE --spring.profiles.active=$DEPLOY_EVN >log/rule.log  &
        echo "started"
        RULE_pid=`lsof -i:$RULE_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$RULE_pid" ]
            do
              RULE_pid=`lsof -i:$RULE_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "RULE pid is $RULE_pid"
        echo "--------- RULE 启动成功-----------"
        echo "---------------------------------------"
        }
function RULE_stop {
        P_ID=`ps -ef | grep -w $RULE | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===RULE process not exists or stop success"
        else
            kill -9 $P_ID
            echo "RULE killed success"
        fi

}



function IOT_PLATFORM {
        ## 启动IOTPLATFORM
        cd $AMOS_DIR
        echo "-------- IOTPLATFORM开始启动---------------"
                nohup java -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $IOTPLATFORM --spring.profiles.active=dev >log/iot.log  &
            echo "started"
        IOTPLATFORM_pid=`lsof -i:$IOTPLATFORM_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$IOTPLATFORM_pid" ]
            do
              IOTPLATFORM_pid=`lsof -i:$IOTPLATFORM_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "IOTPLATFORM pid is $IOTPLATFORM_pid"
        echo "---------IOTPLATFORM 启动成功-----------"
            echo "--------------------------------------"

        }
function IOTPLATFORM_stop {
        P_ID=`ps -ef | grep -w $IOTPLATFORM | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===PRECONTROL process not exists or stop success"
        else
            kill -9 $P_ID
            echo "IOTPLATFORM killed success"
        fi
}



function WORK_FLOW {
         ## 启动Workflow
        cd $AMOS_DIR
        echo "-------- Workflow 开始启动---------------"
        nohup java -Xms256m -Xmx256m  -jar $Workflow --spring.profiles.active=dev >/dev/null &
            echo "started"
        Workflow_pid=`lsof -i:$Workflow_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$Workflow_pid" ]
            do
              Workflow_pid=`lsof -i:$Workflow_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "Workflow pid is $Workflow_pid"
        echo "---------Workflow 启动成功-----------"
            echo "--------------------------------------"
        }
function WORKFLOW_stop {
        P_ID=`ps -ef | grep -w $Workflow | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===PRECONTROL process not exists or stop success"
        else
            kill -9 $P_ID
            echo "Workflow killed success"
        fi
}



function TRACK_ING {
        ## 启动TRACKING
        cd $AMOS_DIR
        echo "--------TRACKING 开始启动 ---------------"
        nohup java -Xms256m -Xmx256m  -jar $TRACKING --spring.profiles.active=$DEPLOY_EVN  >/dev/null &
        echo "started"
        TRACKING_pid=`lsof -i:$TRACKING_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$TRACKING_pid" ]
            do
              TRACKING_pid=`lsof -i:$TRACKING_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "TRACKING pid is $TRACKING_pid"
        echo "---------TRACKING 启动成功-----------"
        echo "-------------------------------------"
        echo "===TRACKING start success==="
        }
function TRACKING_stop {
        P_ID=`ps -ef | grep -w $TRACKING | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===TRACKING process not exists or stop success"
        else
            kill -9 $P_ID
            echo "TRACKING killed success"
        fi

}



###################################################BUSINESS#################################################################
function BGATE_WAY {
        ## 启动BGATEWAY
        cd $BUSINESS_DIR
        echo "--------BGATEWAY 开始启动--------------"
        nohup java -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $BGATEWAY --spring.profiles.active=$DEPLOY_EVN >log/businessGateway.log &
	echo "started"
        BGATEWAY_pid=`lsof -i:$BGATEWAY_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$BGATEWAY_pid" ]
            do
              BGATEWAY_pid=`lsof -i:$BGATEWAY_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "BGATEWAY pid is $BGATEWAY_pid" 
        echo "--------BGATEWAY 启动成功--------------"
	echo "-------------------------------------" 
      }
function AUTO_SYS {
	## 启动AUTOSYS
        cd $BUSINESS_DIR
        echo "--------AUTOSYS 开始启动 ---------------"
        nohup java -Xms256m -Xmx512m -Dfile.encoding=utf-8 -jar $AUTOSYS --spring.profiles.active=$DEPLOY_EVN  >log/autosys.log &
	echo "started"
        AUTOSYS_pid=`lsof -i:$AUTOSYS_port|grep 'LISTEN'|awk '{print $2}'` 
        until [ -n "$AUTOSYS_pid" ]
            do
              AUTOSYS_pid=`lsof -i:$AUTOSYS_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "AUTOSYS pid is $AUTOSYS_pid" 
        echo "---------AUTOSYS 启动成功-----------"
	echo "-------------------------------------"
	 }

function PA_TROL {
        ## 启动PATROL
        cd $BUSINESS_DIR
        echo "-------- PATROL 开始启动---------------"
        nohup java -Xms256m -Xmx512m -Dfile.encoding=utf-8 -jar $PATROL --spring.profiles.active=$DEPLOY_EVN >log/patrol.log &
	echo "started"
        PATROL_pid=`lsof -i:$PATROL_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$PATROL_pid" ]
            do
              PATROL_pid=`lsof -i:$PATROL_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "PATROL pid is $PATROL_pid"     
        echo "--------- PATROL 启动成功-----------"
	echo "---------------------------------------"
 	}

function  EQUIP_MANAGE {
        ## 启动EQUIPMANAGE
        cd $BUSINESS_DIR
        echo "-------- EQUIPMANAGE开始启动---------------"
        nohup java -Xms256m -Xmx516m -Dfile.encoding=utf-8  -jar $EQUIPMANAGE --spring.profiles.active=$DEPLOY_EVN >log/equipmanage.log &
	echo "started"
        EQUIPMANAGE_pid=`lsof -i:$EQUIPMANAGE_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$EQUIPMANAGE_pid" ]
            do
              EQUIPMANAGE_pid=`lsof -i:$EQUIPMANAGE_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "EQUIPMANAGE pid is $EQUIPMANAGE_pid"     
        echo "--------- EQUIPMANAGE 启动成功-----------"
	echo "---------------------------------------"
	}	



function  TRAINING_EXAM {
	 ## 启动TRAININGEXAM
         cd $BUSINESS_DIR
        echo "-------- TRAININGEXAM 开始启动---------------"
        nohup java  -Xms256m -Xmx516m -Dfile.encoding=utf-8 -jar $TRAININGEXAM --spring.profiles.active=$DEPLOY_EVN >log/trainingexam.log &
        echo "started"
        TRAININGEXAM_pid=`lsof -i:$TRAININGEXAM_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$TRAININGEXAM_pid" ]
            do
              TRAININGEXAM_pid=`lsof -i:$TRAININGEXAM_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "TRAININGEXAM pid is $TRAININGEXAM_pid"     
        echo "--------- TRAININGEXAM启动成功-----------"
        echo "---------------------------------------"
	
	}
	
function    KNOW_LEDGEBASE {
        ## 启动KNOWLEDGEBASE
        cd $BUSINESS_DIR
        echo "-------- KNOWLEDGEBASE 开始启动---------------"
        nohup java -Xms256m -Xmx516m -Dfile.encoding=utf-8 -jar $KNOWLEDGEBASE --spring.profiles.active=$DEPLOY_EVN >log/knowledgebase.log &
	echo "started"
        KNOWLEDGEBASE_pid=`lsof -i:$KNOWLEDGEBASE_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$KNOWLEDGEBASE_pid" ]
            do
              KNOWLEDGEBASE_pid=`lsof -i:$KNOWLEDGEBASE_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "KNOWLEDGEBASE pid is $KNOWLEDGEBASE_pid"    
        echo "---------KNOWLEDGEBASE 启动成功-----------"
	echo "------------------------------------"
     	}
	
	
function    DUTY_MODE {
	  ## 启动DUTYMODE
        cd $BUSINESS_DIR
        echo "-------- DUTYMODE开始启动---------------"
        nohup java -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $DUTYMODE --spring.profiles.active=$DEPLOY_EVN >log/dutymode.log &
	echo "started"
        DUTYMODE_pid=`lsof -i:$DUTYMODE_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$DUTYMODE_pid" ]
            do
              DUTYMODE_pid=`lsof -i:$DUTYMODE_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "DUTYMODE pid is $DUTYMODE_pid"    
        echo "---------DUTYMODE 启动成功-----------"
	echo "--------------------------------------"
	}

function J_PUSH {
        ## 启动JPUSH
        cd $BUSINESS_DIR
        echo "-------- JPUSH开始启动---------------"
        nohup  java -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $JPUSH --spring.profiles.active=$DEPLOY_EVN >log/jpush.log &
	echo "started"
        JPUSH_pid=`lsof -i:$JPUSH_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$JPUSH_pid" ]
            do
              JPUSH_pid=`lsof -i:$JPUSH_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "JPUSH pid is $JPUSH_pid"    
        echo "---------JPUSH 启动成功-----------"
	echo "--------------------------------------"
	}

function PRE_CONTROL {	
	## 启动PRECONTROL
        cd $BUSINESS_DIR
        echo "-------- PRECONTROL开始启动---------------"
        nohup java -Xms256m -Xmx516m -Dfile.encoding=utf-8 -jar $PRECONTROL --spring.profiles.active=$DEPLOY_EVN >log/precontrol.log &
	echo "started"
        PRECONTROL_pid=`lsof -i:$PRECONTROL_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$PRECONTROL_pid" ]
            do
              PRECONTROL_pid=`lsof -i:$PRECONTROL_port|grep 'LISTEN'|awk '{print $2}'`  
            done
        echo "PRECONTROL pid is $PRECONTROL_pid"    
        echo "---------PRECONTROL 启动成功-----------"
	echo "--------------------------------------"
	
    	 }	


###############################################STUDIO#############################################################################################

function GRAPH_3D {
        ## 启动 GRAPH3D
        cd $STUDIO_DIR
        echo "--------GRAPH3D 开始启动 ---------------"
        nohup java -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $GRAPH3D --spring.profiles.active=$DEPLOY_EVN >log/graph3d.log &
        echo "started"
        GRAPH3D_pid=`lsof -i:$GRAPH3D_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$GRAPH3D_pid" ]
            do
              GRAPH3D_pid=`lsof -i:$GRAPH3D_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "GRAPH3D pid is $GRAPH3D_pid"
        echo "---------GRAPH3D 启动成功-----------"
        echo "-------------------------------------"
                }
function GRAPH3D_stop {
        P_ID=`ps -ef | grep -w $GRAPH3D | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===GRAPH3D process not exists or stop success"
        else
            kill -9 $P_ID
            echo "GRAPH3D killed success"
        fi
}


function HY_BRID {
        ## 启动HYBRID
        cd $STUDIO_DIR
        echo "-------- HYBRID 开始启动---------------"
        nohup java  -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $HYBRID --spring.profiles.active=$DEPLOY_EVN >log/hybrid.log &
        echo "started"
        HYBRID_pid=`lsof -i:$HYBRID_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$HYBRID_pid" ]
            do
              HYBRID_pid=`lsof -i:$HYBRID_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "HYBRID pid is $HYBRID_pid"
        echo "--------- HYBRID 启动成功-----------"
        echo "---------------------------------------"
        }       
function HYBRID_stop {
        P_ID=`ps -ef | grep -w $HYBRID | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===HYBRID process not exists or stop success"
        else
            kill -9 $P_ID
            echo "HYBRID killed success"
        fi
}

function MOR_PHIC {
        ## 启动MORPHIC
        cd $STUDIO_DIR
        echo "-------- MORPHIC开始启动---------------"
        nohup java -Xms256m -Xmx256m -Dfile.encoding=utf-8  -jar $MORPHIC --spring.profiles.active=$DEPLOY_EVN >log/morphic &
        echo "started"
        MORPHIC_pid=`lsof -i:$MORPHIC_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$MORPHIC_pid" ]
            do
              MORPHIC_pid=`lsof -i:$MORPHIC_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "MORPHIC pid is $MORPHIC_pid"
        echo "--------- MORPHIC 启动成功-----------"
        echo "---------------------------------------"
        }
function MORPHIC_stop {
        P_ID=`ps -ef | grep -w $MORPHIC | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===MORPHIC process not exists or stop success"
        else
            kill -9 $P_ID
            echo "MORPHIC killed success"
        fi        
}


function STU_DIO {
        ## 启动 STUDIO
        cd $STUDIO_DIR
        echo "-------- STUDIO 开始启动---------------"
        nohup java  -Xms256m -Xmx256m -Dfile.encoding=utf-8 -jar $STUDIO --spring.profiles.active=$DEPLOY_EVN >log/studio.log &
        echo "started"
        STUDIO_pid=`lsof -i:$STUDIO_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$STUDIO_pid" ]
            do
              STUDIO_pid=`lsof -i:$STUDIO_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "STUDIO pid is $STUDIO_pid"
        echo "--------- STUDIO启动成功-----------"
        echo "---------------------------------------"
        }
function STUDIO_stop {
        P_ID=`ps -ef | grep -w $STUDIO | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===STUDIO process not exists or stop success"
        else
            kill -9 $P_ID
            echo "STUDIO killed success"
        fi
}


function MASS_MDM {
        ## 启动 MASSMDM
        cd $STUDIO_MASS_DIR
        echo "--------MASSMDM 开始启动--------------"
        nohup java -Xms256m -Xmx4096m -Dfile.encoding=utf-8 -jar $MASSMDM --spring.profiles.active=$DEPLOY_EVN >/dev/null &
        echo "started"
        MASSMDM_pid=`lsof -i:$MASSMDM_port|grep 'LISTEN'|awk '{print $2}'`
        until [ -n "$MASSMDM_pid" ]
            do
              MASSMDM_pid=`lsof -i:$MASSMDM_port|grep 'LISTEN'|awk '{print $2}'`
            done
        echo "MASSMDM pid is $MASSMDM_pid"
        echo "--------MASSMDM 启动成功--------------"
        echo "-------------------------------------"
        }
function MASSMDM_stop {
        P_ID=`ps -ef | grep -w $MASSMDM | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "===MASSMDM process not exists or stop success"
        else
            kill -9 $P_ID
            echo "MASSMDM killed success"
        fi
}




###################businessstop####################################################
function BGATEWAY_stop {
        P_ID=`ps -ef | grep -w $BGATEWAY | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===BGATEWAY process not exists or stop success"
        else
                kill -9 $P_ID
                echo "BGATEWAY killed success"
        fi
        }
function AUTOSYS_stop {	
        P_ID=`ps -ef | grep -w $AUTOSYS | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===AUTOSYS process not exists or stop success"
        else
                kill -9 $P_ID
                echo "AUTOSYS killed success"
        fi
        }
        
function PATROL_stop {	
        P_ID=`ps -ef | grep -w $PATROL | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===PATROL process not exists or stop success"
        else
                kill -9 $P_ID
                echo "PATROL killed success"
        fi
        }
        
function PATROL_stop {	
        P_ID=`ps -ef | grep -w $EQUIPMANAGE | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===EQUIPMANAGE process not exists or stop success"
        else
                kill -9 $P_ID
                echo "EQUIPMANAGE killed success"
        fi
        }

function TRAININGEXAM_stop {
        P_ID=`ps -ef | grep -w $TRAININGEXAM | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===TRAININGEXAM process not exists or stop success"
        else
                kill -9 $P_ID
                echo "TRAININGEXAM killed success"
        fi

        }

function KNOWLEDGEBASE_stop {
        P_ID=`ps -ef | grep -w $KNOWLEDGEBASE | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===KNOWLEDGEBASE process not exists or stop success"
        else
                kill -9 $P_ID
                echo "KNOWLEDGEBASE killed success"
        fi
        }
        
function DUTYMODE_stop {	
        P_ID=`ps -ef | grep -w $DUTYMODE  | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===DUTYMODE  process not exists or stop success"
        else
                kill -9 $P_ID
                echo "DUTYMODE  killed success"
        fi
        }
        
        
function JPUSH_stop {
        P_ID=`ps -ef | grep -w $JPUSH | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===JPUSH process not exists or stop success"
        else
                kill -9 $P_ID
                echo "JPUSH  killed success"
        fi
        }

function PRECONTROL_stop {
        P_ID=`ps -ef | grep -w $PRECONTROL | grep -v 'grep' | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
                echo "===PRECONTROL process not exists or stop success"
        else
                kill -9 $P_ID
                echo "PRECONTROL killed success"
        fi
        }

function ALL_stop {
        ###AMOS############
        EUREKA_stop
        TRACKING_stop
        PRIVILEGE_stop
        RULE_stop
        SYSTEMCTL_stop
        GATEWAY_stop
        DASHBOARD_stop
        IOTPLATFORM_stop
        WORKFLOW_stop
        echo -e "\e[32mAMOS关闭成功\e[0m"
        ######BUSINESS##########
        BGATEWAY_stop
        AUTOSYS_stop
        PATROL_stop
        PATROL_stop
        TRAININGEXAM_stop
        KNOWLEDGEBASE_stop
        DUTYMODE_stop
        JPUSH_stop
        PRECONTROL_stop
        echo -e "\e[32mBUSINESS关闭成功\e[0m"
        ######STUDIO#############
        HYBRID_stop
        MASSMDM_stop
        STUDIO_stop
        GRAPH3D_stop
        MORPHIC_stop
        echo -e "\e[32mSTUDIO关闭成功\e[0m"
        }
ALL_SERVICE=( $EUREKA $TRACKING $PRIVILEGE $RULE $SYSTEMCTL $GATEWAY $DASHBOARD $IOTPLATFORM $Workflow   $BGATEWAY $AUTOSYS $PATROL $EQUIPMANAGE $TRAININGEXAM $KNOWLEDGEBASE $DUTYMODE $JPUSH $PRECONTROL     $GRAPH3D $HYBRID $MORPHIC $STUDIO $MASSMDM )
###IFS=:    bash shell会将下列字符当作字段分隔符：空格、制表符、换行符
function CHECK_SERVICE {

        # while read SERVICE_total
        # do
        #         ps -aux | grep $SERVICE_total  && continue || echo  -e  "\e[31m \e[05m$SERVICE_total 没有启动 \e[0m" 
        # done < $ALL_SERVICE
        
        #  for i in ${ALL_SERVICE[@]}
        #  do
        #        if  [ ` ps -aux | grep -c "$i" `  -eq 2 ];then  #grep -c 统计出匹配到的行数
        #              :  
        #          else
        #                 echo  -e  "\e[31m $i 没有启动 \e[0m" 
        #         fi
        #  done
        for i in ${ALL_SERVICE[@]}
        do
                ps -ef |grep "$i" |grep -v "grep" >/dev/null 2>&1 || echo -e "\e[31m  \e[05m $i 没有启动 \e[0m"  |tee /tmp/tmp.txt
        done 
        
        test -s /tmp/tmp.txt || echo -e "\e[32m 所有服务都已经在线运行  \e[0m" 
        test -e /tmp/tmp.txt  && rm /tmp/tmp.txt
} 
##############################################
function main {
     
        PS3="需要启动的服务"
        SERVICE=( ALLSTART ALLSTOP    CHECK QUIT EUREKA TRACKING PRIVILEGE RULE SYSTEMCTL GATEWAY DASHBOARD IOTPLATFORM Workflow  BGATEWAY  AUTOSYS  PATROL EQUIPMANAGE TRAININGEXAM KNOWLEDGEBASE DUTYMODE JPUSH  PRECONTROL GRAPH3D HYBRID MORPHIC STUDIO MASSMDM )
        select  var in   ${SERVICE[@]}
        do        
                case $var in
                EUREKA)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                EURE_KA
                        elif [[ $operation == [Kk]* ]];then
                                EUREKA_stop
                        else
                                continue
                        fi
                        ;; 

                TRACKING)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                TRACK_ING
                        elif [[ $operation == [Kk]* ]];then
                                TRACKING_stop
                        else
                                continue
                        fi
                        ;;
                PRIVILEGE)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                PRI_VILEGE
                        elif [[ $operation == [Kk]* ]];then
                                PRIVILEGE_stop
                        else
                                continue
                        fi
                        ;;
                RULE)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                RU_LE
                        elif [[ $operation == [Kk]* ]];then
                                RULE_stop
                        else
                                continue
                        fi
                        ;;
                SYSTEMCTL)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                SYS_TEMCTL
                        elif [[ $operation == [Kk]* ]];then
                                SYSTEMCTL_stop
                        else
                                continue
                        fi
                        ;; 
                GATEWAY)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                GATE_WAY
                        elif [[ $operation == [Kk]* ]];then
                                GATEWAY_stop
                        else
                                continue
                        fi
                        ;;  
                DASHBOARD)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                DASH_BOARD
                        elif [[ $operation == [Kk]* ]];then
                                DASHBOARD_stop
                        else
                                continue
                        fi
                        ;;  
                IOTPLATFORM) 
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                IOT_PLATFORM
                        elif [[ $operation == [Kk]* ]];then
                                IOTPLATFORM_stop
                        else
                                continue
                        fi
                        ;; 
                Workflow)        
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                WORK_FLOW
                        elif [[ $operation == [Kk]* ]];then
                                WORKFLOW_stop
                        else
                                continue
                        fi
                        ;; 

                BGATEWAY)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                BGATE_WAY
                        elif [[ $operation == [Kk]* ]];then
                                BGATEWAY_stop
                        else
                                continue
                        fi
                        ;;	

                AUTOSYS)
                        echo -n "输入你的操作:start/kill: "
                        read operation  
                        if [[ $operation == [sS]* ]];then
                                AUTO_SYS
                        elif [[ $operation == [Kk]* ]];then
                                AUTOSYS_stop
                        else
                                continue
                        fi
                        ;;
                
                PATROL)
                echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                PA_TROL
                        elif [[ $operation == [Kk]* ]];then
                                PATROL_stop
                        else
                                continue
                        fi
                        ;;


                EQUIPMANAGE)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                EQUIP_MANAGE
                        elif [[ $operation == [Kk]* ]];then
                                EQUIPMANAGE_stop
                        else
                                continue
                        fi
                        ;;



                TRAININGEXAM)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                        TRAINING_EXAM
                        elif [[ $operation == [Kk]* ]];then
                                TRAININGEXAM_stop
                        else
                                continue
                        fi
                        ;;
                        

                KNOWLEDGEBASE)
                        
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                KNOW_LEDGEBASE
                        elif [[ $operation == [Kk]* ]];then
                                KNOWLEDGEBASE_stop
                        else
                                continue
                        fi
                        ;;


                DUTYMODE)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                DUTY_MODE
                        elif [[ $operation == [Kk]* ]];then
                                DUTYMODE_stop
                        else
                                continue
                        fi
                        ;;
                        

                JPUSH)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                        J_PUSH
                        elif [[ $operation == [Kk]* ]];then
                                JPUSH_stop
                        else
                                continue
                        fi
                        ;;	

                PRECONTROL)	
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                PRE_CONTROL
                        elif [[ $operation == [Kk]* ]];then
                                PRECONTROL_stop
                        else
                                continue
                        fi
                        ;;


                GRAPH3D)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                GRAPH_3D
                        elif [[ $operation == [Kk]* ]];then
                                GRAPH3D_stop
                        else
                                continue
                        fi
                        ;;                
                HYBRID)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                HY_BRID
                        elif [[ $operation == [Kk]* ]];then
                                HYBRID_stop
                        else
                                continue
                        fi
                        ;; 
                MORPHIC) 
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                MOR_PHIC
                        elif [[ $operation == [Kk]* ]];then
                                MORPHIC_stop
                        else
                                continue
                        fi
                        ;;
                STUDIO) 
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                STU_DIO
                        elif [[ $operation == [Kk]* ]];then
                                STUDIO_stop
                        else
                                continue
                        fi
                        ;;
                MASSMDM)
                        echo -n "输入你的操作:start/kill: "
                        read operation
                        if [[ $operation == [sS]* ]];then
                                MASS_MDM
                        elif [[ $operation == [Kk]* ]];then
                                MASSMDM_stop
                        else
                                continue
                        fi
                        ;;

                ALLSTART)
                        read -p "输入要启动的服务: amos business studio [可以只写首字母a,b,s每次启动一个服务] " MODULE
                        if [[ $MODULE == [Aa]* ]]; then
                                EURE_KA; TRACK_ING; PRI_VILEGE; RU_LE; SYS_TEMCTL; GATE_WAY; DASH_BOARD; IOT_PLATFORM;  WORK_FLOW
                        elif [[ $MODULE == [Bb]* ]]; then
                                BGATE_WAY;AUTO_SYS;PA_TROL;EQUIP_MANAGE;TRAINING_EXAM;KNOW_LEDGEBASE;DUTY_MODE;J_PUSH;PRE_CONTROL
                        elif [[ $MODULE == [Ss]* ]]; then
                                GRAPH_3D; HY_BRID;  MOR_PHIC; STU_DIO; MASS_MDM
                        else
                                echo "输入错误，再来"    
                        fi                  
                        ;;
                ALLSTOP)
                        ALL_stop	
                        ;;
                CHECK)
                        CHECK_SERVICE;;
                QUIT)

                        exit
                        ;;
                *)
                        echo "输入错误重新输入："
                        continue
                        ;;
                esac
        done
        }

#############################################@@@MAIN@@@@####################################################################
echo "############业务服务启动脚本##########"
if [ $? -eq 0 ];then
		echo "----环境变量配置成功----"
	else
		echo "----检查基础配置文件JAR-path"
fi


list=($BGATEWAY $AUTOSYS $PATROL $EQUIPMANAGE $TRAININGEXAM $KNOWLEDGEBASE $DUTYMODE $JPUSH $PRECONTROL)
for var in ${list[@]}
        do
		cd $BUSINESS_DIR
                if [ -e $var ];then
                        echo -n ""
                else
                        echo ">_<$var 文件配置错误，请检查JAR-path.sh配置文件" 
                        exit
                fi
        done
echo "^-^业务jar包检查无误,基础环境配置无误，准备启动服务"

list_amos=($EUREKA $TRACKING $PRIVILEGE $RULE $SYSTEMCTL $GATEWAY $DASHBOARD $IOTPLATFORM $Workflow )
for var in  ${list_amos[@]} 
do
                cd $AMOS_DIR
                if [ -e $var ];then
                        echo -n ""
                else
                        echo ">_<$var 文件配置错误，请检查JAR-path.sh配置文件" 
                        exit
                fi
done 
echo  "^-^amos平台jar包检查无误,基础环境配置无误，准备启动服务"

list_studio=( $GRAPH3D $HYBRID $MORPHIC $STUDIO  )
for var in ${list_studio[@]}
do      
                cd $STUDIO_DIR
                if [ -e $var ];then
                        echo -n ""
                else
                        echo ">_<$var 文件配置错误，请检查JAR-path.sh配置文件" 
                        exit
                fi
done
echo  "^-^studio平台jar包检查无误,基础环境配置无误，准备启动服务"

list_mass=( $MASSMDM )
for var in $list_mass
do      
                cd $STUDIO_MASS_DIR
                if [ -e $var ];then
                        echo -n ""
                else
                        echo ">_<$var 文件配置错误，请检查JAR-path.sh配置文件" 
                        exit
                fi
done 
echo  "^-^MASS服务jar包检查无误,基础环境配置无误，准备启动服务"


main
   
exit 0
