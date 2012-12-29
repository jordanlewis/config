# .zshrc by Jordan Lewis

# Environment variables {{{
HISTFILE=~/.zshhistory            # What histfile are we using?
HISTSIZE=100000                   # Big = better
SAVEHIST=7000                     # When to save to the file?
export SHELL=`which zsh`                 # New shells don't open bash
export EDITOR=vim                        # Use vim!
export GREP_OPTIONS='--color=auto'       # Color my greps
export GOROOT=$HOME/go
export GOOS=darwin
export GOARCH=amd64
if [ $(uname) = Linux ]; then 
    alias ls='ls --color=auto'
else
    export CLICOLOR=1
fi
export NNTPSERVER=news-server.nyc.rr.com # Use my ISP's news server
export PERL5LIB='/Users/jlewis/.perl/'
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
export PLY_HOME=~/ext/ply/dist/ply
export PATH=~/bin:~/go/bin:$PLY_HOME/bin:/usr/local/share/python:/usr/local/bin:/usr/local/sbin:$PATH

typeset -U PATH

# }}}
# Setopts {{{
setopt auto_cd             # If I type a directory, assume I mean to cd to it
setopt auto_pushd          # Automatically push directories onto the stack
setopt badpattern          # Print an error message on badly formed glob
#setopt cdablevars          # So we can cd to metachars like ~
setopt correct             # Attempt typo corrections
setopt complete_in_word    # 
#setopt extended_glob       # Allow ~ # ^ metachars in globbing
# disabled - this makes it so you can't use the ^ revision spec thing with git!
setopt extended_history    # More information in history
setopt hist_ignore_space   # Don't put space-prepended commands in the history
setopt interactivecomments # Allow comments even in the interactive shell
setopt listpacked          # Menucomplete can use different col widths
setopt magicequalsubst     # echo foo=~/bar -> foo/home/jlewis/bar
#setopt markdirs            # Append / to all glob-completed dirs
# disabled - given a dirtree foo/bar/baz.txt, cp -R foo/* /tmp/ causes baz.txt
# to be sent to /tmp/. no good!
setopt multios             # Allow multiple redirection!
setopt nobeep              # Don't beep
setopt no_flowcontrol      # No stupid flow control!
setopt nullglob            # Delete a glob if it doesn't match anything
setopt promptsubst
setopt pushd_ignore_dups   # Don't push multiple copies of a directory
# }}}
# Autoloads {{{
autoload -U compinit; compinit
autoload -U predict-on
autoload -U edit-command-line
autoload -U copy-earlier-word
autoload -U add-zsh-hook
# }}}
# Zle {{{
zle -N predict-on;
zle -N predict-off;
zle -N edit-command-line
zle -N copy-earlier-word
# }}}
# Zstyles {{{
zstyle ':completion::complete:*' use-cache 1 # uses completion cache
zstyle ':completion::complete:*' cache-path ~/.zshcache
zstyle ':completion:*' menu select # menu-style completion
zstyle ':completion:*:functions' ignored-patterns '_*' # no missing completions
# }}}
# Bindkeys {{{
bindkey -v                       # Use vim bindings
bindkey "^A" beginning-of-line   # Like in bash, for memory
bindkey "^B" beginning-of-line   # This won't be screwed up by screen, but weird
bindkey "^E" end-of-line         # Like in bash
bindkey "^N" accept-and-infer-next-history # Enter; pop next history event
bindkey "^O" push-line           # Pushes line to buffer stack
bindkey "^P" get-line            # Pops top of buffer stack
bindkey "^R" history-incremental-search-backward # Like in bash, but should !
bindkey "^T" transpose-chars     # Transposes adjacent chars
bindkey "^Y" copy-earlier-word
bindkey "^Z" accept-and-hold     # Enter and push line
bindkey " " magic-space          # Expands from hist (!vim )
bindkey "^\\" pound-insert       # As an alternative to ctrl-c; will go in hist
bindkey "\e[3~" delete-char      # Enable delete
#bindkey "^Q" predict-off        # Disable sweet complete-as-you-type
#bindkey "..." predict-on         # Enable sweet complete-as-you-type

