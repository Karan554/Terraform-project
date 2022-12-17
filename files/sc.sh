#!/bin/bash

kubectl apply -f /home/ubuntu/mysql-persistent-volume.yaml
kubectl apply -f /home/ubuntu/mysql-volume-claim.yaml
kubectl apply -f /home/ubuntu/mysql-replicaset.yaml
kubectl apply -f /home/ubuntu/mysql-service.yaml
kubectl apply -f /home/ubuntu/DO-nodeport.yaml
kubectl apply -f /home/ubuntu/wp-mysql-secrets.yaml
kubectl apply -f /home/ubuntu/wordpress-datavolume-claim.yaml
kubectl apply -f /home/ubuntu/wordpress-deployment.yaml