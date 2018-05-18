#!/usr/bin/env python

# To avoid issues between Windows and Mac/Linux, consider the following:
# 1) avoid absolute paths
# 2) avoid having slashes anywhere ("\" or "/")
# 3) use os.cwd() and os.path.join

import os

maindir = os.getcwd()
path_to_file = os.path.join(maindir,'my','fake','path','fakefile.txt')
print path_to_file
