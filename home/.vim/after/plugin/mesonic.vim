" Automatically initialize meson on standard configurations,
" i.e. `meson.build` file exists next to a folder named `build`
if exists("meson_loaded") && filereadable("meson.build") && isdirectory("build")
    silent call g:MesonInit("build", "!")
endif
