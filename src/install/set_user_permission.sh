#!/usr/bin/env bash
### every exit != 0 fails the script
set -ex

if [[ -n $DEBUG ]]; then
    verbose="-v"
fi

#groupadd -g 1000 testup
#useradd testup -u 1000 -g 1000 -m -s /bin/bash

if [ -f /etc/sudoers ]
then
  sed -i -e "/^%sudo/ s/.*/%sudo ALL=(ALL) NOPASSWD:ALL/" /etc/sudoers
  touch "$HOME/.sudo_as_admin_successful"
fi

# Configure Chrome
mkdir -p $HOME/.config/google-chrome
touch $HOME/.config/google-chrome/'First Run'

# Configure Firefox
if [ -d "/usr/lib/firefox/" ]
then
  cat > /usr/lib/firefox/defaults/pref/autoconfig.js <<EOF_FF
  pref("general.config.filename", "firefox.cfg");
  pref("general.config.obscure_value", 0);
EOF_FF
  cat > /usr/lib/firefox/firefox.cfg << EOF_FF
  // Testup settings
  lockPref("app.update.auto", false);
  lockPref("app.update.enabled", false);
  lockPref("browser.shell.checkDefaultBrowser", false);
  defaultPref("browser.tabs.warnOnClose", false);
EOF_FF
fi


# Fix permissions
echo "fix permissions for: $HOME"
find "$HOME"/ -name '*.sh' -exec chmod $verbose a+x {} +
find "$HOME"/ -name '*.desktop' -exec chmod $verbose a+x {} +
chgrp -R 0 "$HOME" && chmod -R $verbose a+rw "$HOME" && find "$HOME" -type d -exec chmod $verbose a+x {} +

cat >> $HOME/.bashrc << EOF
export PS1='\[\e[0;32m\]\u \[\e[0;36m\]\w\[\e[m\] \$ '
echo Welcome to Testup!
echo Use \"sudo apt install xxx\" to install packages from the Ubuntu universe.
echo
EOF

chown -R testup:testup $HOME
