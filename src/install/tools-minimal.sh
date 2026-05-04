#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some minimalistic tools for further installations"
apt-get update
apt-get install -y locales bzip2 xz-utils jq wget unzip sudo netcat-openbsd vim net-tools curl tcpflow
apt-get clean -y

echo "generate locales für en_US.UTF-8"
locale-gen en_US.UTF-8
