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

	//surface := window.GetSurface()

	// rect := sdl.Rect{0, 0, 200, 200}
	var renderer, err3 = sdl.CreateRenderer(window, -1, sdl.RENDERER_ACCELERATED)
	if err3 != nil {
		panic(err3)
	}

	//surface.FillRect(nil, sdl.MapRGB(surface.Format, 50, 50, 0))
	renderer.Clear()

	// MapRGB(PIXELFORMAT_RGB555, 50, 50, 50)
	for h := 0; h < height; h++ {
		for w := 0; w < width; w++ {
			renderer.SetDrawColor(uint8(h%3)*64, uint8(h%2)*64, uint8(w%4)*64, 80)
			var rect = sdl.Rect{int32(h), int32(w), 40, 40}
			renderer.DrawRect(&rect)
			// renderer.SetDrawColor(uint8(h%256), uint8(h%128), uint8(w%64), 10)
			// renderer.DrawLine(0, 0, w, h)
		}
	}
	renderer.Present()
	// window.UpdateSurface()

	sdl.Delay(15000)
	window.Destroy()
}
