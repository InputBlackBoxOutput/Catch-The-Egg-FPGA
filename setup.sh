# Setup script for installing required tools for the project
sudo apt install iverilog -y
sudo apt install gtkwave -y

sudo apt install yosys -y

sudo apt install nextpnr-ice40 -y

sudo apt install build-essential -y
sudo apt install clang -y
sudo apt install bison -y
sudo apt install flex -y
sudo apt install libreadline-dev -y
sudo apt install gawk -y
sudo apt install tcl-dev -y
sudo apt install libffi-dev -y
sudo apt install git -y
sudo apt install mercurial -y
sudo apt install graphviz -y
sudo apt install xdot -y
sudo apt install pkg-config -y
sudo apt install python3 -y
sudo apt install libftdi-dev -y
sudo apt install python3-dev -y
sudo apt install libboost-all-dev -y
sudo apt install cmake -y
sudo apt install libeigen3-dev -y

git clone https://github.com/YosysHQ/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install