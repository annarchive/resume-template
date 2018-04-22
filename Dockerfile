FROM debian:stretch-slim

ENV TIMEZONE Asia/Shanghai
ENV LANG=C.UTF-8

RUN mkdir -p /home/resume/ && \
	sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list


RUN	apt-get update --fix-missing && \
	apt-get install -y --no-install-recommends python-pip python-setuptools && \
	pip install pyyaml && \
	apt-get install -y --no-install-recommends make enca pandoc \
	texlive texlive-xetex && \
	apt-get remove -y python-pip python-setuptools && \
	apt autoremove -y && \
	apt-get clean all && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update --fix-missing && \
	apt-get install -y --no-install-recommends wget xzdec gnupg fontconfig && \
	tlmgr init-usertree && \
	tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet && \
	tlmgr update --self --all --reinstall-forcibly-removed && \
	tlmgr install ctex && \
	tlmgr install moderncv && \
	tlmgr install ulem && \
	tlmgr install zhnumber && \
	apt-get remove -y wget xzdec gnupg && \
	apt autoremove -y && \
	apt-get clean all && \
	rm -rf /var/lib/apt/lists/*

COPY converters /home/resume/converters
COPY Makefile /home/resume
COPY static /home/resume/static
COPY sample.yml /home/resume
COPY templates /home/resume/templates
COPY fonts /usr/share/fonts

RUN sed -i 's/python3/python2.7/g' /home/resume/converters/moderncv.py && \
	sed -i 's/^import sys/import sys\nreload(sys)\nsys.setdefaultencoding("utf-8")/g' /home/resume/converters/moderncv.py
	
VOLUME ["/home/resume/build"]

CMD ["make"]
