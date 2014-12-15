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
	rect := sdl.Rect{0,0,200,200}
	rect2 := sdl.Rect{200, 200,210,210}

	surface.FillRect(&rect, sdl.MapRGB(surface.Format, 50, 50, 50))
	surface.FillRect(&rect2, sdl.MapRGB(surface.Format, 100, 20, 20))
	gHelloWorld := sdl.LoadBMP("02_getting_an_image_on_the_screen.bmp")
	surface.Blit(nil, gHelloWorld,&rect2)
	window.UpdateSurface()
	sdl.Delay(3000)
	window.Destroy()
	sdl.Quit()
}
