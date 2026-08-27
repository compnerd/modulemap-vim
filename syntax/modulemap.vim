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
" module-declaration: explicit? framework? module module-id attributes? '{' ... '}'
"                    | extern module module-id string-literal
syntax keyword moduleKeyword nextgroup=moduleName,moduleWildcard skipwhite
    \ module

" Member keywords taking a bare string/number argument (highlighted generically
" by moduleString / the header-attrs handling below)
syntax keyword moduleKeyword
    \ header
    \ link
    \ umbrella

" exclude/private/textual/umbrella are header modifiers: [private] [textual] header "path"
" or umbrella header "path" / exclude header "path"
syntax keyword moduleKeyword
    \ exclude

" config_macros attributes? (identifier (',' identifier)*)?
syntax keyword moduleKeyword nextgroup=moduleAttributes,moduleMacroName skipwhite
    \ config_macros

" Members specifying module names (conflict module-id ',' string-literal, etc.)
syntax keyword moduleKeyword nextgroup=moduleName
    \ conflict
    \ export_as
    \ use

" Modifiers: explicit/framework (module), private/textual (header), extern (module)
syntax keyword moduleKeyword
    \ explicit
    \ extern
    \ framework
    \ private
    \ textual

" Module identifier (alphanumeric plus underscore) and name (1+ .-separated identifiers)
syntax match moduleIdentifier contained
    \ /\<[A-Za-z_][A-Za-z_0-9]*\>/
syntax match moduleName contains=moduleIdentifier
    \ /\<\%([A-Za-z_][A-Za-z_0-9]*\.\)*[A-Za-z_][A-Za-z_0-9]*\>/

" Export declaration and wildcard-module-id (identifier | '*' | identifier '.' wildcard-module-id)
" Also covers the inferred submodule form: module '*' { export '*' }
" (using match for the wildcard avoids setting iskeyword)
syntax keyword moduleKeyword nextgroup=moduleName,moduleWildcard skipwhite
    \ export
syntax match moduleWildcard contains=moduleIdentifier
    \ /\*\|\<\%([A-Za-z_][A-Za-z_0-9]*\.\)\+\*/

" Feature requirement and known features: requires !?feature (',' !?feature)*
syntax keyword moduleKeyword nextgroup=moduleFeature
    \ requires
syntax match moduleFeatureNot
    \ /!/
syntax keyword moduleFeature
    \ altivec blocks coroutines
    \ cplusplus cplusplus11 cplusplus14 cplusplus17 cplusplus20 cplusplus23
    \ c99 c11 c17 c23
    \ freestanding gnuinlineasm objc objc_arc opencl tls
    \ sse4 neon avx
    \ freebsd win32 windows linux ios macos watchos tvos iossimulator
    \ gnu gnueabi android msvc

" Attributes: '[' identifier ']', e.g. [system] on a module, [exhaustive] on config_macros
" nextgroup carries the config_macros macro-list chain forward past an attributes block
syntax region moduleAttributes start=/\[/ skip=/,/ end=/\]/ contains=moduleAttribute
    \ nextgroup=moduleMacroName skipwhite
syntax keyword moduleAttribute contained
    \ system
    \ extern_c
    \ no_undeclared_includes
    \ exhaustive

" config_macros macro-list: comma-separated bare identifiers (not module-ids)
syntax match moduleMacroName contained nextgroup=moduleMacroSeparator skipwhite
    \ /\<[A-Za-z_][A-Za-z_0-9]*\>/
syntax match moduleMacroSeparator contained nextgroup=moduleMacroName skipwhite
    \ /,/

" header-attrs: '{' ( size integer-literal | mtime integer-literal )* '}'
syntax keyword moduleKeyword nextgroup=moduleNumber skipwhite
    \ size
    \ mtime
syntax match moduleNumber
    \ /\<[0-9]\+\>/

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
highlight default link moduleFeatureNot Operator
highlight default link moduleAttributes Delimiter
highlight default link moduleAttribute PreProc
highlight default link moduleWildcard Character
highlight default link moduleMacroName Macro
highlight default link moduleMacroSeparator Delimiter
highlight default link moduleNumber Number

" Epilog
let b:current_syntax = 'modulemap'
if main_syntax ==# 'modulemap'
  unlet main_syntax
endif
