#############################
#  Do not edit this file.   #
#  File managed by salt.    #
#############################

# Basic commands
alias grep='grep --color=tty'
alias ls='/bin/ls -A --color=auto -hp --time-style="+%F %T"'
alias ll='ls -al'
alias rf='readlink -f'
alias vi='vim'
alias diff='colordiff -b -B -r --exclude=.svn --exclude=.git'
alias hgrep='history | grep'

# cloud9 Aliases
alias cloud9GetPublicIP="curl http://169.254.169.254/latest/meta-data/public-ipv4 && echo ''"
alias cloud9EC2Reboot='aws ec2 reboot-instances --instance-ids="$(curl http://169.254.169.254/latest/meta-data/instance-id)"'

# DOCKER d or dc
alias dps='docker ps'
alias dc='docker-compose'
alias dcup='dc up -d --remove-orphans'
alias dcstart='dc start'
alias dcrestart='dc restart'
alias dcstop='dc stop'
alias dcdown='dc down --volumes --remove-orphans'

# fast find
alias ff='find . -name $1'

# change directories easily
alias cdenv="cd ~/environment/"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# GIT g
alias gs='git status -sb'
alias gd='git diff'
alias gco='git checkout'
alias ga='git add'
alias gap='git add -p'
alias grm='git rm'
alias gb='git branch -v'
alias gc='git commit'
alias gca='git commit --amend'
alias gcm='git commit -m'
alias gll='git pull'
alias gsh='git push'
alias glog='git log --graph --pretty=format:"%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'