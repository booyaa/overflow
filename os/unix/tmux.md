# tmuxery

use this to track new uses

    history | cut -f5- -d' ' | grep '^tmux' | sort | uniq

current usage

    tmux list-sessions 
    tmux attach -t 5 # how to attach to a session
    tmux new -s foo # create a new session and name
    tmux rename-session -t 0 dthulhu # how to rename a session
