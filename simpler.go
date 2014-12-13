package main

import (
	"github.com/veandco/go-sdl2/sdl"
)

var height = 600
var width = 800
var rows = 80
var cols = 60

func main() {
	window, err := sdl.CreateWindow("test", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, width, height, sdl.WINDOW_SHOWN)
	if err != nil {
		panic(err)
	}

	surface := window.GetSurface()

	rect := sdl.Rect{0, 0, 200, 200}
	var renderer, err3 = sdl.CreateRenderer(window, -1, sdl.RENDERER_ACCELERATED)
	if err3 != nil {
		panic(err3)
	}

	surface.FillRect(&rect, 0xffff0000)
	renderer.Clear()

	// MapRGB(PIXELFORMAT_RGB555, 50, 50, 50)
	renderer.SetDrawColor(80,80,80, 255)
	renderer.DrawPoint(300, 300)
	renderer.DrawPoint(400, 400)
	renderer.DrawPoint(500, 500)

	renderer.Present()
	// window.UpdateSurface()

	sdl.Delay(15000)
	window.Destroy()
}

