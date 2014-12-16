package main

import (
	"github.com/veandco/go-sdl2/sdl"
)

var height = 600
var width = 800
var rows = 80
var cols = 60

func main() {
	var e sdl.Event
	window, err := sdl.CreateWindow("SDL Tutorial", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED, width, height, sdl.WINDOW_SHOWN)
	if err != nil {
		panic(err)
	}

	surface := window.GetSurface()

	gHelloWorld := sdl.LoadBMP("03_event_driven_programming.bmp")
	surface.Blit(nil, gHelloWorld, nil)
	renderer, err2 := sdl.CreateRenderer(window, -1, sdl.RENDERER_ACCELERATED)
	if err2 != nil {
		panic(err2)
	}
	texture, err3 := renderer.CreateTextureFromSurface(surface)
	if err3 != nil {
		panic(err3)
	}
	src := sdl.Rect{0, 0, 512, 512}
	dst := sdl.Rect{100, 50, 512, 512}
	renderer.Clear()
	renderer.Copy(texture, &src, &dst)
	renderer.Present()
	window.UpdateSurface()
	quit := false
	for !quit {
		for sdl.PollEvent() != nil {
			switch e.(type) {
			case *sdl.QuitEvent:
				quit = true
			}
		}
	}

	sdl.Delay(2000)
	texture.Destroy()
	window.Destroy()
	sdl.Quit()
}
