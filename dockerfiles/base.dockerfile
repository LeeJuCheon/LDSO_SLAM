FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i 's@archive.ubuntu.com@mirror.kakao.com@g' /etc/apt/sources.list
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install build-essential -y && \

# Related to proSLAM
apt-get install libeigen3-dev -y && \
apt-get install libsuitesparse-dev -y && \
apt-get install freeglut3-dev -y && \
apt-get install libqglviewer-dev-qt5 -y && \
apt-get install libyaml-cpp-dev -y && \
apt-get install ninja-build -y && \

# Related to build...
apt-get install cmake -y && \
apt-get install git -y && \
apt-get install sudo -y && \
apt-get install wget -y && \
apt-get install ninja-build -y && \
apt-get install software-properties-common -y && \
apt-get install python3 -y && \
apt-get install python3-pip -y && \

# Related to JetBrains CLion Docker develpoment...

apt-get install -y ssh && \
apt-get install -y gcc && \
apt-get install -y g++ && \
apt-get install -y gdb && \
apt-get install -y clang && \
apt-get install -y cmake && \
apt-get install -y rsync && \
apt-get install -y tar && \
apt-get install -y mesa-utils && \
apt-get install -y libpython2.7-dev && \

# Related to X11 remote display
apt-get install -y libgl1-mesa-glx && \
apt-get install -y libglu1-mesa-dev && \
apt-get install -y mesa-common-dev && \
apt-get install -y x11-utils && \
apt-get install -y x11-apps && \
apt-get install x11-xserver-utils && \
apt-get install libssl-dev -y && \
apt-get install libgflags-dev && \
apt-get clean
 
RUN pip3 install pyyaml
RUN pip3 install gitpython

RUN apt-get autoclean

RUN apt-get install qt5* -y

RUN echo "Configuring and building Thirdparty/OpenSSL ..." && \
wget https://www.openssl.org/source/openssl-1.1.1i.tar.gz && \
tar xvfz openssl-1.1.1i.tar.gz && \
cd openssl-1.1.1i/ && \
./config shared && \
make && \
make install && \
ldconfig 

RUN mkdir LDSO && cd LDSO && \
    git clone https://github.com/LeeJuCheon/LDSO_SLAM.git && \
    cd LDSO_SLAM && python3 ./buildDeps.py --d --system

RUN cd LDSO && cd LDSO_SLAM && chmod +x install_dependencies.sh &&\
    ./install_dependencies.sh

RUN cd LDSO && cd LDSO_SLAM && chmod +x make_project.sh &&\
    ./make_project.sh

ENV DISPLAY=host.docker.internal:0.0
