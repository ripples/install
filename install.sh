#!/bin/bash
#### Discription: Setup the RIPPLES capturing system
#### Usage: Run from commandline.
#### Written by: William He - ziweihe@umass.edu on 03-2018
echo -n "paol user required!!! Are you logged in as paol? (y/n)"
read answer
if echo "$answer" | grep -iq "^y" ; then
	echo ">>Processing..."
else
	echo ">>Exiting..."
	exit 0
fi
sudo -s
cd ~
# clone the calendar parser
echo ">>Setting up calendar parser..."
git clone https://github.com/ripples/calendarScheduler.git

# setting up calendar parser
echo ">>Resolving calendar parser dependencies..."
sudo apt-get install python-pip
sudo pip install icalendar datetime pytz requests

# clone the project
echo ">>Setting up capturing system..."
git clone https://github.com/ripples/paol.git
mv paol paol-code

# Fetch qt dist
echo ">>Fetching Qt 5.3.1 Distribution..."
cd ~/Downloads
wget http://download.qt.io/archive/qt/5.3/5.3.1/qt-opensource-linux-x64-5.3.1.run
# Run Qt setup
chmod +x qt-opensource-linux-x64-5.3.1.run
echo ">>Please follow the instruction in GUI Interface for installation"
./qt-opensource-linux-x64-5.3.1.run
wget http://fr.archive.ubuntu.com/ubuntu/pool/main/g/gst-plugins-base0.10/libgstreamer-plugins-base0.10-0_0.10.36-1_amd64.deb
wget http://fr.archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10/libgstreamer0.10-0_0.10.36-1.5ubuntu1_amd64.deb
sudo dpkg -i libgstreamer*.deb
sudo apt-get install gstreamer1.0-plugins-ugly

# Setup Opencv
cd ~
echo ">>Fetching OpenCV..."
git clone https://github.com/opencv/opencv.git
sudo apt-get install build-essentials
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev -y
sudo apt-get install libgl1-mesa-dev
cd ./opencv
mkdir release
cd release
echo ">>Compiling OpenCV..."
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..

make
sudo make install

# Building the Project
echo ">>Building capturing system..."
sudo apt-get install gstreamer-tools gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly gstreamer0.10-plugins-ugly-multiverse gstreamer0.10-plugins-bad-multiverse ffmpeg
sudo apt install v4l-utils
sudo apt-get install qt4-qmake libqt4-dev
cd ~/paol-code
./build.sh
