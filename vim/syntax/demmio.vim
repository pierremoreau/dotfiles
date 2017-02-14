" Vim Syntax File
" Language: Demmio
" Maintainer: Pierre Moreau <pierre.morrow@free.fr>
" Latest Revision: 22 February 2015


if exists("b:current_syntax")
  finish
endif

" Read the demmt syntax to start with
runtime! syntax/demmt.vim
unlet b:current_syntax


syntax match   demmioRegister '\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>' contained
syntax match   demmioDetailFlag '\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>' contained
syntax match   demmioKey '\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\> ='me=e-2 contained nextgroup=demmioEqual skipwhite
syntax match   demmioNumber '\d\+' contained
syntax match   demmioOtherValue '\<\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>' contained
syntax match   demmioAddress '\<\(0x\x\+\)\+\|\(\d\+\)\>' contained
syntax match   demmioDetailRest '\<\(0x\x\+\)\+\|\(\d\+\)\>' contained
syntax match   demmioEqual '=' contained nextgroup=@demmioValue skipwhite
syntax cluster demmioDetailPair contains=demmioKey,demmioEqual
syntax cluster demmioDetailElement contains=@demmioDetailPair,demmioDetailFlag,demmioDetailRest,demmioNumber
syntax region  demmioValueDetail start="{" end="}" contains=@demmioDetailElement
syntax region  demmioValueDetail2 matchgroup=Delimiter start="{" end="}" contains=@demmioDetailElement
syntax cluster demmioValue contains=demmioAddress,demmioOtherValue,demmioValueDetail2
syntax region  demmioPart start='\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>\(\.\|+\|\[\| \(=\|<\)\)' end='$' transparent contains=demmioRegister,demmioValueDetail,demmioAddress

syntax match   demmioCard1 '^\[0\]'
syntax match   demmioCard2 '^\[1\]'

syntax region  demmioMem8 start='^.\{-}MEM8' end='^\(.\{-}MEM8\)\@!' fold transparent
syntax region  demmioMem32 start='^.\{-}MEM32' end='^\(.\{-}MEM32\)\@!' fold transparent
syntax region  demmioFb32 start='^.\{-}FB32' end='^\(.\{-}FB32\)\@!' fold transparent
syntax region  demmioRamin32 start='^.\{-}RAMIN32' end='^\(.\{-}RAMIN32\)\@!' fold transparent

syntax match   demmioWrite '\<W\>'

let b:current_syntax = "demmio"

highlight def link demmioRegister Structure
highlight def link demmioDetailRest Comment
highlight def link demmioDetailFlag Identifier
highlight def link demmioKey   Label
highlight def link demmioAddress Number
highlight def link demmioNumber Number
highlight def link demmioOtherValue Special

highlight def link demmioCard1 Todo
highlight def link demmioCard2 Error

highlight def link demmioWrite Underlined
