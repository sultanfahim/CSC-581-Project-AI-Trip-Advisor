#!/bin/bash
 
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
kubectl create namespace cattle-system
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.7/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io

helm repo update

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace

helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=$(hostname -f) --set replicas=1 --set bootstrapPassword=qwerasdfzxcv
