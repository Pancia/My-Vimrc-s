source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/functions.zsh

[ -e ~/dotfiles/extra.zsh ] && source ~/dotfiles/extra.zsh

source ~/dotfiles/antigen/antigen.zsh

antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle git-flow
antigen bundle lein
antigen bundle command-not-found
antigen bundle tmux
antigen bundle z
antigen bundle node
antigen bundle npm
antigen bundle python
antigen bundle vi-mode

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

#OSX
antigen bundle brew
antigen bundle brew-cask
antigen bundle osx

# Load the theme.
antigen theme bhilburn/powerlevel9k powerlevel9k.zsh-theme

# Tell antigen that you're done.
antigen apply

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode status time)
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
