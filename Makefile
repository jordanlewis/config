DEST = $(HOME)

CONFIGS = \
Xdefaults \
Xmodmap \
config/awesome/rc.lua \
gitconfig \
screenrc \
vim \
vimrc \
zprofile \
zshenv \
zshprompt \
zshrc

BUNDLEFILES = \
Color-Sample-Pack \
EnhCommentify.vim \
histwin.vim \
matchit \
OmniCppComplete \
vim-endwise \
vim-fugitive \
vim-git \
vim-surround \
vim-unimpaired \


TARGETS = $(patsubst %,$(DEST)/.%,$(CONFIGS))

BUNDLES = $(patsubst %,vim/bundle/%/.git,$(BUNDLEFILES))

all: build

install: build $(TARGETS)

$(DEST)/.% : %
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	ln -sf $(PWD)/$* $@

vim/bundle/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

build: bundles

bundles: $(BUNDLES)

clean:
	@echo Cleaning from $(DEST)
	rm -f $(TARGETS)

.PHONY: build install clean
