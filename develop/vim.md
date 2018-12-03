---
---
## Make Vim session
-	:mks session-name.vim - create session
-	:source session-name.vim - restore
-	:mks! - update

## buffer/window/tab Summary:
    A buffer is the in-memory text of a file.
    A window is a viewport on a buffer.
    A tab page is a collection of windows.

## buffers
```
:b4         " switch to buffer number 4
:bn         " switch to next buffer in the buffer list
:bp         " switch to previous buffer in the buffer list
:b foo<Tab> " switch by buffer name with tab-completion
:b#         " switch to the alternate file
:bd         " delete from the buffer list
:bw         " completely removes the buffer from memory
```

## Tabs

### Cursor Movement

* `gt` (`:tabn`) - next tab
* `gT` (`:tabp`) - previous tab
* `[i]gt` - go to tab `[i]`

### Tabs Management

* `:tabs` - list open tabs
* `:tabm 0` - move current tab to first position
* `:tabm` - move current tab to last position
* `:tabm [i]` - move current tab to position `[i]`

### Close Tab

* `:tabc` - close current tab
* `:tabo` - close all other tabs

## Window Split

### Splits Movement

* `<C-w>T` - (`:tab split`) move split to new tab

### Close Split

* `<C-w>c` (`:close`) - close split
* `<C-w>q` (`:q`) - close split and quit file
* `<C-w>o` (`:only`) - close all other splits

## marker
uppercase letter is for global bookmarks

### copy/paste
```
mk - Mark point with alphabet ‘k’ or use any other alphabet
y'k
```

### fold
```
mb
zf'b - zip fold to marker 'b'
za - toggle between open and closed folds
```

## auto-formate
```
=i{ - inside a code block
>i{ - increase indentation
```

## auto-completion
Ctrl+n/p

