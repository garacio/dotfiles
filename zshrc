# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### VARS
fignore=(.)
# oh my zsh options
# ENABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"
COMPLETION_WAITING_DOTS="true"
ZSH_ALIAS_FINDER_AUTOMATIC=true
ZSH_ALIAS_FINDER_FILTER_VALUES="g=|tf=|k="

### zplug
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

# Essential
source ~/.zplug/init.zsh

# zplug "zplug/zplug", hook-build:"zplug --self-manage"

zplug "lib/*", from:oh-my-zsh, ignore:""
zplug "plugins/git", from:oh-my-zsh
#zplug "plugins/git-flow-avh", from:oh-my-zsh
#zplug "plugins/history", from:oh-my-zsh
#zplug "plugins/rsync", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
#zplug "plugins/colorize", from:oh-my-zsh
#zplug "plugins/colored-man-pages", from:oh-my-zsh
#zplug "plugins/z", from:oh-my-zsh
#zplug "plugins/extract", from:oh-my-zsh
#zplug "plugins/common-aliases", from:oh-my-zsh
#zplug "plugins/alias-finder", from:oh-my-zsh
#zplug "plugins/globalias", from:oh-my-zsh
#zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/helm", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh, if:"command -v fzf > /dev/null"
zplug "plugins/terraform", from:oh-my-zsh, if:"command -v terraform > /dev/null"
#zplug "plugins/gcloud", from:oh-my-zsh, if:"command -v gcloud > /dev/null"
#zplug "plugins/copydir", from:oh-my-zsh, if:"[ ! -v SSH_TTY ]"
#zplug "plugins/copyfile", from:oh-my-zsh, if:"[ ! -v SSH_TTY ]"
#zplug "plugins/copybuffer", from:oh-my-zsh, if:"[ ! -v SSH_TTY ]"
#zplug "plugins/docker", from:oh-my-zsh, if:"command -v docker > /dev/null"
#zplug "plugins/docker-compose", from:oh-my-zsh, if:"command -v docker-compose > /dev/null"
# zplug "themes/robbyrussell", from:oh-my-zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1

# zplug "zsh-users/zsh-completions"
# поиск в истории по подстроке по кнопкам вверх/вниз
zplug "zsh-users/zsh-history-substring-search"
# серым в строке ввода подсказывает команду, по стрелке вправо - дополняет ее
zplug "zsh-users/zsh-autosuggestions"
# раскрашивает вводимые команды
# zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zdharma/fast-syntax-highlighting"
# подтягиваем bash completions
zplug "3v1n0/zsh-bash-completions-fallback"


# install plugins if there are plugins that have not been installed
# doesn't work with Powerlevel10k instant prompt, so install without prompt
# if ! zplug check; then
#   if [[ -v SSH_TTY ]]; then
#     zplug install
#   else
#     zplug check --verbose
#     printf "Install? [Y/n]: "
#     read -k 1 install
#     case $install in
#       [nN]) ;;
#       *) echo; zplug install
#     esac
#   fi
# fi
if ! zplug check; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load


### KEYS
# zsh-history-substring-search - fish behavior on up
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# make `Ctrl + Right` behave the same as in bash
# autoload -U select-word-style
# select-word-style bash
bindkey '\ef' emacs-forward-word
# Make `Ctrl + W` and `Ctrl + Alt + H` in zsh behave the same as in bash
autoload -Uz backward-kill-word-match

bindkey '^W' backward-kill-space-word
zle -N backward-kill-space-word backward-kill-word-match
zstyle :zle:backward-kill-space-word word-style space

bindkey '^[^H' backward-kill-bash-word
zle -N backward-kill-bash-word backward-kill-word-match
zstyle :zle:backward-kill-bash-word word-style bash


### zsh OPTS
# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc
setopt extendedglob
# complete dotfiles
# setopt globdots
# do not remove slash at the end
unsetopt autoremoveslash


### ADDONS
if command -v pacman > /dev/null; then
  # completio update on pacman install
  zshcache_time="$(date +%s%N)"

  autoload -Uz add-zsh-hook

  rehash_precmd() {
    if [[ -a /var/cache/zsh/pacman ]]; then
      local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
      if (( zshcache_time < paccache_time )); then
        rehash
        zshcache_time="$paccache_time"
      fi
    fi
  }

  add-zsh-hook -Uz precmd rehash_precmd

  # The "command not found" handler for pacman
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### ssh/xxh magic
if [[ -v SSH_TTY ]]; then
  ### Linux distro detect
  function prompt_my_os_name() {
    p10k segment -f yellow -t "${_MY_OS_NAME}"
  }

  # PROMPT="%{$fg[green]%}%n@%m%{$reset_color%} ${PROMPT}"
  if [[ ! -f ~/.p10k.zsh && -v XXH_HOME ]]; then
    cp $(dirname ${pluginrc_file:-.})/p10k.zsh ~/.p10k.zsh
    source ~/.p10k.zsh
  fi

  if [[ -r /etc/os-release ]]; then
    local lines=(${(f)"$(</etc/os-release)"})
    lines=(${(@M)lines:#PRETTY_NAME=*})
    (( $#lines == 1 )) && _MY_OS_NAME=${lines[1]#PRETTY_NAME=}
    # [ -v _MY_OS_NAME ] && _MY_OS_NAME="on ${_MY_OS_NAME//\"/}"
    local els=()
    for el in $POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS; do
      els+=$el
      if [ "$el" == "context" ]; then
        els+=my_os_name
      fi
    done
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=($els)
  fi

  export EDITOR="vim"
  ZSH_THEME_TERM_TAB_TITLE_IDLE="%m: %~"
else
 export EDITOR="code -w"
fi

# Suppress warning on console output when using Powerlevel10k with instant prompt
#typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# print timestamp with transient prompt to the right prompt
#POWERLEVEL9K_TRANSIENT_PROMPT=off
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=time
#function p10k-on-pre-prompt() {
#  # Show empty line if it's the first prompt in the TTY.
#  [[ $P9K_TTY == old ]] && p10k display 'empty_line'=show
#  # Show the first prompt line.
#  p10k display '1|*/left_frame'=show '2/right/time'=hide
#}

#function p10k-on-post-prompt() {
#  # Hide the empty line and the first prompt line.
#  p10k display 'empty_line|1|*/left_frame'=hide '2/right/time'=show
#}

# fix z: _z_dirs:2: no such file or directory: /home/xxx/.z
[[ ! -f ~/.z ]] || touch ~/.z


export PATH=~/.local/bin:~/bin:${HOME}/.krew/bin:${HOME}/Library/Python/3.9/bin:$PATH
export HELM_HOME=~/.config/helm/
export GLOBALIAS_FILTER_VALUES=(ls k z grep egrep cp rm mv)
export FZF_CTRL_T_COMMAND='find . -not -path "./.git/*"'
export FZF_ALT_C_COMMAND='find . -type d -not -path "./.git/*"'



# function ssh-ctx () {
#   if [ -z $1 ]; then
#     ls -1 ~/.ssh/* | grep -E '.*id_rsa_([a-z]*)$' | sed -E 's/.*id_rsa_([_a-z]*)$/\1/'
#   else
#     ssh-add -D && ssh-add ~/.ssh/id_rsa_$1
#   fi
# }
#

source ~/dotfiles/profile.sh
