#!/usr/bin/env bash
### every exit != 0 fails the script
set -ex


echo "Install Chrome Browser"
apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg \
	--no-install-recommends

#curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
#echo "deb https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

rm ./google-chrome-stable_current_amd64.deb

#apt-get update && apt-get install -y \
#	google-chrome-stable --no-install-recommends

rm -rf /var/lib/apt/lists/*
# libasound2:amd64