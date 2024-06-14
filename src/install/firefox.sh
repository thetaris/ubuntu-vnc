#!/usr/bin/env bash
set -ex

echo "Install Firefox"
apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	--no-install-recommends

#copy from org/sakuli/common/bin/installer_scripts/linux/install_firefox_portable.sh
function instFF() {
    if [ ! "${1:0:1}" == "" ]; then
        FF_VERS=$1
        if [ ! "${2:0:1}" == "" ]; then
            FF_INST=$2
            echo "download Firefox $FF_VERS and install it to '$FF_INST'."
            mkdir -p "$FF_INST"
            FF_URL=http://releases.mozilla.org/pub/firefox/releases/$FF_VERS/linux-x86_64/en-US/firefox-$FF_VERS.tar.bz2
            echo "FF_URL: $FF_URL"
            wget -qO- $FF_URL | tar xvj --strip 1 -C $FF_INST/
            ln -s "$FF_INST/firefox" /usr/bin/firefox

            if [ ! "${3:0:1}" == "" ]; then
              echo "Installing custom Firefox policy"
              mkdir -pv /etc/firefox/policies
              cat <<EOF > /etc/firefox/policies/policies.json
{
  "policies": {
    "DisableAppUpdate": true,
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    "BookmarksToolbar": false,
    "Bookmarks": {
      "Locked": true,
      "ManageBookmarks": false
    },
    "DisableBookmarkPrompt": true,
    "DisableBookmarks": true,
    "DisplayBookmarksToolbar": "never",
    "DisableFirefoxAccounts": true,
    "DisableProfileImport": true,

    "DontCheckDefaultBrowser": true,
    "ExtensionSettings": {
        "*": {
          "blocked_install_message": "Blocked!",
          "installation_mode": "blocked"
        }
    },
    "FirefoxHome": {
        "TopSites": false,
        "SponsoredTopSites": false,
        "Highlights": false,
        "Pocket": false,
        "SponsoredPocket": false,
        "Snippets": false,
        "Locked": true
    },
    "FirefoxSuggest": {
        "SponsoredSuggestions": false,
        "ImproveSuggest": false,
        "Locked": true
    },
    "UserMessaging": {
      "WhatsNew": false,
      "ExtensionRecommendations": false,
      "FeatureRecommendations": false,
      "UrlbarInterventions": false,
      "SkipOnboarding": true,
      "MoreFromMozilla": false,
      "Locked": true
    }
  }
}
EOF

            fi

            echo "Install Geckodriver"

            curl -L https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz -o /tmp/geckodriver.tgz
            tar zxvf /tmp/geckodriver.tgz -C /tmp
            mv /tmp/geckodriver /usr/bin/geckodriver
            rm /tmp/geckodriver.tgz
            exit $?
        fi
    fi

    echo "function parameter are not set correctly please call it like 'instFF [version] [install path] [custom_policy]'"
    exit -1
}

instFF '127.0' '/usr/lib/firefox' 'true'

