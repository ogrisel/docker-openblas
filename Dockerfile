# Build with:
# docker build -t ogrisel/openblas .
FROM ubuntu:14.04
MAINTAINER Olivier Grisel <olivier.grisel@ensta.org>

RUN mkdir /tmp/build
WORKDIR /tmp/build
RUN locale-gen en_US en_US.UTF-8

RUN apt-get -y update
RUN apt-get -y install git-core build-essential gfortran

# Build latest stable release from OpenBLAS from source
RUN git clone -q --branch=master git://github.com/xianyi/OpenBLAS.git
RUN (cd OpenBLAS \
     && make DYNAMIC_ARCH=1 NO_AFFINITY=1 NUM_THREADS=32 \
     && make install)
ADD openblas.conf /etc/ld.so.conf.d/openblas.conf
RUN ldconfig

WORKDIR $HOME

#Minimize image size
RUN rm -rf /tmp/build

RUN (apt-get remove -y --purge git-core build-essential; \
     apt-get autoremove -y; \
     apt-get clean -y)
