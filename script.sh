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

sudo dnf install conntrack -y

# Install minikube
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version

sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
minikube start --driver=none
minikube status

#Install Flotta dependencies
sudo dnf install -y go make git curl 

# Install Flotta
git clone https://github.com/project-flotta/flotta-operator -b main --depth 1
cd flotta-operator

make install-router
make deploy IMG=quay.io/project-flotta/flotta-operator:latest HTTP_IMG=quay.io/project-flotta/flotta-edge-api:latest TARGET=k8s
kubectl  api-resources | grep flotta
kubectl -n flotta get pods

# Create Flotta agent scripts
make agent-install-scripts
#kubectl port-forward service/flotta-edge-api -n flotta 8043 --address 0.0.0.0
#On the device, with Fedora already installed, we need to execute the following:

# sudo hack/install-agent-dnf.sh -i 192.168.2.10
# kubectl get edgedevices



