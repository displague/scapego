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

	surface := window.GetSurface()

	surface.FillRect(nil, sdl.MapRGB(surface.Format, 50, 50, 50))
	gHelloWorld := sdl.LoadBMP("02_getting_an_image_on_the_screen.bmp")
	surface.Blit(nil, gHelloWorld,nil)
	window.UpdateSurface()
	sdl.Delay(15000)
	window.Destroy()
	sdl.Quit()
}
