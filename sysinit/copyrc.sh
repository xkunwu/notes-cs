#!/bin/bash

SERVER=${1:-palau}

scp ~/.vimrc ~/.tmux.conf ${SERVER}:~

