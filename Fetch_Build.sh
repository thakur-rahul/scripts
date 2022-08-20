#!/bin/sh

WORKSPACE=/home/toor2/env_prod/projects/logon
PROJECT_NAME=tr-bo-logon
PROJECT_DIR=${WORKSPACE}/${PROJECT_NAME}
StashURL=https://github.com/jantikarg/NodeJSSamples.git
LOG_DIR=/home/toor2/env_prod/projects/logon/logs
LOG_FILE=${LOG_DIR}/tr-bo-logon.log

: > ${LOG_FILE}

build_failure()
{
Message=$1
echo `date` "${Message}" >> ${LOG_FILE}
}

fetch_Code()
{    
        cd ${WORKSPACE}
        git clone ${StashURL}
		if [ $? -eq 0 ];
		then
			cd ${PROJECT_NAME}
			if [ $? -eq 0 ];
			then
				npm install
				if [ $? -eq 0 ];
				then
					npm install
					if [ $? -eq 0 ];
					then
						npm build
					else
						Message=`echo "BUILD FAILURE : NPM BUILD failed for ${PROJECT_NAME}"`
						build_failure "${Message}" 
				fi
				else
					Message=`echo "INSTALL FAILURE : NPM INSTALL FAILURE"`
					build_failure "${Message}" 
				fi
			else
				Message=`echo "FETCH FAILURE : Project folder ${PROJECT_NAME} doesn't exists"`
				build_failure "${Message}" 
			fi	
		else
			Message=`echo "FETCH FAILURE : cloning failed for ${PROJECT_NAME}"`
            build_failure "${Message}" 
		fi
}

echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}
echo `date` ":INFO: SCRIPT STARTED" >> ${LOG_FILE}
echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}

mkdir -p $WORKSPACE

cd ${WORKSPACE}
NOW_DATE="$(date +'%d%m%Y%H%M%s')"
mv ${PROJECT_NAME} ${PROJECT_NAME}_${NOW_DATE}

fetch_Code

echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}
echo `date` ":INFO: SCRIPT COMPLETED" >> ${LOG_FILE}
echo "+++++++++++++++++++++++++++" >> ${LOG_FILE}