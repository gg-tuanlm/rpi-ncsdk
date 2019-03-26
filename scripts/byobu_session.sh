#!/bin/bash

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

