#!/usr/bin/env python
#coding:utf8

import argparse
import sys
import json
def list():
    r={}
    h=['192.168.31.'+ str(i) for i in (101,102,103)]
    hosts={'hosts':h}  # 必须是hosts
    r['k8s']=hosts
    return  json.dumps(r,indent=4)
 
def hosts(name):
    r={'ansible_ssh_pass':'abc123_'}
    cpis=dict(r.items())
    return json.dumps(cpis)
 
if __name__=='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument('-l','--list',help='host list',action='store_true')
    parser.add_argument('-H','--host',help='hosts vars')
    args=vars(parser.parse_args())
    if args['list']:
        print list()
    elif args['host']:
        print hosts(args['host'])
    else:
        parser.print_help()