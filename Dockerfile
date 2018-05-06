FROM debian:stretch-slim

ENV TIMEZONE Asia/Shanghai
ENV LANG=C.UTF-8
ENV PATH=/opt/texlive/bin/x86_64-linux:$PATH

ADD texlive.profile /root/

RUN mkdir -p /home/resume/ && \
	sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN	apt-get update --fix-missing && \
	apt-get install -y --no-install-recommends \
	python3-minimal python3-pip python3-setuptools \
	wget xzdec gnupg perl-modules perl \
	make enca pandoc \
	ghostscript \
	fonts-wqy-* \
	fontconfig && \
	pip3 install pyyaml && \
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
	moderncv marvosym gsftopk \
	limecv parskip xstring xkeyval fira cleveref listings dvipdfmx \
	ulem \
	zhnumber \
	changepage \
	fontawesome && \
	tlmgr option -- autobackup 0 && \
	mktexpk --mfmode / --bdpi 600 --mag 0+540/600 --dpi 540 umvs && \
	mktexpk --mfmode / --bdpi 600 --mag 1+264/600 --dpi 864 umvs && \
	mktexpk --mfmode / --bdpi 600 --mag 1+0/600 --dpi 600 umvs && \
	apt-get remove -y wget xzdec gnupg perl perl-modules* python3-pip python3-setuptools python2.7* ghostscript && \
	apt autoremove -y && \
	apt-get clean all && \
	rm -rf /var/lib/apt/lists/* && \
	cp /opt/texlive/texmf-var/fonts/conf/texlive-fontconfig.conf /etc/fonts/local.conf && \
	fc-cache -fv

COPY converters /home/resume/converters
COPY static /home/resume/static
COPY sample.yml /home/resume/
COPY templates /home/resume/templates
ADD init.sh /
ADD debug.sh /
COPY Makefile /home/resume/

VOLUME ["/home/resume/build"]

CMD ["/bin/bash"]
