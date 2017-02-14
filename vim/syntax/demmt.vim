" Vim Syntax File
" Language: Demmt
" Maintainer: Pierre Moreau <pierre.morrow@free.fr>
" Latest Revision: 24 October 2015


if exists("b:current_syntax")
  finish
endif

syntax match   demmtLog '^LOG:'he=e-1 contained containedin=demmtPart
syntax region  demmtPart end='$' matchgroup=demmtPart start='^LOG:' transparent keepend contains=demmtLog
syntax region  demmtArgs end='$' matchgroup=demmtArgs start='^LOG: \*\?\s\+' transparent

syntax region  demmtMsg start='\<MSG\>: ' end='$' contained containedin=demmtPart
syntax region  demmtIoctl end='$' matchgroup=Structure start='\(\<NVRM_IOCTL\|\<DRM_NOUVEAU\)\(_\u\(\u*\d*\)*\)\+\>' contained containedin=demmtPart transparent

syntax cluster demmtCmd contains=demmtIoctl,demmtMthd,demmtArgs

syntax match   demmtKey '\<\l\(_\?\l*\d*\)*\>' contained containedin=@demmtCmd
syntax match   demmtName '\<\u\(_\?\u*\d*\)*\>:'he=e-1 contained containedin=@demmtCmd
syntax match   demmtName2 '\<\a\(_\?\a*\d*\)*\>' contained containedin=demmtIndex
syntax region  demmtIndex matchgroup=demmtIndex start='\[' end='\]' contained containedin=@demmtCmd

syntax match   demmtNumber '\<\d\+\(\.\d\+\)\?\>' contained containedin=@demmtCmd,demmtIndex
syntax match   demmtHexa '\<0x\x\+\>' contained containedin=@demmtCmd,demmtIndex
syntax match   demmtFlag ': \<\u\(_\?\u*\d*\)*\>'hs=s+2 contained containedin=@demmtCmd

syntax match   demmtPost '\<post\>' contained containedin=@demmtCmd

syntax match   demmtPbRegister '\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>' contained
syntax match   demmtPbDetailFlag '\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>' contained
syntax match   demmtPbKey '\<\u\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\> ='me=e-2 contained nextgroup=demmtPbEqual skipwhite
syntax match   demmtPbNumber '\d\+' contained
syntax match   demmtPbOtherValue '\<\(\(\u\|\d\)\?\(_\(\u\|\d\)\)\?\)\+\>' contained
syntax match   demmtPbAddress '\<\(0x\x\+\)\+\|\(\d\+\)\>' contained
syntax match   demmtPbDetailRest '\<\(0x\x\+\)\+\|\(\d\+\)\>' contained
syntax match   demmtPbEqual '=' contained nextgroup=@demmtPbValue skipwhite
syntax cluster demmtPbDetailPair contains=demmtPbKey,demmtPbEqual
syntax cluster demmtPbDetailElement contains=@demmtPbDetailPair,demmtPbDetailFlag,demmtPbDetailRest,demmtPbNumber
syntax region  demmtPbValueDetail start="{" end="}" contains=@demmtPbDetailElement
syntax region  demmtPbValueDetail2 matchgroup=Delimiter start="{" end="}" contains=@demmtPbDetailElement
syntax cluster demmtPbValue contains=demmtPbAddress,demmtPbOtherValue,demmtPbValueDetail2
syntax match   demmtPb '^PB:'he=e-1 contained containedin=demmtPbStart
syntax region  demmtPbPart start='^PB:' end='$' transparent contains=demmtPb,demmtPbRegister,demmtPbValueDetail,demmtPbAddress


let b:current_syntax = "demmt"

highlight def link demmtNumber Number
highlight def link demmtHexa Number
highlight def link demmtFlag Tag

highlight def link demmtKey Label
highlight def link demmtName Structure
highlight def link demmtName2 Label

highlight def link demmtMsg Ignore

highlight def link demmtPost Delimiter

highlight def link demmtPbRegister Structure
highlight def link demmtPbDetailRest Comment
highlight def link demmtPbDetailFlag Identifier
highlight def link demmtPbKey   Label
highlight def link demmtPbAddress Number
highlight def link demmtPbNumber Number
highlight def link demmtPbOtherValue Special

highlight def link demmtPb Error
highlight def link demmtLog Todo
