#use latest armv7hf compatible debian version from group resin.io as base image
FROM balenalib/armv7hf-debian:buster

#enable building ARM container on x86 machinery on the web (comment out next line if not built as automated build on docker hub) 
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="ibloe" \ 
    version="V0.0.0.1" \
    description="drive_opcua_docker"

#version
ENV DRIVE_OPC_UA_DOCKER_VERSION 0.0.0.2

ENV USER=pi
ENV PASSWD=raspberry

RUN apt-get update \
 && apt-get install wget \
 && wget https://archive.raspbian.org/raspbian.public.key -O - | apt-key add - \
 && echo 'deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi' | tee -a /etc/apt/sources.list \
 && wget -O - http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | sudo apt-key add - \
 && echo 'deb http://archive.raspberrypi.org/debian/ buster main ui' | tee -a /etc/apt/sources.list.d/raspi.list \
 && apt-get update  \
 && apt-get install -y openssh-server \
 && mkdir /var/run/sshd \
# && sed -i -e 's;#Port 22;Port 23;' /etc/ssh/sshd_config \ #Comment in if SSH port other than 22 is needed (22->23)
 && sed -i 's@#force_color_prompt=yes@force_color_prompt=yes@g' -i /etc/skel/.bashrc \
 && useradd --create-home --shell /bin/bash pi \
 && echo $USER:$PASSWD | chpasswd \
 && adduser $USER sudo \
 && groupadd spi \
 && groupadd gpio \
 && adduser $USER input \
 && adduser $USER spi \
 && adduser $USER gpio \
 && apt-get install -y --no-install-recommends \
 				build-essential \
				network-manager \
                less \
                kmod \
                nano \
                net-tools \
                ifupdown \
                iputils-ping \
				i2c-tools \
                usbutils \
				git \
                python \
                apt-utils \
				dialog \
				curl build-essential \
				vim-common \
				vim-tiny \
                gdb \
				psmisc \
                dhcpcd5 \
                ssh \
                python-rpi.gpio \
                python3-pkg-resources \
                python3-requests \
                python3-six \
                python3-urllib3 \
                multiarch-support \ 
                libraspberrypi-bin \
                libraspberrypi-dev \
                libraspberrypi-doc \
                libsigc++-1.2-dev \
                raspberrypi-kernel \
                raspi-copies-and-fills \
 && mkdir /etc/firmware \
 && curl -o /etc/firmware/BCM43430A1.hcd -L https://github.com/OpenELEC/misc-firmware/raw/master/firmware/brcm/BCM43430A1.hcd \
 && wget https://raw.githubusercontent.com/raspberrypi/firmware/1.20180417/opt/vc/bin/vcmailbox -O /opt/vc/bin/vcmailbox \
 && apt-get autoremove \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt/lists/*

#copy files
COPY "./init.d/*" /etc/init.d/ 
COPY "./rfid_opcua/" /home/pi/opc-ua-server/

RUN sudo chmod -R g+rwx /home/pi/opc-ua-server/
	
#OPC UA TCP & SSH
EXPOSE 4840
EXPOSE 22

#set the entrypoint
ENTRYPOINT ["sh","/etc/init.d/entrypoint.sh"]

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if not built as automated build on docker hub)
RUN [ "cross-build-end" ]