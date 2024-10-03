package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"

import rl "vendor:raylib"

GameState :: struct {
	windowSize : rl.Vector2,
	paddle: rl.Rectangle,
	paddleSpeed: f32,
	ball: rl.Rectangle,
	ballDirection: rl.Vector2,
	ballSpeed: f32,
}

reset :: proc(using gs: ^GameState) {
	angle := rand.float32_range(-45, 46)
	r := math.to_radians(angle)
	ballDirection.x = math.cos(r)
	ballDirection.y = math.sin(r)

	ball.x = windowSize.x / 2 - ball.width / 2
	ball.y = windowSize.y / 2 - ball.height / 2

	paddle.x = windowSize.x - 80
	paddle.y = windowSize.y / 2 - paddle.height / 2
}

main :: proc() {
	gs := GameState {
		windowSize = {1280, 720},
		paddle = {width = 30, height = 80},
		paddleSpeed = 10,
		ball = {width = 30, height = 30},
		ballSpeed = 10,
	}

	reset(&gs)
	using gs

	rl.InitWindow(i32(windowSize.x), i32(windowSize.y), "Pong")
	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(rl.KeyboardKey.K) {
				paddle.y += 10
		}
		if rl.IsKeyDown(rl.KeyboardKey.J) {
				paddle.y -= 10
		}

		nextBall := ball
		nextBall.x += ballSpeed * ballDirection.x
		nextBall.y += ballSpeed * ballDirection.y

		if nextBall.y >= windowSize.y - ball.height || nextBall.y <= 0 {
			ballDirection.y *= -1
		}

		if nextBall.x >= windowSize.x - ball.width {
			reset(&gs)
		}
		if nextBall.x < 0 {
			reset(&gs)
		}

		if rl.CheckCollisionRecs(nextBall, paddle) {
				ballCenter := rl.Vector2 {
				nextBall.x + ball.width / 2,
				nextBall.y + ball.height / 2,
			}
				paddleCenter := rl.Vector2{
					paddle.x + paddle.width / 2,
					paddle.y + paddle.height
				}
				ballDirection = linalg.normalize0(ballCenter - paddleCenter)
		}

		ball.x += ballSpeed * ballDirection.x
		ball.y += ballSpeed * ballDirection.y

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawRectangleRec(paddle, rl.WHITE)
		rl.DrawRectangleRec(ball, rl.RED)
		rl.EndDrawing()
	}
}