# }}}
# Aliases {{{
# Misc {{{
alias cp='nocorrect cp'        # Don't correct this cmd
alias mkdir='nocorrect mkdir'  # Don't correct this cmd
alias mv='nocorrect mv'        # Don't correct this cmd
alias touch='nocorrect touch'  # Don't correct this cmd
alias git='nocorrect git'
alias sl='sl -l'               # ... dumb
alias termcast='telnet 213.184.131.118 37331'   # noway.ratry.ru 37331
alias slurp='wget -r --no-parent'
alias deflac='for file in *.flac; do $(flac -cd "$file" | lame -V 0 --vbr-new - "${file%.flac}.mp3"); done'   # convert all flacs in directory to v0
# }}}
# Shells {{{
alias bh='ssh root@bughouse.econnectix.com'
alias bhsec='ssh jlewis@bhsec.bard.edu'
alias ch='ssh root@cheaphotel.econnectix.com'
#alias chana='ssh jlewis@192.168.0.3'           # chana, my mbp.. need dyndns
alias cs='ssh jalewis@altair.cs.uchicago.edu'
alias echoduet='ssh jlewis@echoduet.net'
alias econ='ssh jlewis@mail.econnectix.com'
#alias enwina='ssh -X 192.168.0.2'               # This is/was my HP
alias harper='TERM=xterm ssh jalewis@harper.uchicago.edu'
alias mookmo='ssh jlewis@mookmo.net'
alias sartak='ssh toft@sartak.org'
alias sd='ssh jlewis@silenceisdefeat.com'
alias yiff='ssh eidolos@yiff.mit.edu'
# }}}
# Games {{{
alias cao='TERM=rxvt telnet crawl.akrasiac.org' # urxvt-color screws up
alias nao='TERM=rxvt telnet nethack.alt.org'    # urxvt-color screws up
alias sco='TERM=rxvt telnet slashem.crash-override.net'
alias spork='TERM=rxvt telnet sporkhack.nineball.org'
# }}}
# Shortcuts {{{
alias '..'='cd ..'               # cd .. takes too much effort!
alias 'web'='python -m SimpleHTTPServer' # hosts . on :8000
alias bc='bc -q -l'              # no warranty thing; loads math lib
alias broadcast='ifconfig | grep broadcast | tail -c 16'
alias cls='perl -e "print \"\e[2J\""' # prints a clearscreen - for termcast
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias hide='xset dpms force standby; exit' # kills my LCD monitor
alias l='ls'                     # sometimes I think I'm still on a MUD/MOO
alias mouse='xmodmap -e "pointer = 1 2 3 6 7 8 9 10 4 5"' # fixes my buttons
alias ncscan='nc -v -z'          # scans ports with netcat
alias nmapscan='nmap -p'         # scans ports with nmap
alias probe='ping -i 50 `ifconfig | grep broadcast | tail -c 16`'
alias reload='source ~/.zshrc'   # re-sources this
alias restartx='sleep 5; startx' # restarts X!
alias tdA="todo -A"              # displays all todo items
alias usage='du -hs *'           # nicely displays disk usage of items in pwd
which htop>/dev/null && alias top='htop' # prettier version of top if it exists
# }}} 
# Global shortcuts {{{
alias -g ...='../..'             # Ease of going backward
alias -g ....='../../..'         # Yes
alias -g .....='../../../..'     # YES
alias -g G='|egrep'              # cat biglongfile G cheese
alias -g H='|head'               # cat biglongfile H
alias -g L='|less'               # cat biglongfile L
alias -g T='|tail'               # cat biglongfile T
alias -g W='|wc'                 # cat biglongfile W
# }}}
# }}}
# }}}
# Prompt {{{
source ~/.zshprompt
# }}}

# Print to stdout {{{
fortune 2>/dev/null || return 0 # essential!
# }}}
alias dotperl='rsync -av lib/* ~/.perl/'
