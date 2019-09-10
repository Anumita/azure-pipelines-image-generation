#!/bin/bash
################################################################################
##  File:  open-policy-agent.sh
##  Team:  CI-Platform
##  Desc:  Installs open-policy-agent
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh
source $HELPER_SCRIPTS/apt.sh

# Install Open Policy Agent
OPA_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/open-policy-agent/opa/releases/latest | cut -d / -f8 )
if [[ -z $OPA_VERSION ]] || ! [[ "$OPA_VERSION" =~ (v[0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
    echo "Downloading stable open policy agent version v0.13.5"
    OPA_VERSION = "v0.13.5"
fi

curl -L -o /usr/local/bin/opa "https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64"
chmod +x /usr/local/bin/opa

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
if ! command -v opa; then
    echo "Open Policy Agent was not installed or found on PATH"
    exit 1
fi

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "Open Policy Agent ($(opa version))"
