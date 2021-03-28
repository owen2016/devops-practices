#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time    : 2018-12-18 15:16
# @Author  : opsonly
# @Site    : 
# @File    : opsUse.py
# @Software: PyCharm

import os

dir = "/var/www/html/EnjoyCarApi/"
if os.path.isdir(dir):
    print('%s is a dir' % dir)
else:
    print('%s is not a dir' % dir)
