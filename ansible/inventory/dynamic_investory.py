#!/usr/bin/env python
#coding:utf8
import json
import sys
 
def all():
    info_dict = {
    "all":[
        "192.168.31.101",
        "192.168.31.102"]
    }
    print(json.dumps(info_dict,indent=4))
 
def group():
    host1 = ['192.168.31.101']
    host2 = ['192.168.31.102','192.168.31.103']
    group1 = 'k8s-master'
    group2 = 'k8s-nodes'
    hostdata = {
        group1:{"hosts":host1},
        group2:{"hosts":host2}
    }
    print(json.dumps(hostdata,indent=4))
 
def host(ip):
    info_dict = {
        "192.168.31.101": {
            "ansible_ssh_host":"192.168.31.101",
            "ansible_ssh_port":22,
            "ansible_ssh_user":"root",
            "ansible_ssh_pass":"123457"
        },
        "10.10.0.109": {
            "ansible_ssh_host":"10.10.0.109",
            "ansible_ssh_port":22,
            "ansible_ssh_user":"root",
            "ansible_ssh_pass":"xxxx"
        }
    }
    print(json.dumps(info_dict,indent=4))
 
if len(sys.argv) == 2 and (sys.argv[1] == '--list'):
     group()
elif len(sys.argv) == 3 and (sys.argv[1] == '--host'):
    host(sys.argv[2])
else:
    print("Usage: %s --list or --host <hostname>" % sys.argv[0])
    sys.exit(1)

#ansible -i dynamic_investory.py all -m ping -vvv