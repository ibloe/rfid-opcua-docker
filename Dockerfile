#use latest armv7hf compatible debian version from group resin.io as base image
FROM balenalib/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if not built as automated build on docker hub) 
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="ibloecher@hilscher.com" \ 
    version="V0.0.0.1" \
    description="rfid_opcua_docker"

#version
ENV RFID_OPC_UA_DOCKER_VERSION 0.0.0.2


#copy files
COPY "./init.d/*" /etc/init.d/ 
COPY "./rfid_opcua/" /home/pi/rfid_opcua/

#do installation
RUN apt-get update  \
    && apt-get install -y openssh-server build-essential network-manager ifupdown \
#do users root and pi    
    && useradd --create-home --shell /bin/bash pi \
    && echo 'root:root' | chpasswd \
    && echo 'pi:raspberry' | chpasswd \
    && adduser pi sudo \
    && mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
	&& sudo chmod -R g+rwx /home/pi/rfid_opcua/ \
	&& sudo chmod g+rwx /etc/init.d/gpio.sh \
	&& apt-get install -y --no-install-recommends \
    less \
    kmod \
    nano \
    net-tools \
    ifupdown \
    iputils-ping \
    i2c-tools \
    usbutils \
    build-essential \
    git \
    apt-utils \
    dialog \
    curl build-essential \
    vim-common \
    vim-tiny \
    gdb \
	psmisc \
#clean up
    && apt-get remove build-essential \
    && apt-get -yqq autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*
	
#OPC UA TCP & SSH
EXPOSE 4840
EXPOSE 22

#set the entrypoint
ENTRYPOINT ["sh","/etc/init.d/entrypoint.sh"]

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if not built as automated build on docker hub)
RUN [ "cross-build-end" ]