#!/bin/bash
#set -e

logInfoFile="info.log"
user=user
password=abc123_

function write_log() {
	echo "[$1] - $2" >> ${logInfoFile}
}

function check_command() {
	command -v "$1" >/dev/null 2>&1
}

# Check whether ssh service is enabled.
if check_command ssh-keygen; then
	echo "`date +%Y-%m-%d,%H:%M:%S` ssh-keygen command is available."
	write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen command is available."
else
	echo "`date +%Y-%m-%d,%H:%M:%S` ssh-keygen command is not available, please check whether ssh service is enabled."
    write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen command is not available, please check whether ssh service is enabled."
	exit 127
fi

if [[ $? -ne 127 ]]; then
	# Generate ssh key.
	if [ ! -r ${HOME}/.ssh/id_rsa_devops.pub ]; then
		ssh-keygen -t rsa -f ~/.ssh/id_rsa_devops -N "" -q

		if [[ $? -eq 0 ]]; then
		    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen success"
			write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen success"
		else
		    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen failed"
			write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen failed"
		fi
	fi

	if [ -r ${HOME}/.ssh/id_rsa_devops.pub ]; then
		# Copy public key to other server.
		echo "################`date +%Y-%m-%d,%H:%M:%S` START TO DO SSH-COPY-ID ACTION.##############"			
		cat hostsname.txt | awk '{print $0}'| while read ip user pwd; do	   
		sshpass -p${pwd} ssh-copy-id -f -i ${HOME}/.ssh/id_rsa_devops.pub -o StrictHostKeyChecking=no ${user}@${ip}  2>/dev/null
		if [ $? -eq 0 ]; then
		    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${ip} success."
		    write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${ip} success."
		else
			echo `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${ip} failed."
			write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${ip} failed."
		fi				
		done
		echo "#################################`date +%Y-%m-%d,%H:%M:%S` END...#########################"
		
	fi
fi