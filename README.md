# gradruby

gradruby is a learing aid for the understanding of multilayer perceptrons (MLP) or neural nets. This ruby implementation is a derivative work (excuse the pun) of Andrej Karpathy's https://github.com/karpathy/micrograd.

Additionally, this was an opportunity to to use iRuby as Kernel for a Jupyter notebook in VSCode.

```shell
gem install iruby
iruby register
```

If you have the Jupyter extension installed in VSCode, you should be able to select iRuby as a Kernel to run the `gradruby.ipynb` notebook. This notebook takes you through making an MLP and training it. It's a simple binary classifier.

There is also a solution to generating SVG directed graphs for display in an iRuby Jupyter notebooks in `lib/renderer.rb`