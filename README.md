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

A simple example:

```lua
-- We import Ariana's tools
local ariana = require "ariana"

-- We can create a slider!
-- Has value 1, a minimum of 0 and maximum of 5.
-- We give it a name so we can identify it
local a = ariana.Slider(1, 0, 5, 'a')

-- Define the function we want to draw
local function sinc(x)
  return math.sin(a*x)/x
end

-- We define options and the functions we want to plot
local options = {
  xmin=-20,
  xmax=20
}
local functions = {
  {name=sinc, color="red", width=1},
}

-- And plot them
ariana.plot(functions, options)
```

Note the glaring naming inconsistencies (`ariana.plot` lowercase `p` vs `ariana.Slider` sign of a research project under heavy refactoring).
now you can activate the parameters panel and change the Slider to see how your plot depends on that particular parameter.

You can plot as many functions as you want, just add them to the list.

Currently the supported options for the plot are not many:

```lua
local plot_defaults = {
  points=1000,
  xmin=-5,
  xmax=5,
  padding={
    left=10,
    right=10,
    top=10,
    bottom=10
  },
  gridcolor='#ccc',
  gridwidth=1,
  axiscolor='#ccc',
  axiswidth=2
}
```

But I will work on that. Most notably you cannot set a title of the plot or axis.

A plot command returns a canvas context:

```lua
local ctx = ariana.plot(functions, options)

-- We get back a handle to the canvas
-- We can get the width and height of the canvas
width = ctx.width()
height = ctx.height()

ctx.font = '48px serif';
ctx.fillText('A Bessel function!', width/2 - 100, 50);
```

So, as you can see you can use the full power of canvas to add things to your plot.
Currently, this is very limited though, it would be very though to center something on the screen, for instance.

You can have a canvas context without a plot.








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

