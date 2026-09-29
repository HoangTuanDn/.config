# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="dracula"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  kubectl
  artisan
  composer
  zsh-completions
  zsh-autosuggestions
  you-should-use
  zsh-syntax-highlighting
  web-search
#  fzf-tab
)

# fzf-tab configuration
# disable sort when completing `git checkout`
##zstyle ':completion:*:git-checkout:*' sort false
# set list-colors to enable filename colorizing
##zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with eza when completing cd
##zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
##zstyle ':fzf-tab:complete:cd:*' popup-pad 40 0
# don't use escape sequences here, fzf-tab will ignore them
##zstyle ':completion:*:descriptions' format '[%d]'
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
##zstyle ':completion:*' menu no
# use tmux popup for show complete
##zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# zsh completion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# my alias ---------------------------------
alias tpk='dpkg-query -l | grep "^ii" | wc -l'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias pinstall='sudo apt install'
alias glog5='git log --oneline -5'

# change use ls to eza
alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'
#alias ll='ls -alhF'
# -------------------------------------------

# custom variable
code=~/Dn/code
docker=~/Dn/docker
k8s=~/Dn/k8s
dev=/home/tuannh/Data/code/dev

# oh my posh
eval "$(oh-my-posh init zsh --config ~/.poshthemes/tokyonight_storm1.omp.json)"

# kubectl autocompletion
source <(kubectl completion zsh)

# helm autocompletion
source <(helm completion zsh)

# enable support apt command not found
source /etc/zsh_command_not_found

# for rust
export PATH="$HOME/.cargo/bin:$PATH"

# config https://cheat.sh/
fpath=(~/.zsh.d/ $fpath)

# config spicetify
export PATH=$PATH:/home/tuannh/.spicetify

# set up bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# set up less use bat
export LESS="-R"
export LESSOPEN="| bat --color always --style plain %s"

#------------set up fzf--------#
# Tokyo Night Storm colors, background follows the terminal (bg:-1)
# alt-bg/gutter are tuned for the Ptyxis "Monokai Pro" background (#363537)
export FZF_DEFAULT_OPTS="
  --layout=reverse --info=inline-right
  --color='fg:#a9b1d6 fg+:#c0caf5
  bg:-1 bg+:#2e3c64 alt-bg:#3c3b3d gutter:#363537
  hl:#2ac3de hl+:#2ac3de
  pointer:#ff007c marker:#9ece6a
  header:#ff9e64
  spinner:#ff007c info:#737aa2
  prompt:#7aa2f7 query:#c0caf5
  border:#565f89 separator:#414868 scrollbar:#565f89'"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

#source /usr/share/doc/fzf/examples/key-bindings.zsh
#source /usr/share/doc/fzf/examples/completion.zsh
source <(fzf --zsh)

#-------manual add neovim---------#
export PATH="$PATH:/opt/nvim/bin"

#-------manual add laravel---------#
#export PATH="$PATH:/home/tuannh/.config/composer/vendor/bin"

#-------manual add chtfzf---------#
chtfzf() {/usr/local/bin/chtfzf.sh}
zle -N chtfzf
bindkey "^O" chtfzf

#-----
export COREPACK_ENABLE_AUTO_PIN=0

# jetbrain
export PATH="$PATH:/home/tuannh/.local/share/JetBrains/Toolbox/scripts"

# fnm
FNM_PATH="/home/tuannh/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# python uv
. "$HOME/.local/bin/env"


# Added by Antigravity CLI installer
export PATH="/home/tuannh/.local/bin:$PATH"

# opencode
export PATH=/home/tuannh/.opencode/bin:$PATH
