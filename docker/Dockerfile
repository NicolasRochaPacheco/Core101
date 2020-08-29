# A Dockerfile for Core101

# Uses Ubuntu 18 as source
FROM ubuntu:bionic

MAINTAINER Nicolas Rocha Pacheco (n.rocha11@uniandes.edu.co)

#--------------------------------------
# Prerrequisite installation
#--------------------------------------
# Update aptitude repositories
RUN apt-get update

# Installs prerrequisites
RUN apt-get install -y \
  build-essential\
  git\
  make\
  verilator==3.916

#--------------------------------------
# Source code download
#--------------------------------------
# Downloads Core101 repository on opt directory
WORKDIR /opt/
RUN mkdir L0G1C101
WORKDIR /opt/L0G1C101/
RUN git clone https://github.com/NicolasRochaPacheco/Core101.git

# Gets back to root folder
WORKDIR /
RUN echo 'Image built successfully'
