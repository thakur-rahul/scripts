#!/bin/sh
# Pass below number parameter as per the requirement
# 1 -> PULL CODE
# 2 -> PULL CODE + INSTALL
# 3 -> PULL CODE + INSTALL + BUILD
# 0 -> STOP + PULL CODE + INSTALL + BUILD + START


WORKSPACE=/home/toor2/env_prod/projects/logon
PROJECT_NAME=tr-bo-logon
PROJECT_DIR=${WORKSPACE}/${PROJECT_NAME}
#StashURL=https://Lexius7@bitbucket.org/trends-sight/tr-bo-logon.git
LOG_DIR=/home/toor2/env_prod/logs
LOG_FILE=${LOG_DIR}/tr-bo-logon.log

: > ${LOG_FILE}

build_failure()
{
Message=$1
echo `date` "${Message}" >> ${LOG_FILE}
}

pull()
{
    git pull
	if [ $? -eq 0 ];
	then
		Message=`echo "CODE PULL SUCCESS : ${PROJECT_NAME} is successfully SYNCED"`
		build_failure "${Message}" 
	else
		Message=`echo "PULL FAILURE : GIT PULL FAILED FOR ${PROJECT_NAME}"`
        build_failure "${Message}"
		exit 1	
	fi
}

install()
{
	npm install
	if [ $? -eq 0 ];
	then
		Message=`echo "INSTALL SUCCESS : ${PROJECT_NAME} is successfully installed"`
		build_failure "${Message}" 
	else
		Message=`echo "INSTALL FAILURE : INSTALED FAILED FOR ${PROJECT_NAME}"`
        build_failure "${Message}"
		exit 1	
	fi
}

build()
{
	npm build
	if [ $? -eq 0 ];
	then
		Message=`echo "BUILD SUCCESS : ${PROJECT_NAME} is build successfully"`
		build_failure "${Message}" 
	else
		Message=`echo "BUILD FAILURE : BUILD FAILED FOR ${PROJECT_NAME}"`
        build_failure "${Message}"
		exit 1	
	fi	
}

pm2_stop()
{
	pm2 stop ${PROJECT_NAME}
	if [ $? -eq 0 ];
	then
		Message=`echo "STOPPED SUCCESS : ${PROJECT_NAME} is stopped successfully"`
		build_failure "${Message}" 
	else
		Message=`echo "STOPPED FAILURE : STOP FAILED FOR ${PROJECT_NAME}"`
        build_failure "${Message}"
	fi	
}

pm2_start()
{
	pm2 start app.js --name \""${PROJECT_NAME}"\"
	if [ $? -eq 0 ];
	then
		Message=`echo "START SUCCESS : ${PROJECT_NAME} is started successfully"`
		build_failure "${Message}" 
	else
		Message=`echo "START FAILURE : START FAILED FOR ${PROJECT_NAME}"`
        build_failure "${Message}" 
		exit 1
	fi	
}

echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}
echo `date` ":INFO: SCRIPT STARTED" >> ${LOG_FILE}
echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}

mkdir -p ${WORKSPACE}
mkdir -p ${LOG_DIR}

case "$1" in
	0)
		cd ${PROJECT_DIR}
		echo "********************************************************"
		echo `date` ":INFO: STOPPING APPLICATION" >> ${LOG_FILE}
		pm2_stop >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: APPLICATION STOPPED" >> ${LOG_FILE}
	
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL STARTED" >> ${LOG_FILE}
		pull >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL COMPLETED" >> ${LOG_FILE}
		
		echo "********************************************************"
		echo `date` ":INFO: INSTALL STARTED" >> ${LOG_FILE}
		install >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: INSTALL COMPLETED" >> ${LOG_FILE}
		
		echo "********************************************************"
		echo `date` ":INFO: BUILD STARTED" >> ${LOG_FILE}
		build >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: BUILD PULL COMPLETED" >> ${LOG_FILE}
		
		echo "********************************************************"
		echo `date` ":INFO: STARTING APPLICATION" >> ${LOG_FILE}
		pm2_start >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: APPLICATION STARTED" >> ${LOG_FILE}
	;;
	1)
		cd ${PROJECT_DIR}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL STARTED" >> ${LOG_FILE}
		pull >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL COMPLETED" >> ${LOG_FILE}
	;;
	2)
		cd ${PROJECT_DIR}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL STARTED" >> ${LOG_FILE}
		pull >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL COMPLETED" >> ${LOG_FILE}
		
		echo "********************************************************"
		echo `date` ":INFO: INSTALL STARTED" >> ${LOG_FILE}
		install >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: INSTALL COMPLETED" >> ${LOG_FILE}
	;;
	3)
		cd ${PROJECT_DIR}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL STARTED" >> ${LOG_FILE}
		pull >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: GIT PULL COMPLETED" >> ${LOG_FILE}
		
		echo "********************************************************"
		echo `date` ":INFO: INSTALL STARTED" >> ${LOG_FILE}
		install >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: INSTALL COMPLETED" >> ${LOG_FILE}
		
		echo "********************************************************"
		echo `date` ":INFO: BUILD STARTED" >> ${LOG_FILE}
		build >> ${LOG_FILE}
		echo "********************************************************"
		echo `date` ":INFO: BUILD PULL COMPLETED" >> ${LOG_FILE}
esac

echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}
echo `date` ":INFO: SCRIPT COMPLETED" >> ${LOG_FILE}
echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}