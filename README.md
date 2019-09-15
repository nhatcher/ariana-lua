DESCRIPTION
-----------

Ariana-Lua (name probably will change!) is a research project and the goal is to reach a proof of concept by Feb 2020.

The idea is to have the Lua scripting language to plot mathematical functions in the browser.

This currently:

1. Extends Lua with some mathematicaL functions (the cephes library)
2. Extends Lua with some functions that will eventually call the javascript plotting functions
3. Compile the whole shebang to webassembly.

DOCUMENTATION
-------------

The screen has for panels (parameters, script, plots and output). You can choose which panels to see at a given time. Normally you would write a few lines in the script panel and observe the plots.


Scripts are written in [Lua 5.3](https://www.lua.org/manual/5.3/manual.html). But the language is so simple that you can have a look at a couple of the examples and do what you need. 

It has a package `ariana` that extends the language with:

* Transcendental functions (Bessel functions)
* Function Plotting capabilities.
* Canvas manipulation
* Creation of parameters






DESIGN CHOICES
--------------


ROADMAD
-------

BUILD INSTRUCTIONS
------------------

Install [emscripten](https://emscripten.org/docs/getting_started/downloads.html#sdk-download-and-install), build and serve the docs folder


```bash
# Get the emsdk repo
$ git clone https://github.com/juj/emsdk.git

# Enter that directory
$ cd emsdk

# Fetch the latest registry of available tools.
emsdk$ ./emsdk update

# Download and install the latest SDK tools.
emsdk$ ./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
emsdk$ ./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
emsdk$ source ./emsdk_env.sh

# go to the ariana-lua folder
ariana-lua$ make

# serve the output folder
ariana-lua/docs$ go run
```


EXTERNAL DEPENDENCIES
---------------------

* Lua
* Cephes (node-cephes)
* Lua json (https://github.com/rxi/json.lua)

