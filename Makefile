DEST = $(HOME)

# Dotfiles, as they appear in the repo. Each one will be linked to the
# filename you get by prefixing "~/.".
CONFIGS = \
Xdefaults \
Xmodmap \
config/awesome/rc.lua \
config/karabiner \
gitconfig \
fzf.zsh \
pythonstartup \
screenrc \
spacemacs \
vim \
vimrc \
zprofile \
zsh \
zshenv \
zshprompt \
zshrc

# The names of the pathogen bundles we want to install. These are kept as
# submodules in vim/bundle/, and are updated when we install.
PATHOGENBUNDLENAMES = $(shell git submodule status | cut -d' ' -f3 | grep vim | cut -d'/' -f3)

ZSHBUNDLEFILES =

TARGETS = $(patsubst %,$(DEST)/.%,$(CONFIGS))

PATHOGENBUNDLES= $(patsubst %,vim/bundle/%/.git,$(PATHOGENBUNDLENAMES))
ZSHBUNDLES = $(patsubst %,zsh/func/%/.git,$(ZSHBUNDLEFILES))

all: build

install: build $(TARGETS) ~/.vimundo

$(DEST)/.% : %
	@mkdir -p $(dir $@)
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	ln -sf $(PWD)/$* $@

$(DEST)/.%/:
	mkdir -p $@

$(DEST)/% : %
	@mkdir -p $(dir $@)
	@[ ! -e $@ ] || [ -h $@ ] || mv -f $@ $@.bak
	ln -sf $(PWD)/$* $@

zsh/antigen.zsh:
	curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > zsh/antigen.zsh

vim/bundle/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

zsh/func/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

build: bundles

bundles: $(PATHOGENBUNDLES) $(ZSHBUNDLES)

clean:
	@echo Cleaning from $(DEST)
	rm -f $(TARGETS)

.PHONY: build install clean
