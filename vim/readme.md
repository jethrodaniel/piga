# vim/piga

Syntax highlighting for piga input files.

Adapted from `racc.vim` in vim's [source code.](https://github.com/vim/vim/blob/master/runtime/syntax/racc.vim)

## install

If using vim8's plugin manager, copy this directory to your `pack/start`

```
mkdir -p ~/.vim/pack/piga/start
cp -ra piga/vim ~/.vim/pack/piga/start/piga
```

Otherwise, copy these files to your `syntax/` and `ftdetect/` directories.

```
cp vim/ftdetect/piga.vim ~/.vim/ftdetect/
cp vim/syntax/piga.vim ~/.vim/syntax/
```

## usage

The `ftdetect` should ensure `.piga` files use this syntax highlighting.

Additionally, you may find the following modeline useful

```
# vim: set filetype=piga
```
