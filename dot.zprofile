# Set up darwinports path
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=~/bin:$PATH

# Turn on keychain
keychain ~/.ssh/id_rsa
source ~/.keychain/paneer-sh > /dev/null
