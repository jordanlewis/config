# Set up darwinports path
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# Set up manpath
export MANPATH=/usr/local/man/:/opt/local/man/:$MANPATH
# Turn on keychain
keychain ~/.ssh/id_rsa
source ~/.keychain/paneer-sh > /dev/null
