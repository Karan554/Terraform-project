#Change your Public IP everytime you log off or disconnect from internet into your vars
GitHub Repo

https://github.com/gsweene2/terraform-starter-repo

AWS Setup:
aws configure
aws configure list-profiles

Commands:
terraform init
terraform plan -var-file="vars/dev-east.tfvars"
terraform apply -var-file="vars/dev-east.tfvars"
terraform destroy -var-file="vars/dev-east.tfvars"
chmod 400 <keypair>
ssh -i <keypair> ec2-user@<public_dns>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

To mount EBS volume
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html

sudo file -s /dev/xvdf
sudo lsblk -f
sudo mkfs -t xfs /dev/xvdf    #define type of filesystem you want
sudo mkdir /data
sudo mount /dev/xvdf /data




Goals
ebs volume create krna in terraform in same subnet as instance
role create and attach to instance for accessing the ebs 
all yaml files ko server me daalna
ebs volume ki id ko apni yaml file me update krna.. for that we need python installed jo data.json file se access kre data
script create krna that will run all the yaml files in order
script run krna


then apni wordpress site ko kubernetes me daalna


#!/usr/bin/python3.8

import json
with open('/root/data.json') as f:
        data = json.load(f)
        for i in data['Volumes']:
          a = i["Size"]
          if a == 10:
            ID = i["VolumeId"]
            print(ID)
f.close()



#!/usr/bin/python3.8

import yaml
import sys

n = str(sys.argv[1])
fname = "/root/pv.yaml"
file = open(fname, 'r')
documents = yaml.load(file)
print(documents)
#documents[0]['spec'][0]['awsElasticBlockStore']['volumeID'] = 'Vol'
documents['spec']['awsElasticBlockStore']['volumeID'] = n

with open(fname, 'w') as yaml_file:
    yaml_file.write( yaml.dump(documents, default_flow_style=False))
yaml_file.close()



Issues:
Wordpress is getting size error in importing the wordpress local site. php file ko edit krna hai
plugin
 Tuxedo Big File Uploads 
 All in one 
 import downloaded plugin
volumes is not working properly check that: #its setuo is done correcctly just the plugins are not coming while pod is deleted. but post alwasys restains

https://www.terraform.io/language/resources/provisioners/file

https://kiranworkspace.com/how-to-increase-the-512mb-limit-in-all-in-one-wp-migration/

536870912 * 5


Unable to open file for reading. File: /var/www/html/wp-content/plugins/all-in-one-wp-migration/storage/b320c4hr0f1a/localhost-word2-20220713-165041-yckyyr.wpress



Advanced:
Kubernets ka autoscaling feature use
Load balancer use krke