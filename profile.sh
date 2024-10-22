export PATH=$HOME/bin:/usr/local/bin:/home/dkr/bin/bin:/home/dkr/bin/python39/bin:/usr/local/go/bin:~/go/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH
export LC_ALL=en_US.UTF-8

if [[ -r "$HOME/.personal.zsh" ]]; then
  source "$HOME/.personal.zsh"
fi


alias ap="ansible-playbook -D"

export WORKON_HOME=~/.pyenv

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# eval $(keychain --eval --agents ssh id_rsa)

alias ll='ls -l'
alias lla="ls -la "
alias la='ls -A'
alias l='ls -CF'

# git aliases
alias ga="git add"
alias gst="git status"
alias gc="git commit"
alias gp="git pull --rebase"
alias gdf="git diff --stat"
alias gd="git diff"
alias gdc="git diff --cached"

# apt aliases
alias agu='sudo apt-get update'
alias agup='sudo apt-get upgrade'
alias agi='sudo apt-get install'
alias acs='sudo apt-cache search'

# docker aliases
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dex="docker exec -i -t"
alias dl="docker logs -ft --tail=100"

function tf { terraform $@ -parallelism=100 }

alias aria="aria2c --max-connection-per-server=4 --min-split-size=1M --file-allocation=none "

# kubectl aliases
alias k=kubectl
alias kg="kubectl get"
alias kd="kubectl describe"
alias kl="kubectl logs"

# Remove all containers
drm() { docker rm $(docker ps -a -q); }
# Remove all images
dri() { docker rmi $(docker images -q); }
# Sh into running container
dsh() { docker exec -it "$1" /bin/sh; }
# Bash into running container
dbash() { docker exec -it "$1" /bin/bash; }
dins() { docker inspect "$1" | less; }

# source $(multiwerf use 1.2 ea --as-file)
