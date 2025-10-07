#!/bin/bash

# setup RKE2 agent
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
systemctl enable rke2-agent.service

set -x
sudo apt-get install -y nfs-common
sudo mkdir -p /opt/keys

while [ ! -d /opt/keys/flagdir ]; do
  sudo mount 192.168.1.1:/opt/keys /opt/keys
  sleep 10
done

while [ ! -f /opt/keys/node-token ]; do
  sleep 20
done

for mount_dir in home software scratch
do
  mkdir -p /opt/${mount_dir}
  mount 192.168.1.1:/opt/${mount_dir} /opt/${mount_dir}
done

mkdir -p /etc/rancher/rke2/
echo "server: https://192.168.1.1:9345" > /etc/rancher/rke2/config.yaml
echo "token: $(cat /opt/keys/node-token)" >> /etc/rancher/rke2/config.yaml
systemctl start rke2-agent.service

#command=`tail -n 2 /opt/keys/kube.log | tr -d '\\'`
#echo $command
#sudo $command
