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
	if [ ! -r ${HOME}/.ssh/id_rsa-ops.pub ]; then
		ssh-keygen -t rsa -f ~/.ssh/id_rsa-ops -N "" -q

		if [[ $? -eq 0 ]]; then
		    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen success"
			write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen success"
		else
		    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen failed"
			write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-keygen failed"
		fi
	fi

	if [ -r ${HOME}/.ssh/id_rsa-ops.pub ]; then
		# Copy public key to other server.
		if [ -f server-list.txt ]; then
		    echo "################`date +%Y-%m-%d,%H:%M:%S` START TO DO SSH-COPY-ID ACTION.##############"
			for server in `cat server-list.txt`;  
			do 			    
				sshpass -p${password} ssh-copy-id -i ${HOME}/.ssh/id_rsa-ops.pub  -o StrictHostKeyChecking=no ${user}@${server}  

				if [ $? -eq 0 ]; then
				    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${server} success."
					write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${server} success."
				else
				    echo `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${server} failed."
					write_log `date +%Y-%m-%d,%H:%M:%S` "ssh-copy-id to server ${server} failed."
				fi				
			done
			echo "#################################`date +%Y-%m-%d,%H:%M:%S` END...#########################"
		else
		    echo `date +%Y-%m-%d,%H:%M:%S` "No server-list.txt file."
			write_log `date +%Y-%m-%d,%H:%M:%S` "No server-list.txt file."
		fi
	fi
fi