# Set up darwinports path
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:/sw/bin:$PATH
# Set up manpath
export MANPATH=/usr/local/man/:/opt/local/man/:$MANPATH
# Turn on keychain
keychain ~/.ssh/id_dsa ~/.ssh/id_rsa
source ~/.keychain/chana-sh > /dev/null
