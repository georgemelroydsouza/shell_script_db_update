#!/bin/bash

# ***********************************
#
#
# Created: George Melroy D'Souza
# If you want to run it in Windows download Cygwin
# Accept the params ./sql.sh db_folder db_username db_hostname db_name db_password
#
#
# ***********************************

# Set dirs
set -o errexit # exit when command fails
set -o pipefail # exist when i want it to fail
set -o nounset # exit when script tries to use undeclared variables

__db_folder=$1;
__db_username=$2;
__db_name=$4;
__db_hostname=$3;
__db_password=$5;

# Validate the params 
if [ "${__db_folder}" == "" ] || [ "${__db_username}" == "" ] || [ "${__db_hostname}" == "" ] || [ "${__db_name}" == "" ]; then
	echo "-f 'Folder' or -u 'USERNAME' or -h 'HOSTNAME' -d 'DATABASE' -p 'PASSWORD' are undefined";
	exit 1
fi

credentialsFile=/var/www/goj/mysql-credentials.cnf
echo "[client]" > $credentialsFile
echo "user=${__db_username}" >> $credentialsFile
echo "password=${__db_password}" >> $credentialsFile
echo "host=${__db_hostname}" >> $credentialsFile

cd ${__db_folder};
for dbFilename in `ls | egrep -o "[0-9]"+"(.)"+ | sort -V`; do
	
	dbVersion=$(mysql --defaults-extra-file=${credentialsFile} ${__db_name} -s -e "SELECT version FROM versiontable LIMIT 1" | cut -f1)
	currentVersion=$((${dbVersion} + 0))
	
	fileVersion=$(echo ${dbFilename} | sed 's/[^0-9]*//g')
	calculatedFileVersion=$((${fileVersion} + 0))
	
	if [ "${currentVersion}" -lt "${calculatedFileVersion}" ]; then
		
		# line below runs the sql into the database
		#mysql --defaults-extra-file=${credentialsFile} ${__db_name} < ${dbFilename}
		
		mysql --defaults-extra-file=${credentialsFile} ${__db_name} -e "UPDATE versiontable SET version=${fileVersion} WHERE version=${currentVersion}"
		mysql --defaults-extra-file=${credentialsFile} ${__db_name} -e "INSERT INTO sql_scripts SET scriptname='${dbFilename}'"
		
		echo "Success: Triggered ${dbFilename}"
		
	else
		
		echo "Notice: Ignoring file ${dbFilename} as current version stored in database is ${dbVersion}"
		
	fi
done

