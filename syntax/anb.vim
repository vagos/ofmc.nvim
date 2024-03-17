" Vim syntax file
" Language: AnB

if exists("b:current_syntax")
  finish
endif

" Define the syntax groups
syn match anbComment "\v#.+$" display
syn keyword anbKeyword Protocol Types Agent Number Function Symmetric_key PublicKey Knowledge where Actions Goals authenticates on secrecy of secret between
syn keyword anbBuiltinFunc exp inv
syn match anbConstant "\<[a-z][a-zA-Z0-9_]*\>"
syn match anbBasicKeyword "->"
syn match anbFunctionCall "\<\w\+\s*(.\{-})"
" syntax region anbEncryption start=/{/ end=/}/
syntax region anbEncryptionSymmetric start=/{|/ end=/|}/


" Link syntax groups to Vim highlighting groups
hi def link anbComment Comment
hi def link anbKeyword Keyword
hi def link anbBuiltinFunc Identifier
hi def link anbConstant Identifier
hi def link anbNumeric Number
hi def link anbBasicKeyword Statement
hi def link anbFunctionCall Function
highlight anbEncryptionSymmetric cterm=bold gui=bold

let b:current_syntax = "anb"
