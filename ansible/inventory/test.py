#!/usr/bin/env python
# coding=utf-8
import json
host1ip = ['192.168.31.101']
host2ip = ['192.168.31.102','192.168.31.103']
group = 'k8s-master'
group2 = 'k8s-nodes'
hostdata = {group:{"hosts":host1ip},group2:{"hosts":host2ip}}
print (json.dumps(hostdata,indent=4))

#ansible -i test.py all -m ping -vvv