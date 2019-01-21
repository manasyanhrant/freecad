#!/bin/bash

check_for_error(){
	RED='\033[0;31m'
	NC='\033[0m'
	if [ $1 -ne "0" ]; then
		echo -e "${RED}Error $2. ${NC}\n"
		exit 1;
	fi
}

install_prerequisites(){
	sudo apt install -y build-essential cmake python python-matplotlib \
	libtool libcoin80-dev libsoqt4-dev libxerces-c-dev libboost-dev \
	libboost-filesystem-dev libboost-regex-dev \
	libboost-program-options-dev libboost-signals-dev libboost-thread-dev \
	libboost-python-dev libqt4-dev libqt4-opengl-dev qt4-dev-tools \
	python-dev python-pyside pyside-tools libeigen3-dev libqtwebkit-dev \
	libshiboken-dev libpyside-dev libode-dev swig libzipios++-dev \
	libfreetype6-dev libsimage-dev checkinstall python-pivy python-qt4 \
    doxygen libspnav-dev libmedc-dev libvtk6-dev libproj-dev 
	check_for_error $? "Installing prerequsites"
}

build_freecad(){
	cd FreeCAD
	cmake -DFREECAD_USE_EXTERNAL_PIVY=1 -DCMAKE_BUILD_TYPE=Release .
	check_for_error $? "Configuration failed"
	make -j$(nproc)
	check_for_error $? "Compilation failed"
	sudo make install
	check_for_error $? "Installation failed"
	cd -
}

install_liboce(){
    #sudo apt install -y oce-draw liboce-foundation-dev liboce-modeling-dev \
    #liboce-ocaf-dev liboce-ocaf-lite-dev liboce-visualization-dev \ 
    #1. liboce-foundation11
    if ! sudo apt-get install -y ./deb/*.deb; then
        sudo apt-get install -f -y
        echo "Error: Oce library installation failed"
        exit 1
    fi
}

main(){
	install_prerequisites
    install_liboce
	build_freecad
}

main
