#!/bin/bash

ansible_url="http://stage-dfs-vwork.company.xyz:80/software/ansible_2.7.5-1ppa~trusty_all.deb"
ansible_deb_name="ansible_2.7.5-1ppa~trusty_all.deb"
download_path="/root/software"

main() {
	# mkdir /root/software
	if [ ! -d $download_path ]; then
		mkdir -p $download_path
	fi

	cd $download_path

	# install python dependencies
	apt-get update
	apt-get install software-properties-common

	# download ansible
	wget ${ansible_url}
	if [ $? -eq 0 ]; then
		echo "download success"
		dpkg -i $ansible_deb_name
	else
	  echo "download failed"
	fi

	# please check using:
	`ansible --version`
}


main


# ansible document install guide:
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-ubuntu


## Issues:
# Issue 1:
# Reading package lists... Done
# Building dependency tree       
# Reading state information... Done
# You might want to run 'apt-get -f install' to correct these:
# The following packages have unmet dependencies:
# ansible : Depends: python-jinja2 but it is not going to be installed
#           Depends: python-yaml but it is not going to be installed
#           Depends: python-paramiko but it is not going to be installed
#           Depends: python-httplib2 but it is not going to be installed
#           Depends: python-six but it is not going to be installed
#           Depends: python-crypto (>= 2.6) but it is not going to be installed
#           Depends: python-setuptools but it is not going to be installed
#           Depends: sshpass but it is not going to be installed

# apt-get -f install
# then run shell against