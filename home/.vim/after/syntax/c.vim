let glib_deprecated_errors = 1
let gobject_deprecated_errors = 1
let gdk_deprecated_errors = 1
let pango_deprecated_errors = 1
let gtk_deprecated_errors = 1

runtime! syntax/glib.vim
runtime! syntax/gobject.vim
runtime! syntax/gio.vim
runtime! syntax/pango.vim
runtime! syntax/gdk.vim
runtime! syntax/cairo.vim
runtime! syntax/gtk.vim

let c_hi_identifiers = 'all'
runtime! syntax/clibs/glibc.vim

map <F8> :exe GnomeDoc()<CR>
