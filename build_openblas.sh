#!/usr/bin/bash

# Build OpenBLAS and clean up build dependencies to have put everything in a
# single RUN step and workaround for:
# https://github.com/docker/docker/issues/332

set -xe

mkdir /tmp/build
cd /tmp/build

apt-get -y update
apt-get -y install git-core build-essential gfortran

# Build latest stable release from OpenBLAS from source
git clone -q --branch=master git://github.com/xianyi/OpenBLAS.git
(cd OpenBLAS \
    && make DYNAMIC_ARCH=1 NO_AFFINITY=1 NUM_THREADS=32 \
    && make install DYNAMIC_ARCH=1 NO_AFFINITY=1 NUM_THREADS=32)

# Rebuild ld cache, this assumes that:
# /etc/ld.so.conf.d/openblas.conf was installed by Dockerfile
# and that the libraries are in /opt/OpenBLAS/lib
ldconfig

#Minimize image size (gfortran is needed at runtime)
apt-get remove -y --purge git-core build-essential
apt-get autoremove -y
apt-get clean -y

cd /
rm -rf /tmp/build
rm -rf /build_openblas.sh
