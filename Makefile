TPL ?= templates/moderncv.tpl
QUOTE ?= 
STYLE ?= classic
PHONE ?= 13*~****~**60
EMAIL ?= me@annhe.net
HOMEPAGE ?= www.annhe.net
GITHUB ?= annProg
COLOR ?= blue
ALL_STYLE = casual classic oldstyle banking fancy
ALL_COLOR = blue orange green red purple grey black
PHOTO ?= static/photo.png
YAML ?= sample.yml
BUILD = build
PREVIEW = preview
WORK ?= work
REPO ?= annprog/resume-template
TAG ?= latest
PWD := $(shell pwd)

ARCH := $(shell uname -s)

ifeq ($(ARCH), Linux)
	FONT := WenQuanYi Micro Hei
else
	FONT := SimSun
endif

FONT ?= $(FONT)
FONTSET ?= $(FONTSET)

all: all-moderncv clean

moderncv:
	test -d $(BUILD) || mkdir -p $(BUILD)
	./converters/moderncv.py $(YAML) $(STYLE) > $(BUILD)/moderncv-$(STYLE).md
	enca -L zh_CN -x UTF-8 $(BUILD)/moderncv-$(STYLE).md
	pandoc $(BUILD)/moderncv-$(STYLE).md -o $(BUILD)/moderncv-$(STYLE)-$(COLOR).tex \
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
	cd $(BUILD) && \
	xelatex moderncv-$(STYLE)-$(COLOR).tex
	
sub-moderncv-%:
	$(MAKE) STYLE=$* moderncv
	
all-moderncv: $(addprefix sub-moderncv-,$(ALL_STYLE))

docker:
	docker build -t $(REPO):$(TAG) .

run-docker:
	test -d $(BUILD) || mkdir -p $(BUILD)
	test -d $(WORK) || mkdir -p $(WORK)
	docker run -it --rm -v /usr/share/fonts:/usr/share/fonts/fonts -v $(PWD)/$(BUILD):/home/resume/$(BUILD) -v $(PWD)/$(WORK):/home/resume/$(WORK) $(REPO):$(TAG) /init.sh $(TPL) $(STYLE) $(PHONE) $(EMAIL) $(HOMEPAGE) $(GITHUB) $(COLOR) $(PHOTO) $(YAML) $(WORK) "$(FONT)" "$(QUOTE)"

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
