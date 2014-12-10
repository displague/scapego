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
	surface.FillRect(&rect, 0xffff0000)
	window.UpdateSurface()

	sdl.Delay(1000)
	window.Destroy()
}

func dot() {
	blockHeight := int(height / rows)
	blockWidth := int(width / cols)
	var stamp = make([(1 + blockHeight)][(1 + blockWidth)]int)
	for i := range stamp {
		for j := range stamp[i] {
			stamp[i][j] = rand.Intn(255)
		}
	}
}
