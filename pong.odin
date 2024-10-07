package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/rand"

import rl "vendor:raylib"

GameState :: struct {
	windowSize : rl.Vector2,
	paddle: rl.Rectangle,
	ai_paddle: rl.Rectangle,
	paddleSpeed: f32,
	ball: rl.Rectangle,
	ballDirection: rl.Vector2,
	ballSpeed: f32,
}

reset :: proc(using gs: ^GameState) {
	angle := rand.float32_range(-45, 46)
	if rand.int_max(100) % 2 == 0 do angle += 180
	r := math.to_radians(angle)
	ballDirection.x = math.cos(r)
	ballDirection.y = math.sin(r)

	ball.x = windowSize.x / 2 - ball.width / 2
	ball.y = windowSize.y / 2 - ball.height / 2

	paddleMargin: f32 = 50
	paddle.x = windowSize.x - paddleMargin
	paddle.y = windowSize.y / 2 - paddle.height / 2

	ai_paddle.x = paddleMargin
	ai_paddle.y = windowSize.y / 2 - ai_paddle.height / 2
}

calculateBallDir :: proc(ball: rl.Rectangle, paddle: rl.Rectangle) -> (rl.Vector2, bool) {
	if rl.CheckCollisionRecs(ball, paddle) {
		ballCenter := rl.Vector2{ball.x + ball.width / 2, ball.y + ball.height / 2}
		paddleCenter := rl.Vector2{paddle.x + paddle.width / 2, paddle.y + paddle.height / 2}
		return linalg.normalize0(ballCenter - paddleCenter), true
	}
	return {}, false
}

main :: proc() {
	gs := GameState {
		windowSize = {1280, 720},
		paddle = {width = 30, height = 80},
		ai_paddle = {width = 30, height = 80},
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

		paddle.y = linalg.clamp(paddle.y, 0, windowSize.y - paddle.height)

		diff := ai_paddle.y + ai_paddle.height / 2 - ball.y + ball.height / 2
		if diff < 0 {
			ai_paddle.y += paddleSpeed * 0.5
		}
		if diff > 0 {
			ai_paddle.y -= paddleSpeed * 0.5
		}
		ai_paddle.y = linalg.clamp(ai_paddle.y, 0, windowSize.y - ai_paddle.height)

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

		ballDirection = calculateBallDir(nextBall, paddle) or_else ballDirection
		ballDirection = calculateBallDir(nextBall, ai_paddle) or_else ballDirection

		ball.x += ballSpeed * ballDirection.x
		ball.y += ballSpeed * ballDirection.y

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawRectangleRec(paddle, rl.WHITE)
		rl.DrawRectangleRec(ai_paddle, rl.WHITE)
		rl.DrawRectangleRec(ball, rl.RED)
		rl.EndDrawing()
	}
}
