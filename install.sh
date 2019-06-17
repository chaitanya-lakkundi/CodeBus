#!/bin/bash

CURDIR="$PWD"

echo -e "\nWelcome to CodeBus install\n"
echo -e "\nWe will be installing dependencies: python3, git-core, wget,\ndoxygen, graphviz, qpdf and ripgrep"
echo -e "\n\nPress enter to proceed\n"
read

sudo apt-get update

sudo apt-get install -y python3 git-core wget doxygen graphviz qpdf

sudo apt-get install -y python3-distutils

cd /tmp
wget https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
sudo dpkg -i ripgrep_11.0.1_amd64.deb

which pip3

if [[ $? -ne 0 ]]; then
	echo -e "\n\npip3 is not installed.\nInstalling..\n"
	wget https://bootstrap.pypa.io/get-pip.py && \
	sudo python3 get-pip.py --no-setuptools --no-wheel && \
	rm get-pip.py
fi

echo -e "\nInstalling Matplotlib..\n"

sudo pip3 install matplotlib

cd "$CURDIR"
mkdir Repos
cd Repos

git clone https://github.com/radareorg/cutter.git
git clone https://github.com/airbnb/epoxy.git
git clone https://github.com/OpenKinect/libfreenect2.git
