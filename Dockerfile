# Build with:
# docker build -t ogrisel/openblas .
FROM ubuntu:14.04
MAINTAINER Olivier Grisel <olivier.grisel@ensta.org>

ADD openblas.conf /etc/ld.so.conf.d/openblas.conf
ADD build_openblas.sh build_openblas.sh
RUN bash build_openblas.sh
