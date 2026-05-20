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
eval "$(/opt/homebrew/bin/brew shellenv)"

#export GOPACKAGESDRIVER=/Users/jordan/dev/cockroach/build/bazelutil/gopackagesdriver.sh

export NVM_DIR="$HOME/.nvm"

# Lazy-load NVM for faster shell startup
# Add default node to PATH immediately (no nvm overhead)
if [ -s "$NVM_DIR/alias/default" ]; then
  _nvm_version=$(cat "$NVM_DIR/alias/default")
  # Resolve alias to actual version path (handles "20" -> "v20.x.x")
  _nvm_path=$(ls -d "$NVM_DIR/versions/node/v${_nvm_version}"* 2>/dev/null | tail -1)
  [ -n "$_nvm_path" ] && PATH="$_nvm_path/bin:$PATH"
  unset _nvm_version _nvm_path
fi

# Wrapper functions that load nvm on first use (interactive shells only).
# Non-interactive shells (e.g. Claude Code's Bash tool) skip these and use
# the real binaries already on PATH from the block above.
if [[ -o interactive ]]; then
  _load_nvm() {
    unset -f nvm node npm npx 2>/dev/null
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  }
  nvm() { _load_nvm && nvm "$@"; }
  node() { _load_nvm && node "$@"; }
  npm() { _load_nvm && npm "$@"; }
  npx() { _load_nvm && npx "$@"; }
fi

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
