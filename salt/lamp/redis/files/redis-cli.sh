#!/bin/bash

# Allocate a pseudo-TTY (-t) if :
# - command is opened on a terminal (test -t 1)
# - standard input is a terminal and not a pipe (tty -s)
(test -t 1 && tty -s) && USE_TTY="-t" 

docker exec -i ${USE_TTY} redis redis-cli "$@"
