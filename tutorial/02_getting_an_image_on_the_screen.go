package main

import (
	"github.com/veandco/go-sdl2/sdl"
)

var height = 600
var width = 800
var rows = 80
var cols = 60

func main() {
	window, err := sdl.CreateWindow("SDL Tutorial", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, width, height, sdl.WINDOW_SHOWN)
	if err != nil {
		panic(err)
	}

	renderer, err2 := sdl.CreateRenderer(window, -1, sdl.RENDERER_ACCELERATED)
	if err2 != nil {
		panic(err2)
	}

	gHelloWorld := sdl.LoadBMP("02_getting_an_image_on_the_screen.bmp")
	texture, err3 := renderer.CreateTextureFromSurface(gHelloWorld)
	if err3 != nil {
		panic(err3)
	}

	src := sdl.Rect{0, 0, 400, 400}
	dst := sdl.Rect{100, 50, 400, 400}

	renderer.Clear()
	renderer.Copy(texture, &src, &dst)
	renderer.Present()

	sdl.Delay(3000)
	gHelloWorld.Free()
	texture.Destroy()
	window.Destroy()
	sdl.Quit()
}
