if [ -x /usr/libexec/path_helper ]; then
         eval `/usr/libexec/path_helper -s`
fi
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

fpath=($fpath $HOME/.zsh/func)
for f in $HOME/.zsh/func/* $HOME/.zsh/func/*/*; do
    if [ -d $f ]; then
        fpath=($fpath $f)
    fi
done
typeset -U fpath
