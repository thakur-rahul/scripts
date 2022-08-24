#	This script will pull the code and install the requirements
#
#!/bin/sh

WORKSPACE=/home/toor2/env_prod/projects/logon
PROJECT_NAME=
PROJECT_DIR=${WORKSPACE}/${PROJECT_NAME}
StashURL=
LOG_DIR=${WORKSPACE}/logs
LOG_FILE=${LOG_DIR}/{PROJECT_NAME}.log

: > ${LOG_FILE}

build_failure()
{
Message=$1
echo `date` "${Message}" >> ${LOG_FILE}
}

pull_install()
{    
        cd ${PROJECT_DIR}
        git pull
		if [ $? -eq 0 ];
		then
			pip3 install -r requirements.txt
			if [ $? -eq 0 ];
			then
				Message=`echo "PROJECT SUCCESS : ${PROJECT_NAME} is successfully installed"`
				build_failure "${Message}" 
			else
				Message=`echo "PROJECT FAILED : Failed to INSTALL ${PROJECT_NAME}"`
				build_failure "${Message}" 
			fi	
		else
			Message=`echo "PULL FAILURE : GIT PULL FAILED FOR ${PROJECT_NAME}"`
            build_failure "${Message}" 
		fi
}

echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}
echo `date` ":INFO: SCRIPT STARTED" >> ${LOG_FILE}
echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}

mkdir -p ${WORKSPACE}

pull_install

echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}
echo `date` ":INFO: SCRIPT COMPLETED" >> ${LOG_FILE}
echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}