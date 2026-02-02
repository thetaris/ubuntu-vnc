#!/usr/bin/env bash
### every exit != 0 fails the script
set -ex


echo "Install Microsoft Edge Browser"
apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        --no-install-recommends

# Add Microsoft GPG key
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-edge.gpg

# Add Microsoft Edge repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list

# Install Edge
apt-get update && apt-get install -y microsoft-edge-stable

# Install msedgedriver
EDGE_VERSION=$(microsoft-edge --version | awk '{print $3}')
curl -L "https://msedgedriver.microsoft.com/${EDGE_VERSION}/edgedriver_linux64.zip" -o /tmp/edgedriver.zip
unzip /tmp/edgedriver.zip -d /tmp
rm /tmp/edgedriver.zip
mv /tmp/msedgedriver /usr/bin/msedgedriver
chmod +x /usr/bin/msedgedriver

# Create Edge policy to disable automation infobar
mkdir -p /etc/opt/edge/policies/managed
cat > /etc/opt/edge/policies/managed/disable_automation_infobar.json << 'EOF'
{
    "CommandLineFlagSecurityWarningsEnabled": false
}
EOF

rm -rf /var/lib/apt/lists/*