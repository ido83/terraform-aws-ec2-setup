#!/bin/bash
# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
# install docker
sudo dnf update -y
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce --nobest -y
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker

sudo chown $USER /var/run/docker.sock




