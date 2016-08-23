typeset -U PATH 
PATH="$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:$PATH"
typeset -U MANPATH
MANPATH="/usr/local/man:$MANPATH"
# virtualenv
source /usr/local/bin/virtualenvwrapper_lazy.sh
# virtualenv env variables
typeset -U WORKON_HOME 
WORKON_HOME=~/.virtualenvs
typeset -U VIRTUALENVWRAPPER_PYTHON 
VIRTUALENVWRAPPER_PYTHON=$(which python3)
