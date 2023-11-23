" vim syntax file
" Language: Clang module map
" Maintainer: Saleem Abdulrasool <compnerd@compnerd.org>

" Prolog
if exists("b:current_syntax")
  finish
endif
if !exists('main_syntax')
  let main_syntax = 'modulemap'
endif

" Top-level module keyword
syntax keyword moduleKeyword nextgroup=modulename
    \ module

" Member keywords
syntax keyword moduleKeyword
    \ config_macros
    \ exclude
    \ explicit
    \ header
    \ link
    \ umbrella

" Members specifying module names
syntax keyword moduleKeyword nextgroup=moduleName
    \ conflict
    \ export_as
    \ use

" Modifiers
syntax keyword moduleKeyword
    \ exhaustive
    \ extern
    \ framework
    \ private
    \ textual

" Module identifier (alphanumeric plus underscore) and name (1+ .-separated identifiers)
syntax match moduleIdentifier contained
    \ /\<[A-Za-z_][A-Za-z_0-9]*\>/
syntax match moduleName contains=moduleIdentifier
    \ /\<\%([A-Za-z_][A-Za-z_0-9]*\.\)*[A-Za-z_][A-Za-z_0-9]*\>/


" Export declaration and wildcard (using match for the wildcard avoids setting iskeyword)
" TODO: This does not handle the moduleName.* case yet.
syntax keyword moduleKeyword nextgroup=moduleName,moduleWildcard 
    \ export
syntax match moduleWildcard keepend
    \ /\*$/

" Feature requirement and known features
syntax keyword moduleKeyword nextgroup=moduleFeature
    \ requires
syntax keyword moduleFeature
    \ altivec blocks coroutines
    \ cplusplus cplusplus11 cplusplus14 cplusplus17 cplusplus20 cplusplus23
    \ c99 c11 c17 c23
    \ freestanding gnuinlineasm objc objc_arc opencl tls
    \ sse4 neon avx
    \ freebsd win32 windows linux ios macos watchos tvos iossimulator
    \ gnu gnueabi android msvc

" Attributes
syntax region moduleAttributes start=/\[/ skip=/,/ end=/\]/ contains=moduleAttribute
syntax keyword moduleAttribute contained
    \ system
    \ extern_c
    \ no_undeclared_includes
    \ exhaustive

" TODOs
syntax keyword moduleTodo HACK FIXME TODO contained

" Strings
syntax region moduleString start=/"/ skip=/\\"/ end=/"/

" Comments
syntax region moduleComment start="/\*" end="\*/" contains=moduleComment,moduleLineComment,moduleTodo
syntax region moduleLineComment start="//" end="$" contains=moduleComment,moduleTodo

" Highlighting
highlight default link moduleComment Comment
highlight default link moduleLineComment Comment
highlight default link moduleIdentifier Identifier
highlight default link moduleName Typedef
highlight default link moduleKeyword Statement
highlight default link moduleString String
highlight default link moduleTodo Todo
highlight default link moduleFeature Structure
highlight default link moduleAttribute PreProc
highlight default link moduleWildcard Character

" Epilog
let b:current_syntax = 'modulemap'
if main_syntax ==# 'modulemap'
  unlet main_syntax
endif
