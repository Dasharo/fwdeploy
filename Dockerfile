FROM debian:testing
MAINTAINER Piotr Król <piotr.krol@3mdeb.com>

RUN apt-get update && apt-get install -y \
	python \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
	pip \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN pip install \
	uefi-firmware \
	binwalk

RUN apt-get update && apt-get install -y \
	git \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/fwdeploy && cd /home/fwdeploy
WORKDIR /home/fwdeploy

RUN apt-get update && apt-get install -y \
	libc6 \
	libpci-dev \
	libusb-1.0.0-dev \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/flashrom/flashrom.git

RUN cd /home/fwdeploy/flashrom && \
	git checkout v1.2 && \
	make install

COPY scripts/fwdeploy.sh /usr/bin/fwdeploy
CMD /usr/bin/fwdeploy
