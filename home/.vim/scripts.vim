" Custom file types

if did_filetype()
  finish
endif

if getline(1) =~ '^# On branch '
  setf gitcommit
endif
