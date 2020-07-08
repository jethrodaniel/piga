" Vim syntax file
" Language:  piga
" Version:   0.2.0

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn keyword pigaTodo        contained TODO FIXME HACK NOTE

syn region  pigaComment     display oneline start='#' end='$'
                            \ contains=pigaTodo,@Spell

syn region  pigaClass       transparent matchgroup=pigaKeyword
                            \ start='\<class\>' end='\<rule\>'he=e-4
                            \ contains=pigaComment,pigaPrecedence,
                            \ pigaTokenDecl,pigaExpect,pigaOptions,pigaConvert,
                            \ pigaStart,

syn keyword pigaTokenDecl   contained token
                            \ nextgroup=pigaTokenR skipwhite skipnl

syn match   pigaTokenR      contained '\<\u[A-Z0-9_]*\>'
                            \ nextgroup=pigaTokenR skipwhite skipnl

syn keyword pigaExpect      contained expect
                            \ nextgroup=pigaNumber skipwhite skipnl

syn match   pigaNumber      contained '\<\d\+\>'

syn keyword pigaOptions     contained options
                            \ nextgroup=pigaOptionsR skipwhite skipnl

syn keyword pigaOptionsR    contained omit_action_call result_var
                            \ nextgroup=pigaOptionsR skipwhite skipnl

syn region  pigaConvert     transparent contained matchgroup=pigaKeyword
                            \ start='\<convert\>' end='\<end\>'
                            \ contains=pigaComment,pigaConvToken skipwhite
                            \ skipnl

syn match   pigaConvToken   contained '\<\u[A-Z0-9_]*\>'
                            \ nextgroup=pigaString skipwhite skipnl

syn keyword pigaStart       contained start
                            \ nextgroup=pigaTargetS skipwhite skipnl

syn match   pigaTargetS     contained '\<\l[a-z0-9_]*\>'

syn match   pigaSpecial     contained '\\["'\\]'

syn region  pigaString      start=+"+ skip=+\\\\\|\\"+ end=+"+
                            \ contains=pigaSpecial
syn region  pigaString      start=+'+ skip=+\\\\\|\\'+ end=+'+
                            \ contains=pigaSpecial

syn region  pigaRules       transparent matchgroup=pigaKeyword start='\<rule\>'
                            \ end='\<end\>' contains=pigaComment,pigaString,
                            \ pigaNumber,pigaToken,pigaTarget,pigaDelimiter,
                            \ pigaAction

syn match   pigaTarget      contained '\<\l[a-z0-9_]*\>'

syn match   pigaDelimiter   contained '[:|]'

syn match   pigaToken       contained '\<\u[A-Z0-9_]*\>'

syn include @pigaRuby       syntax/ruby.vim

syn region  pigaAction      transparent matchgroup=pigaDelimiter
                            \ start='{' end='}' contains=@pigaRuby

syn region  pigaHeader      transparent matchgroup=pigaPreProc
                            \ start='^---- header.*' end='^----'he=e-4
                            \ contains=@pigaRuby

syn region  pigaInner       transparent matchgroup=pigaPreProc
                            \ start='^---- inner.*' end='^----'he=e-4
                            \ contains=@pigaRuby

syn region  pigaFooter      transparent matchgroup=pigaPreProc
                            \ start='^---- footer.*' end='^----'he=e-4
                            \ contains=@pigaRuby

syn sync match pigaSyncHeader  grouphere pigaHeader '^---- header'
syn sync match pigaSyncInner   grouphere pigaInner  '^---- inner'
syn sync match pigaSyncFooter  grouphere pigaFooter '^---- footer'

hi def link pigaTodo        Todo
hi def link pigaComment     Comment
hi def link pigaTokenDecl   Keyword
hi def link pigaToken       Identifier
hi def link pigaTokenR      pigaToken
hi def link pigaExpect      Keyword
hi def link pigaNumber      Number
hi def link pigaOptions     Keyword
hi def link pigaOptionsR    Identifier
hi def link pigaConvToken   pigaToken
hi def link pigaStart       Keyword
hi def link pigaTargetS     Type
hi def link pigaSpecial     special
hi def link pigaString      String
hi def link pigaTarget      Type
hi def link pigaDelimiter   Delimiter
hi def link pigaKeyword     Keyword

let b:current_syntax = "piga"

let &cpo = s:cpo_save
unlet s:cpo_save
