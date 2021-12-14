FROM debian:testing
MAINTAINER Piotr Król <piotr.krol@3mdeb.com>

RUN apt-get update && apt-get install -y \
	acpica-tools \
	cmake \
	file \
	gawk \
	git \
	libc6 \
	libftdi-dev \
	libpci-dev \
	libusb-1.0.0-dev \
	pip \
	python3 \
	qtbase5-dev \
	zip \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN pip install \
	uefi-firmware \
	binwalk

RUN mkdir -p /home/fwdeploy && cd /home/fwdeploy
WORKDIR /home/fwdeploy

RUN git clone https://github.com/flashrom/flashrom.git
RUN git clone https://github.com/LongSoft/UEFITool.git -b new_engine

RUN cd /home/fwdeploy/flashrom && \
	make install

RUN cd /home/fwdeploy/UEFITool && \
	./unixbuild.sh

COPY scripts/extract_image.sh /usr/bin/extract_image
COPY blobs /home/fwdeploy/blobs
ENTRYPOINT ["/usr/bin/extract_image"]
