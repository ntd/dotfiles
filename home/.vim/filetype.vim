" Custom file types

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile *.CUb				setfiletype cubloc
  au! BufRead,BufNewFile *.ledger			setfiletype ledger
  au! BufRead,BufNewFile *.ss				setfiletype xhtml
  au! BufRead,BufNewFile */.claws-mail/*		setfiletype mail
  au! BufRead,BufNewFile *.rs				setfiletype remoshell
  au! BufRead,BufNewFile *.todo				setfiletype todo
augroup END
