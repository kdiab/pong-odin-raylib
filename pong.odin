package main
import rl "vendor:raylib"

import "core:fmt"

main :: proc() {
	WIDTH :: 1280
	HEIGHT :: 720

	paddle := rl.Rectangle{100, 100, 180, 30} // x y width height
	paddleSpeed : f32 = 10

	ball := rl.Rectangle{100, 150, 30, 30} // x y width height
	ballDirection := rl.Vector2{0, -1}
	ballSpeed : f32 = 10

	rl.InitWindow(WIDTH, HEIGHT, "Pong")
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(rl.KeyboardKey.D) {
			if paddle.x < WIDTH - paddle.width {
				paddle.x += 10
			}
		}
		if rl.IsKeyDown(rl.KeyboardKey.A) {
			if paddle.x > 0 {
				paddle.x -= 10
			}
		}

		nextBall := ball
		nextBall.y += ballSpeed * ballDirection.y
		if nextBall.y >= 720 - ball.height || nextBall.y <= 0 {
			ballDirection.y *= -1
		}

		ball.y += ballSpeed * ballDirection.y

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawRectangleRec(paddle, rl.WHITE)
		rl.DrawRectangleRec(ball, rl.RED)
		rl.EndDrawing()
	}
}
