source /usr/share/zsh-antigen/antigen.zsh &> /dev/null || source $HOME/.local/share/zsh-antigen/antigen.zsh &> /dev/null || echo "You need to install antigen first."

# Absolute path of this config
SCRIPT_DIR=$(dirname $(realpath ${(%):-%x}))

# Other paths
CONFIG_DIR=$SCRIPT_DIR/.zshrc.d/

# Antigen plugins
antigen use oh-my-zsh

antigen theme agnoster

antigen bundle cargo
antigen bundle git-extras
antigen bundle npm
antigen bundle pip
antigen bundle python
antigen bundle thefuck
antigen bundle wd
antigen bundle dickeyxxx/gh zsh/gh

antigen apply

# User configuration

# Shell coloring
base16_shell=$SCRIPT_DIR/colors/my-base16.sh
[[ -s $base16_shell ]] && source $base16_shell

# Additional configuration
source $CONFIG_DIR/*

# End user configuration
