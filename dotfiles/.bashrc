# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# VARIABLES
##############################################################################
export mac_address=$(ifconfig -a | grep -E "ether.*(Ethernet)" | awk '{print $2}')

# caffe
export PYTHONPATH="${PYTHONPATH}:/opt/movidius/caffe/python"

if [ ! -f ~/.inputrc ]
then
echo "Not found, creating..."
cat <<EOF > ~/.inputrc
\$include /etc/inputrc
# enable search backward/forward through bash history
"\e[A": history-search-backward
"\e[B": history-search-forward

# This line sets the completions to be listed immediately instead of ringing the bell, when the completing word has more than one possible completion.
set show-all-if-ambiguous on

# This line sets the completions to be listed immediately instead of ringing the bell, when the completing word has more than one possible completion but no partial completion can be made
set show-all-if-unmodified on

# performs filename matching and completion in a case-insensitive fashion
set completion-ignore-case on

# This line sets 3 to be the maximum number of characters to be the common prefix to display for completions
set completion-prefix-display-length 3

# This line sets every completion which is a symbolic link to a directory to have a slash appended
set mark-symlinked-directories on

# This line sets readline to display possible completions using different colors to indicate their file types
set colored-stats on
EOF
fi

# camos multi-screen monitor
monitor ()  {
	if [ -z $1 ]
	then
		session=$USER
	else
		session=$1
	fi

	if [ -z "$(byobu list-sessions | grep $session)" ]
	then
		# Create new session
		byobu-tmux new-session -n 'CamOS monitor' -s $session -d
		byobu-tmux split-window -h
		byobu-tmux select-pane -t 0
		byobu-tmux split-window -v

		# pane 0: sender service logs
		byobu-tmux select-pane -t 0
		byobu-tmux send-keys 'camos_sender' 'C-m'

		# pane 1: apps information
		byobu-tmux select-pane -t 1
		byobu-tmux send-keys 'camos_app' 'C-m'

		# pane 2: subscriber service logs
		byobu-tmux select-pane -t 2
		byobu-tmux send-keys 'camos_subscriber' 'C-m'

		# Create new window for other tasks
		byobu-tmux new-window
		byobu-tmux rename-window 'Working terminals'
	fi

	# enter working session
	byobu-tmux attach -t $session
}

# ALIASES
##############################################################################
alias python="python3"
alias pip="python3 -m pip"
alias vi=vim
alias top=htop
alias rpi-temp="watch -d -n 1 /opt/vc/bin/vcgencmd measure_temp"

# camos shortcuts
alias camos_subscriber="sudo journalctl -u camos_subscriber.service -f | ccze"
alias camos_sender="sudo journalctl -u camos_sender.service -f | ccze"
alias camos_loader="sudo journalctl -u camos_loader.service -f | ccze"
alias camos_starter="sudo journalctl -u camos_starter.service -f | ccze"
alias camos_updater="sudo journalctl -u camos_updater.service -f | ccze"
alias camos_monitor="sudo journalctl -u camos_monitor.service -f | ccze"
alias camos_recognizer="sudo journalctl -u camos_recognizer.service -f | ccze"
alias camos_publisher="sudo journalctl -u camos_publisher.service -f | ccze"
alias camos_app="watch -d -n 1 camos -a"

camos_service () {
	if [ -z $1 ]
	then
		action=status
	else
		action=$1
	fi

	for service in camos_{sender,loader,subscriber,starter,updater,monitor,recognizer,publisher};
	do
		sudo systemctl $action $service;
	done
}

camos_config () {
	camos -c --key=$1 --value=$2
}
