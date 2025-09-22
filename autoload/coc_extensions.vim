" Coc 扩展安装脚本
function! coc_extensions#install() abort
  " 安装常用的 Coc 扩展
  let extensions = [
    \ 'coc-json',
    \ 'coc-tsserver',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-python',
    \ 'coc-java',
    \ 'coc-go',
    \ 'coc-rust-analyzer',
    \ 'coc-vimlsp',
    \ 'coc-yaml',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-lists',
    \ 'coc-git',
    \ 'coc-emoji'
    \ ]

  echo "正在安装 Coc 扩展..."
  for ext in extensions
    echo "安装 " . ext . "..."
    call coc#util#install_extension(ext)
  endfor
  echo "Coc 扩展安装完成!"
endfunction

command! CocInstallExtensions call coc_extensions#install()