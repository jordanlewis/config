export PATH=
if [ -x /usr/libexec/path_helper ]; then
         eval `/usr/libexec/path_helper -s`
fi
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PERL5LIB='/Users/jlewis/.perl'
