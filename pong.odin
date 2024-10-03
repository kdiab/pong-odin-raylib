package main
import rl "vendor:raylib"

import "core:fmt"

main :: proc() {
	barPos : i32 = 100
	ballPos : i32 = 150
	direction : i32 = 1
	WIDTH :: 1280
	HEIGHT :: 720
	BARWIDTH :: 180

	rl.InitWindow(WIDTH, HEIGHT, "Pong")
	rl.SetTargetFPS(60)
	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(rl.KeyboardKey.D) {
			if barPos < WIDTH - BARWIDTH {
				barPos += 10
			}
		}
		if rl.IsKeyDown(rl.KeyboardKey.A) {
			if barPos > 0 {
				barPos -= 10
			}
		}
		nextPos := ballPos + 10 * direction
		if nextPos >= 720 - 30 || nextPos <= 0 {
			direction *= -1
		}
		ballPos += 10 * direction
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawRectangle(barPos,100,BARWIDTH, 30,rl.WHITE)
		rl.DrawRectangle(100,ballPos,30,30,rl.RED)
		rl.EndDrawing()
	}
}
