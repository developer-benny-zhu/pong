package src

import "vendor:raylib"
import "core:math/linalg"


main :: proc() {
    PADDLE_SIZE :: linalg.Vector2f32 {30, 90}
    SCREEN_WIDTH :: 800
    SCREEN_HEIGHT :: 600
    BALL_RADIUS :: 15
    ball_velocity := linalg.Vector2f32 {6, 6}
    ball_position := linalg.Vector2f32 {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}
    player_position := linalg.Vector2f32 {SCREEN_WIDTH / 4 - PADDLE_SIZE.x / 2, SCREEN_HEIGHT / 2 - PADDLE_SIZE.y / 2} 
    raylib.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Pong")
    raylib.SetTargetFPS(60)
    for !raylib.WindowShouldClose() {
        if raylib.IsKeyDown(raylib.KeyboardKey.UP) {
            player_position.y -= 2
        }
        else if raylib.IsKeyDown(raylib.KeyboardKey.DOWN) {
            player_position.y += 2
        }
        if ball_position.x <= 0 || ball_position.x + BALL_RADIUS / 2 >= SCREEN_WIDTH {
            ball_velocity.x *= -1
        }
        if ball_position.y <= 0 || ball_position.y + BALL_RADIUS / 2 >= SCREEN_HEIGHT {
            ball_velocity.y *= -1
        }
        ball_position += ball_velocity
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLACK)
        raylib.DrawRectangleV(player_position, PADDLE_SIZE, raylib.ORANGE)
        raylib.DrawCircleV(ball_position, BALL_RADIUS, raylib.RED)
        raylib.EndDrawing()
    }
    raylib.CloseWindow()
}