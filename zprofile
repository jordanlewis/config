# Turn on keychain
if which keychain>/dev/null; then
  keychain ~/.ssh/id_rsa
  source ~/.keychain/$(hostname)-sh > /dev/null
fi

export HOMEBREW_AUTO_UPDATE_SECS=120
export GOPATH="$HOME/go"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=~/bin:/usr/local/go/bin:~/.cargo/bin:/usr/local/share/python:/usr/local/bin:/usr/local/sbin:${GOPATH//://bin:}/bin:$PATH
export PATH="$HOME/.yarn/bin:$PATH:$GOPATH/src/github.com/cockroachlabs/production/crl-prod:$GOPATH/src/github.com/cockroachdb/cockroach/bin"
#export PATH="/usr/local/opt/ccache/libexec:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
typeset -U PATH
export PATH="/usr/local/opt/openjdk/bin:$PATH"
