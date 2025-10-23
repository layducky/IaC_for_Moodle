#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt update -y
apt upgrade -y
apt install -y ca-certificates curl git direnv

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

git clone https://github.com/nguyendangcuong201004/moodle-docker /home/ubuntu/moodle-docker

chown -R ubuntu:ubuntu /home/ubuntu/moodle-docker

su - ubuntu -c "cd /home/ubuntu/moodle-docker && direnv allow && ./setup.sh"