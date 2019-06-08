#!/bin/bash

CURDIR="$PWD"

echo -e "\nWelcome to CodeBus install\n"
echo -e "\nWe will be installing dependencies: python3, python3-setuptools\ngit-core, curl, doxygen, graphviz, qpdf, ripgrep and seaborn"
echo -e "\n\nPress enter to proceed\n"
read

sudo apt-get update

sudo apt-get install python3 python3-setuptools git-core curl doxygen graphviz qpdf

cd /tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
sudo dpkg -i ripgrep_11.0.1_amd64.deb

git clone https://github.com/mwaskom/seaborn.git
cd seaborn

echo -e "\nInstalling seaborn globally\n\nPress enter to proceed"
read
sudo python3 setup.py install

cd "$CURDIR"
mkdir Repos
cd Repos

git clone https://github.com/radareorg/cutter.git
git clone https://github.com/airbnb/epoxy.git
git clone https://github.com/OpenKinect/libfreenect2.git
