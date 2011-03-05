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
zsh \
zshenv \
zshprompt \
zshrc

VIMBUNDLEFILES = \
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

ZSHBUNDLEFILES = zsh-git

DIRNAMES = vimundo

TARGETS = $(patsubst %,$(DEST)/.%,$(CONFIGS))
DIRS    = $(patsubst %,$(DEST)/.%,$(DIRNAMES))

VIMBUNDLES = $(patsubst %,vim/bundle/%/.git,$(VIMBUNDLEFILES))
ZSHBUNDLES = $(patsubst %,zsh/func/%/.git,$(ZSHBUNDLEFILES))

all: build

install: build dirs $(TARGETS)

$(DEST)/.% : %
	@mkdir -p $(dir $@)
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	ln -sf $(PWD)/$* $@

$(DEST)/.%/:
	mkdir -p $@

dirs: $(DIRS)

vim/bundle/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

zsh/func/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

build: bundles

bundles: $(VIMBUNDLES) $(ZSHBUNDLES)

clean:
	@echo Cleaning from $(DEST)
	rm -f $(TARGETS)

.PHONY: build install clean
