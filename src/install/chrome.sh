#!/usr/bin/env bash
### every exit != 0 fails the script
set -ex


echo "Install Chrome Browser"
apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	jq \
	unzip \
	wget \
	--no-install-recommends

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

rm ./google-chrome-stable_current_amd64.deb

# Install chromedriver matching the installed Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
CHROME_MAJOR=${CHROME_VERSION%%.*}
CHROMEDRIVER_URL=$(curl -fsSL https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json \
    | jq -r --arg major "$CHROME_MAJOR" '
        [.versions[] | select(.version | startswith($major + "."))] | last
        | .downloads.chromedriver[] | select(.platform == "linux64") | .url')
curl -L "$CHROMEDRIVER_URL" -o /tmp/chromedriver.zip
unzip /tmp/chromedriver.zip -d /tmp
rm /tmp/chromedriver.zip
mv /tmp/chromedriver-linux64/chromedriver /usr/bin/chromedriver
chmod +x /usr/bin/chromedriver

rm -rf /var/lib/apt/lists/*
# libasound2:amd64