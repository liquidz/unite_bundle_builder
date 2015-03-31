let s:V = vital#of('unite_bundle_builder')
let s:String = s:V.import('Data.String')
let s:FilePath = s:V.import('System.Filepath')

call unite#util#set_default('g:unite_builder_bundle_command', 'bundle')

function! s:find_file_dir(dir, filename)
    if filereadable(s:FilePath.join(a:dir, a:filename))
        return a:dir
    else
        return (a:dir == '/')
\           ? 0
\           : s:find_file_dir(s:FilePath.dirname(a:dir), a:filename)
    endif
endfunction

function! unite#sources#build#builders#bundle#define()
    return executable(g:unite_builder_bundle_command) ? s:builder : []
endfunction

let s:builder = { 'name': 'bundle', 'description': 'bundle builder', }

function! s:builder.initialize(args, context)
    let a:context.builder__rakefile_dir = s:find_file_dir(getcwd(), 'Rakefile')
    return g:unite_builder_bundle_command . ' ' . join( a:args, ' ' )
endfunction

function! s:builder.parse(string, context)
    if a:string =~ '   #'
        return s:analyze_error(a:string, a:context.builder__rakefile_dir)
    else
        return { 'type' : 'message', 'text' : a:string }
    endif
endfunction

function! s:analyze_error(string, rakefile_dir)
    let string = a:string
    let list = split(s:String.trim(string)[2:], ':')
    if empty(list)
        return {'type': 'message', 'text': string}
    endif

    let filename = list[0]
    let line_num = list[1]

    return {
\       'filename' : a:rakefile_dir . '/' . filename,
\       'line'     : line_num,
\       'type'     : 'error',
\       'text'     : string
\   }
endfunction
