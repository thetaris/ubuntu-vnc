#!/usr/bin/env bash

echo "Hello world"

apt-get update

#Move this into tools_minimal.sh
apt-get install -y wget sudo

echo "*** Install XOrg minimal"
sh -c $INST_SCRIPTS/install/xorg_firefox_minimal.sh
echo "*** Install TigerVNC"
sh -c $INST_SCRIPTS/install/tigervnc.sh
echo "*** Setup User Permissions"
sh -c $INST_SCRIPTS/install/set_user_permission.sh

#clean up apt cache
rm -rf /var/lib/apt/lists/*