# A Dockerfile for Core101
FROM ubuntu:latest
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
  verilator

#--------------------------------------
# Source code download
#--------------------------------------
# Downloads Core101 repository on opt directory
WORKDIR /opt/
RUN git clone https://github.com/NicolasRochaPacheco/Core101.git

# Gets back to root folder
WORKDIR /
