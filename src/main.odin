package src

import "vendor:raylib"
import "core:math/linalg"


main :: proc() {
    PADDLE_SIZE :: linalg.Vector2f32 {30, 90}
    SCREEN_WIDTH :: 800
    SCREEN_HEIGHT :: 600
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
        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLACK)
        raylib.DrawRectangleV(player_position, PADDLE_SIZE, raylib.ORANGE)
        raylib.EndDrawing()
    }
    raylib.CloseWindow()
}