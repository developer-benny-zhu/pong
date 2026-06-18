package src

import "core:math/linalg"
import "vendor:raylib"
import "core:fmt"

main :: proc() {
	PADDLE_SIZE :: linalg.Vector2f32{30, 90}
	SCREEN_WIDTH :: 800
	SCREEN_HEIGHT :: 600
	BALL_RADIUS :: 15
    PLAYER_SPEED :: 9
	ball_velocity := linalg.Vector2f32{6, 6}
	ball_position := linalg.Vector2f32{SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}
	player_position := linalg.Vector2f32 {
		SCREEN_WIDTH / 4 - PADDLE_SIZE.x / 2,
		SCREEN_HEIGHT / 2 - PADDLE_SIZE.y / 2,
	}
    enemy_position := linalg.Vector2f32 {
        (SCREEN_WIDTH * (3.0/4.0)) - (PADDLE_SIZE.x / 2), SCREEN_HEIGHT / 2 - PADDLE_SIZE.y / 2
    }
    fmt.printfln("%v", enemy_position)

	raylib.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Pong")
	raylib.SetTargetFPS(60)
	for !raylib.WindowShouldClose() {
		if raylib.IsKeyDown(raylib.KeyboardKey.UP) {
			player_position.y -= PLAYER_SPEED
		} else if raylib.IsKeyDown(raylib.KeyboardKey.DOWN) {
			player_position.y += PLAYER_SPEED
		}
		if ball_position.x <= 0 || ball_position.x + BALL_RADIUS / 2 >= SCREEN_WIDTH {
			ball_velocity.x *= -1
		}
		if ball_position.y <= 0 || ball_position.y + BALL_RADIUS / 2 >= SCREEN_HEIGHT {
			ball_velocity.y *= -1
		}
        player_position_top_left := player_position
        player_position_top_right := linalg.Vector2f32 {
            player_position.x + PADDLE_SIZE.x, player_position.y
        }
        player_position_bottom_left := linalg.Vector2f32 {
            player_position.x, player_position.y + PADDLE_SIZE.y
        }
        player_position_bottom_right := linalg.Vector2f32 {
            player_position.x + PADDLE_SIZE.x, player_position.y + PADDLE_SIZE.y
        }
		if check_line_circle_collision(
			player_position_top_right,
			player_position_bottom_right,
            ball_position,
			BALL_RADIUS,
		) {
            ball_velocity.x *= -1
        }
        if check_line_circle_collision(
            player_position_top_left,
            player_position_top_right,
            ball_position,
            BALL_RADIUS

        ) || check_line_circle_collision(
            player_position_bottom_left, player_position_bottom_right, ball_position, BALL_RADIUS
        ) {
            ball_velocity.y *= -1
        }
		ball_position += ball_velocity
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.BLACK)
		raylib.DrawRectangleV(player_position, PADDLE_SIZE, raylib.ORANGE)
        raylib.DrawRectangleV(enemy_position, PADDLE_SIZE, raylib.PURPLE)
		raylib.DrawCircleV(ball_position, BALL_RADIUS, raylib.RED)
		raylib.EndDrawing()
	}
	raylib.CloseWindow()
}
check_line_circle_collision :: proc(
	p1: linalg.Vector2f32,
	p2: linalg.Vector2f32,
	circle_center: linalg.Vector2f32,
	radius: f32,
) -> bool {
	vx := p2.x - p1.x
	vy := p2.y - p1.y

	wx := circle_center.x - p1.x
	wy := circle_center.y - p1.y
	dot_wv := (wx * vx) + (wy * vy)
	dot_vv := (vx * vx) + (vy * vy)

	if dot_vv == 0 {
		dist_sq :=
			(circle_center.x - p1.x) * (circle_center.x - p1.x) +
			(circle_center.y - p1.y) * (circle_center.y - p1.y)
		return dist_sq <= (radius * radius)
	}

	t := dot_wv / dot_vv
	if t < 0.0 do t = 0.0
	if t > 1.0 do t = 1.0

	closest_x := p1.x + (t * vx)
	closest_y := p1.y + (t * vy)

	dist_x := circle_center.x - closest_x
	dist_y := circle_center.y - closest_y
	dist_sq := (dist_x * dist_x) + (dist_y * dist_y)
	return dist_sq <= (radius * radius)
}
