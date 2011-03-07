DEST = $(HOME)

# Dotfiles, as they appear in the repo. Each one will be linked to the
# filename you get by prefixing "~/.".
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

# The names of the pathogen bundles we want to install. These are kept as
# submodules in vim/bundle/, and are updated when we install.
PATHOGENBUNDLENAMES = \
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

TARGETS = $(patsubst %,$(DEST)/.%,$(CONFIGS))

# Add bin/hub etc
TARGETS += $(DEST)/bin/hub

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

bin/hub:
	mkdir -p bin
	curl http://chriswanstrath.com/hub/standalone -sLo bin/hub && chmod +x bin/hub

vim/bundle/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

zsh/func/%/.git:
	git submodule update --init --recursive $(patsubst %/.git,%,$@)

build: bundles bin/hub

bundles: $(PATHOGENBUNDLES) $(ZSHBUNDLES)

clean:
	@echo Cleaning from $(DEST)
	rm -f $(TARGETS)

.PHONY: build install clean
