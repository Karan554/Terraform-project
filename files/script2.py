#!/usr/bin/python3.8

import yaml
import sys

n = str(sys.argv[1])
fname = "/home/ubuntu/mysql-persistent-volume.yaml"
file = open(fname, 'r')
documents = yaml.load(file)
print(documents)
#documents[0]['spec'][0]['awsElasticBlockStore']['volumeID'] = 'Vol'
documents['spec']['awsElasticBlockStore']['volumeID'] = n

with open(fname, 'w') as yaml_file:
    yaml_file.write( yaml.dump(documents, default_flow_style=False))
yaml_file.close()
