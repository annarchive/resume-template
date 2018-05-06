TYPE ?= moderncv
PHONE ?= 13*~****~**60
EMAIL ?= me@annhe.net
HOMEPAGE ?= www.annhe.net
GITHUB ?= annProg
PHOTO ?= static/photo.png
YAML ?= sample.yml
BUILD = build
PREVIEW = preview
WORK ?= work
REPO ?= annprog/resume-template
TAG ?= latest
PWD := $(shell pwd)
SED_I = sed -i -r

ARCH := $(shell uname -s)

ifeq ($(ARCH), Linux)
	FONT := WenQuanYi Micro Hei
	QUOTE=$(shell ./converters/quote.py $(YAML))
else
	FONT := SimSun
	QUOTE=$(shell ./converters/quote.py $(YAML) |iconv -f gbk -t utf-8)
endif

FONT ?= $(FONT)

# moderncv 相关变量
ifeq ($(TYPE), moderncv)
	TPL ?= templates/moderncv.tpl
	STYLE ?= classic
	COLOR ?= blue
	ALL_STYLE = casual classic oldstyle banking fancy
	ALL_COLOR = blue orange green red purple grey black
endif

# limecv 相关变量
ifeq ($(TYPE), limecv)
	TPL ?= templates/limecv.tpl
	STYLE = none
	COLOR = none
endif

all: all-moderncv limecv clean

pdf:
	test -d $(BUILD) || mkdir -p $(BUILD)
	./converters/converter.py $(TYPE) $(YAML) $(STYLE) > $(BUILD)/$(TYPE)-$(STYLE).md
	enca -L zh_CN -x UTF-8 $(BUILD)/$(TYPE)-$(STYLE).md
	pandoc $(BUILD)/$(TYPE)-$(STYLE).md -o $(BUILD)/$(TYPE)-$(STYLE)-$(COLOR).tex \
	--template=$(TPL) \
	-V photo=$(PHOTO) \
	-V mobile=$(PHONE) \
	-V email=$(EMAIL) \
	-V homepage=$(HOMEPAGE) \
	-V github=$(GITHUB) \
	-V color=$(COLOR) \
	-V font="$(FONT)" \
	-V quote="$(QUOTE)" \
	-V style=$(STYLE)
	cp -f $(PHOTO) $(BUILD)/photo.png
	# pandoc不能正确处理latex命令选项
	cd $(BUILD) && \
	$(SED_I) 's|\{\[\}|\[|g' $(TYPE)-$(STYLE)-$(COLOR).tex && \
	$(SED_I) 's|\{\]\}|\]|g' $(TYPE)-$(STYLE)-$(COLOR).tex && \
	xelatex $(TYPE)-$(STYLE)-$(COLOR).tex
	
moderncv: 
	$(MAKE) TYPE=moderncv pdf
	
# limecv需要编译2遍
limecv:
	$(MAKE) TYPE=limecv pdf
	$(MAKE) TYPE=limecv pdf
	
sub-moderncv-%:
	$(MAKE) STYLE=$* moderncv
	
all-moderncv: $(addprefix sub-moderncv-,$(ALL_STYLE))

docker:
	docker build -t $(REPO):$(TAG) .

run-docker-common:
	test -d $(BUILD) || mkdir -p $(BUILD)
	test -d $(WORK) || mkdir -p $(WORK)
	docker run -it --rm -v /usr/share/fonts:/usr/share/fonts/fonts -v $(PWD)/$(BUILD):/home/resume/$(BUILD) -v $(PWD)/$(WORK):/home/resume/$(WORK) $(REPO):$(TAG) /init.sh $(TYPE) $(STYLE) $(PHONE) $(EMAIL) $(HOMEPAGE) $(GITHUB) $(COLOR) $(PHOTO) $(YAML) $(WORK) "$(FONT)" "$(QUOTE)" $(TPL)

run-docker-limecv:
	$(MAKE) TYPE=limecv run-docker-common

run-docker-moderncv:
	$(MAKE) TYPE=moderncv run-docker-common

run-docker:
	$(MAKE) run-docker-limecv
	$(MAKE) run-docker-moderncv

enter-docker:
	docker run -it --rm -v $(PWD)/$(BUILD):/home/resume/$(BUILD) -v $(PWD)/$(WORK):/home/resume/$(WORK) -v /usr/share/fonts:/usr/share/fonts/fonts $(REPO):$(TAG)
	
preview:
	test -d $(PREVIEW) || mkdir -p $(PREVIEW)
	for pdf in `ls $(BUILD)/*.pdf`; \
	do \
		n=`echo $$pdf|cut -f2 -d'/' |cut -f1 -d'.'`; \
		pdftopng $$pdf $(PREVIEW)/$$n; \
	done
	
clean:
	cd $(BUILD) && rm -f *.out *.aux *.log *.tex *.md
