# tmux

tmux does two related things:

* split a terminal into panes and tabs
* detach and reattach your terminal from a tmux session

tmux is very similar to gnu screen. they're basically the same program written at two different times. ah well.

people prefer tmux mainly because out-of-the-box, tabs update their title to whatever program is running (open a terminal and run `man`, it will update the title to `man`)

## leader

the leader key is ctrl-b. press ctrl-b then press the command

## sessions

**creating**:
* `tmux new -s session_name`
* or `tmux new` to automatically pick a name (0, 1, 2, 3..)
* or just `tmux`

**listing**:
* `tmux list-sessions`, alias `tmux ls`
* will print "no server running on ..." if there are no sessions.

**editing**
* `tmux rename -t old new`: rename session
* prints "no current client" for some reason but does work
* inside the session: leader + $

**deleting**:
* `tmux kill-session -t (session id)`.
* `tmux kill-server`. closes everything.

**detaching**:
* inside tmux, press the leader key (ctrl-b) then press `d`

**attaching**:
* `tmux attach`, or just `tmux a`. specify a session with `-t`

this is already pretty useful even if you use nothing else from tmux...

## windows

these are like browser tabs

**creating**
* leader + C: create a window

**listing**
* they're listed along the bottom bar
* leader + W: list windows (gets kinda fancy)

**deleting**
* leader + &: kill window. will ask for confirmation
* you can also kill the last pane in a window (leader + x) and it will close

**selecting**
* leader + number 0 through 9: select that window (active window has * after it)
* leader + N: next window
* leader + P: prev window
* the leader + W listing windows is also useful

**editing**
* leader + ,: rename window
* leader + .: renumber window

## panes

splitting the terminal babey

**creating**
* leader + %: vertical split [ | ]
* leader + ": horizontal split [=]

**deleting**
* leader + x: kill pane

**selecting**
* leader + arrows: move one pane
* leader + ;: go to last pane

**editing**
* leader + arrows while still holding ctrl: resize pane (easy to do accidentally)
* leader + !: convert a pane to a window
* leader + z: "zoom" into the current pane, fullscreening it
  * press again to unzoom

## mouse support

mouse support is off by default, can be enabled with

* `tmux set mouse on` (just run it in a terminal, there's no special tmux command line needed)
* in the file `~/.tmux.conf`, write `set -g mouse on`

what does mouse mode enable:

* click on windows to switch to them
* click on panes to focus them
* drag border between panes to resize them
* scroll with mouse wheel
* probably more (i've noticed there is a special tmux selection mode that is different from the native terminal selection, hmm)