FROM debian:stretch-slim

ENV TIMEZONE Asia/Shanghai
ENV LANG=C.UTF-8
ENV PATH=/opt/texlive/bin/x86_64-linux:$PATH

COPY fonts /usr/share/fonts
ADD texlive.profile /root/

RUN mkdir -p /home/resume/ && \
	sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN	apt-get update --fix-missing && \
	apt-get install -y --no-install-recommends python-pip python-setuptools fontconfig && \
	pip install pyyaml && \
	apt-get install -y --no-install-recommends make enca pandoc && \
	apt-get remove -y python-pip python-setuptools && \
	apt autoremove -y && \
	apt-get clean all && \
	rm -rf /var/lib/apt/lists/*


RUN apt-get update --fix-missing && \
	apt-get install -y --no-install-recommends wget xzdec gnupg perl-modules perl && \
	wget https://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz && \
	tar zxvf install-tl-unx.tar.gz && \
	cd install-tl-20* && \
	./install-tl --profile=/root/texlive.profile && \
	cd ~ && \
	rm -fr /install-tl* && \
	tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet && \
	tlmgr update --self --all --reinstall-forcibly-removed && \
	tlmgr install xetex \
	xecjk \
	environ \
	trimspaces \
	geometry \
	hyperref \
	metafont mfware \
	zapfding \
	fontspec \
	etoolbox \
	dvips \
	tools \
	ifxetex \
	ifluatex \
	url \
	graphics \
	graphics-def \
	oberdiek \
	fancyhdr \
	microtype \
	pgf \
	colortbl \
	xcolor \
	ctex \
	moderncv \
	ulem \
	zhnumber \
	fontawesome && \
	apt-get remove -y wget xzdec gnupg perl perl-modules* && \
	apt autoremove -y && \
	apt-get clean all && \
	rm -rf /var/lib/apt/lists/*

COPY converters /home/resume/converters
COPY static /home/resume/static
COPY sample.yml /home/resume/
COPY templates /home/resume/templates

RUN sed -i 's/python3/python2.7/g' /home/resume/converters/moderncv.py && \
	sed -i 's/^import sys/import sys\nreload(sys)\nsys.setdefaultencoding("utf-8")/g' /home/resume/converters/moderncv.py
	
VOLUME ["/home/resume/build"]

ADD init.sh /

COPY Makefile /home/resume/

CMD ["/bin/bash"]
