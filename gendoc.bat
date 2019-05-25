rem vimdoc -p deline .\**\*.vim > docsrc.txt
vimdoc -p deline ./plugin/deline.vim ./autoload/deline.vim ./autoload/deline/dynamic.vim ./autoload/deline/extra.vim > docsrc.txt
vimdoc -p deline-sample ./autoload/deline/sample.vim > docsrc_sample.txt
