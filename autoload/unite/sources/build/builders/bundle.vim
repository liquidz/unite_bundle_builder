call unite#util#set_default('g:unite_builder_bundle_command', 'bundle')

function! unite#sources#build#builders#bundle#define()
  return executable(g:unite_builder_bundle_command) ? s:builder : []
endfunction

let s:builder = { 'name': 'bundle', 'description': 'bundle builder', }

function! s:builder.initialize(args, context)
  return g:unite_builder_bundle_command . ' ' . join( a:args, ' ' )
endfunction

function! s:builder.parse(string, context)
  let candidate = { 'type' : 'message', 'text' : a:string }
  return candidate
endfunction
