#!/bin/bash

#t2.medium 

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-get install docker.io -y
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
sudo apt install conntrack
sudo systemctl status kubelet
sudo systemctl stop kubelet
cd /tmp
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.2.3/cri-dockerd-0.2.3.amd64.tgz
tar xvf cri-dockerd-0.2.3.amd64.tgz
cd cri-dockerd
sudo mv cri-dockerd /usr/local/bin/
cri-dockerd --version
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo mv cri-docker.socket cri-docker.service /etc/systemd/system/
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
sudo kubeadm config images pull --cri-socket /run/cri-dockerd.sock
sudo touch /var/lib/kubelet/config
sudo chown $USER:$USER /var/lib/kubelet/config
sudo cat << EOF > /var/lib/kubelet/config
KUBELET_KUBEADM_ARGS="... --container-runtime=remote --container-runtime-endpoint=/run/cri-dockerd.sock"
EOF
sudo systemctl start kubelet
sudo minikube start --vm-driver=none
sudo minikube status

#----------------------------------------
#Now second task is to further setup our ec2 from inside
sudo apt install awscli -y
#configure aws cli
mkdir /home/ubuntu/.aws/
sudo chmod 755  /home/ubuntu/.aws
sudo touch /home/ubuntu/.aws/config
sudo chown ubuntu:ubuntu /home/ubuntu/.aws/config
sudo cat << EOF > /home/ubuntu/.aws/config
[default]
region = us-east-1
EOF
cd /home/ubuntu
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws configure set default.region us-east-1
aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) > /home/ubuntu/data.json

#-----------------------------------------
#Now third task is updating values of volume in the volume claim file
cd /home/ubuntu
sudo apt-get install python3.7 -y
python3 --version
chmod -R 777 /home/ubuntu/
/home/ubuntu/script.py >> /home/ubuntu/result.txt
RESULTS=$(cat /home/ubuntu/result.txt)
/home/ubuntu/script2.py $RESULTS

#-----------------------------------------------
#Now run the YAML files
#sudo kubectl apply -f /home/ubuntu/mysql-persistent-volume.yaml
#sudo kubectl apply -f /home/ubuntu/mysql-volume-claim.yaml
#sudo kubectl apply -f /home/ubuntu/mysql-replicaset.yaml
#sudo kubectl apply -f /home/ubuntu/mysql-service.yaml
#sudo kubectl apply -f /home/ubuntu/DO-nodeport.yaml
#sudo kubectl apply -f /home/ubuntu/secret.yaml
#sudo kubectl apply -f /home/ubuntu/wordpress-datavolume-claim.yaml
#sudo kubectl apply -f /home/ubuntu/wordpress-deployment.yaml
sudo kubectl apply -f /home/ubuntu/ > /home/ubuntu/kube-output.txt