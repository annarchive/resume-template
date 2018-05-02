TPL ?= templates/moderncv.tpl
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
REPO ?= annprog/resume-template
TAG ?= latest

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
	-V style=$(STYLE)
	cp -f $(PHOTO) $(BUILD)/photo.png
	cd $(BUILD) && \
	xelatex moderncv-$(STYLE)-$(COLOR).tex
	
sub-moderncv-%:
	$(MAKE) STYLE=$* moderncv
	
all-moderncv: $(addprefix sub-moderncv-,$(ALL_STYLE))

docker:
	docker build -t $(REPO):$(TAG) .

clean:
	cd $(BUILD) && rm -f *.out *.aux *.log *.tex *.md
