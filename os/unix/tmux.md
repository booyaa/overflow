# tmuxery

use this to track new uses

    history | cut -f5- -d' ' | grep '^tmux' | sort | uniq

current usage

    tmux list-sessions 
    tmux attach -t 5 # how to attach to a session
    tmux new -s foo # create a new session and name
    tmux rename-session -t 0 dthulhu # how to rename a session

todo
- add current tmux.conf

## consolidated from my other notes

###shortcuts

- Ctrl+b " - split pane horizontally.
- Ctrl+b % - split pane vertically.
- Ctrl+b arrow key - switch pane.
- Hold Ctrl+b, don't release it and hold one of the arrow keys - resize pane.
- Ctrl+b c - (c)reate a new window.
- Ctrl+b n - move to the (n)ext window.
- Ctrl+b p - move to the (p)revious window.

###reference

- http://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily
- https://gist.github.com/MohamedAlaa/2961058
- http://blog.hawkhost.com/2010/06/28/tmux-the-terminal-multiplexer/
- http://blog.hawkhost.com/2010/07/02/tmux-–-the-terminal-multiplexer-part-2/
