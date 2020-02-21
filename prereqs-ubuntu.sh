#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Usage:
#
# ./prereqs-ubuntu.sh
#
# User must then logout and login upon completion of script
#

# Exit on any failure
set -e

# Array of supported versions
declare -a versions=('trusty' 'xenial' 'yakkety', 'bionic');

# check the version and extract codename of ubuntu if release codename not provided by user
if [ -z "$1" ]; then
    source /etc/lsb-release || \
        (echo -e "Error: 找不到 Ubuntu 版本，請以您 Ubuntu 版本號為參數執行此腳本\n(以 18.04 為例: ./prereqs-ubuntu.sh bionic)"; exit 1)
    CODENAME=${DISTRIB_CODENAME}
else
    CODENAME=${1}
fi

# check version is supported
if echo ${versions[@]} | grep -q -w ${CODENAME}; then
    echo "Installing Hyperledger Composer prereqs for Ubuntu ${CODENAME}"
else
    echo "Error: 不支援 Ubuntu ${CODENAME}"
    exit 1
fi

# Update package lists
echo "# 更新套件清單"
sudo apt-add-repository -y ppa:git-core/ppa
sudo apt-get update

# Install Git
echo "# 安裝 Git"
sudo apt-get install -y git

# Install nvm dependencies
echo "# 安裝 nvm 相依套件"
sudo apt-get -y install build-essential libssl-dev

# Execute nvm installation script
echo "# 執行 nvm 安裝腳本"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

# Set up nvm environment without restarting the shell
# export NVM_DIR="${HOME}/.nvm"
# [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh"
# [ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"

# Install node
echo "# 安裝 nodeJS"
nvm install 8.11.4
nvm use 8.11.4

# Ensure that CA certificates are installed
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add Docker repository key to APT keychain
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Update where APT will search for Docker Packages
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${CODENAME} stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

# Update package lists
sudo apt-get update

# Verifies APT is pulling from the correct Repository
sudo apt-cache policy docker-ce

# Install kernel packages which allows us to use aufs storage driver if V14 (trusty/utopic)
if [ "${CODENAME}" == "trusty" ]; then
    echo "# 安裝必要的 kernel 套件"
    sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
fi

sudo apt-get update

# Install Docker
echo "# 安裝 Docker"
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# Add user account to the docker group
sudo usermod -aG docker $(whoami)

# Install docker compose
echo "# 安裝 Docker-Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install python v2 if required
set +e
COUNT="$(python -V 2>&1 | grep -c 2.)"
if [ ${COUNT} -ne 1 ]
then
   sudo apt-get install -y python-minimal
fi

# Install unzip, required to install hyperledger fabric.
sudo apt-get -y install unzip

# Print installation details for user
echo ''
echo '----- 安裝完成，以下為個套件的版本：-----'
echo ''
echo -n 'Node:           '
node --version
echo -n 'npm:            '
npm --version
echo -n 'Docker:         '
docker --version
echo -n 'Docker Compose: '
docker-compose --version
echo -n 'Python:         '
python -V

# Print reminder of need to logout in order for these changes to take effect!
echo ''
echo "請登出再登入使更動生效。"