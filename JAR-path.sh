#!/bin/bash
## 部署环境 
export DEPLOY_EVN=dev
export DEPLOY_QA=qa


## amos所有服务的jar包名称 使用qa配置文件（iot和workflow使用dev）
export EUREKA=amos-server-eurka-1.4.7-SNAPSHOT.jar
export TRACKING=amos-server-tracking-1.4.7-SNAPSHOT.jar
export PRIVILEGE=amos-api-privilege-1.4.7-SNAPSHOT.jar
export RULE=amos-api-rule-1.4.7-SNAPSHOT.jar
export SYSTEMCTL=amos-api-systemctl-1.4.7-SNAPSHOT.jar
export GATEWAY=amos-server-gateway-1.4.8-SNAPSHOT.jar
export DASHBOARD=amos-server-dashboard-1.4.7-SNAPSHOT.jar
export IOTPLATFORM=amos-api-iot-platform-1.4.7.jar
export Workflow=amos-api-workflow-1.0.0.jar
export EUREKA_port=10001
export TRACKING_port=10002
export PRIVILEGE_port=30001
export RULE_port=30006
export SYSTEMCTL_port=30002
export GATEWAY_port=10005
export DASHBOARD_port=10004
export IOTPLATFORM_port=33001
export Workflow_port=30040


## 业务所有服务的jar包名称及端口使用dev配置文件
export BGATEWAY=Autosys-Gateway-1.1.0-SNAPSHOT.jar
export AUTOSYS=Autosys-FireAutoSysStart-2.0.6.jar
export PATROL=Autosys-PatrolStart-3.0.6.jar
export EQUIPMANAGE=Autosys-EquipManageServer-1.0.0.jar
export TRAININGEXAM=Autosys-TrainingExamServer-1.2.8.jar
export KNOWLEDGEBASE=Autosys-Knowledgebase-1.0.1.9.jar
export DUTYMODE=Autosys-DutyModelStart-1.0.0.jar
export JPUSH=Autosys-JpushStart-1.0.0.jar
export PRECONTROL=Autosys-PrecontrolServer-1.0.0.jar
export DATAPROCESS=Autosys-FireDataProcessServer-1.0.0.jar #3.0.1.2新业务
export RENREN=Autosys-Renren-admin.jar #3.0.1.2新业务
export BGATEWAY_port=10007
export AUTOSYS_port=8085
export PATROL_port=8082
export EQUIPMANAGE_port=8100
export TRAININGEXAM_port=8101
export KNOWLEDGEBASE_port=30019
export DUTYMODE_port=9200
export JPUSH_port=7800
export PRECONTROL_port=8060
export DATAPROCESS_port=8500  #3.0.1.2新业务
export RENREN_port=8080    #3.0.1.2新业务


## studio所有服务的jar包名称，使用dev配置
export GRAPH3D=visual-api-graph3d-1.5.0-SNAPSHOT.jar
export HYBRID=visual-api-hybrid-1.5.2.1.jar
export MORPHIC=visual-api-morphic-1.5.3-SNAPSHOT.jar
export STUDIO=visual-api-studio-1.5.1.jar
export MASSMDM=mass-application-mdm-1.0.12-SNAPSHOT.jar
export GRAPH3D_port=30103
export HYBRID_port=30105
export MORPHIC_port=30102
export STUDIO_port=30101
export MASSMDM_port=30009
