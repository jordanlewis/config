# Set up darwinports path
#export PATH=/opt/local/bin:/opt/local/sbin:/sw/bin:$PATH
# Set up fink paths
#. /sw/bin/init.sh
# Set up local bin path
#export PATH=~/bin:/usr/texbin:/usr/local/bin:$PATH
# Set up manpath
export TERM=rxvt
export MANPATH=/usr/local/man/:/opt/local/man/:$MANPATH
# Turn on keychain
/sw/bin/keychain ~/.ssh/id_dsa ~/.ssh/identity
source ~/.keychain/chana-sh > /dev/null
