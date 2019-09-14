-- We import Ariana's tools
local ariana = require "ariana"
-- We can create a slider!
local a = ariana.Slider(1, 0, 50, 'a')
local options = {}
local ctx = ariana.canvas(options)

-- We get back a handle to the canvas
-- We can get the width and height of the canvas
width = ctx.width()
height = ctx.height()

ctx.fillStyle = 'green'
ctx.fillRect(width/2 - 10*a, height/2 - 10*a, 20*a, 20*a)

