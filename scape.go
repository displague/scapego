package main

import (
	"github.com/veandco/go-sdl2/sdl"
	"math/rand"
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
		panic(err)
	}

	renderer.Clear()
	surface.FillRect(&rect, 0xffff0000)

	blockHeight := int(height / rows)
	blockWidth := int(width / cols)
	var stamp = make([][]byte, 1+ blockHeight, 1 + blockWidth)
	for i := range stamp {
		for j := range stamp[i] {
			stamp[i][j] = byte(rand.Intn(255))
		}
	}
	dot:=stamp

	for x := range dot {
		for y := range dot[x] {
			renderer.SetDrawColor(dot[x][y], dot[x][y], dot[x][y], 255)
			renderer.DrawPoint(x, y)
		}
	}
	renderer.Present()
	window.UpdateSurface()

	sdl.Delay(15000)
	window.Destroy()
}

