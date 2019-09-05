Ariana-Lua is a research project. It is not yet meant (and probably never will) to be used in general.

The idea is to have the Lua scripting language to plot mathematical functions in the browser.

This currently:

1. Extended Lua with some mathematica functions (the cephes library)
2. Extends Lua with some functions that will eventually call the javascript plotting functions
3. Compile the whole shebang to webassembly.

```bash
# Get the emsdk repo
$ git clone https://github.com/juj/emsdk.git

# Enter that directory
$ cd emsdk

# Fetch the latest registry of available tools.
$ ./emsdk update

# Download and install the latest SDK tools.
$ ./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
$ ./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
$ source ./emsdk_env.sh

# go to the ariana-lua folder
$ make

# serve the output folder
```


EXTERNAL DEPENDENCIES
---------------------

* Lua
* Cephes (node-cephes)
* Lua json (https://github.com/rxi/json.lua)

Algorithms
----------

https://yacas.readthedocs.io/en/latest/book_of_algorithms/index.html
https://stackoverflow.com/questions/47403145/implementing-adaptive-function-plotting
https://math.stackexchange.com/questions/43842/plotting-an-equation

https://mauriciopoppe.github.io/function-plot/