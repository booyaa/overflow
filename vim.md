# take me to your leader

`<leader>` by default is backslash, you can remap it , using `let mapleader=","`

# symbols

toggle between showing and hiding symbols

```vimrc
nmap <leader>l :set list!<CR>
```

define symbols (textmate's defaults)


```
set listechars=tab: \ ,eol:¬
:help listchars
```


how to enter special chars, must be in insert mode
```
ctrl-v u00ac = ¬
ctrl-v u25b8 = ▸
ctrl-v ctrl-i = 	
```

# tabs and spaces

ts tabstop
sts softtabstop = allows backspace to delete tabs and indentations, default is just to remove space
sw shiftwidth = how many spaces to indent using <>
(no)expandtab = converts tabs into spaces

defaults

```vimrc
set ts=8 sw=8 noexpandtab " vim defaults, tabstop is 8, softtabstop = 0, shiftwidth = 8, noexpandtab
```

keep tabstop, softtabstop and shiftwidth the same to be consistent.

useful script can be found on [vimcast #2](http://vimcasts.org/episodes/tabs-and-spaces/)

# windows

```
:help c-w - prefix for window related help
c-w s - horizon split
c-w v - vertical split
:sp file.txt - edit new file and split horizontal (long form is :edit file.txt, c-w s)
* :vsp file.txt - edit new file and split vert
:q - to close current window
* :only - to close other windows except this one
c-w arrow keys/hjkl - to nav

.vimrc mappings
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

* c-w w - cycle through windows
c-w +/- - to increase or decrease current
mouse - is often quicker to resize
c-w = - to equalise all windows
c-w _ - maximise current window horiz
c-w r - rotate windows
c-w R - reverse
c-w x - swap current window and neighbour
c-w HJKL
```


#vim

##todo

- install fugitive
- git init gitignore template for go?
- swap brackets {} to ()
- rename a function (is there vim-go func? install GoRename)
- use nerdtree or windows to refactor code (is there vim-go func?)
- how to nav between windows and tabs
- how to nav through help: ctrl-] to open help, ctrl-o and t to go back and forth
- how do you toggle (i've seen increment value), there should be a way to either invert i.e. 5 => -5 or true => ffalse

##nerdtree

###to add a new file

```
m, # modify current node
a  # add child node
```

###resources

- http://shebangme.blogspot.co.uk/2010/07/question-is-there-easy-way-to-add-file.html
-
##vim-g

###text objects 

```
<visual>af - to select a function
<visual>if - to select an if block
```
