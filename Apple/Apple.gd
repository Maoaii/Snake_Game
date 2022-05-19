extends TileMap

signal eaten

const BOARD_WIDTH = 16
const BOARD_HEIGHT = 16

var apple_pos = Vector2()

func _ready():
	# Seed the the random function
	randomize()
	
	# Draw apple's starting position
	apple_pos = Vector2(randi() % BOARD_WIDTH, randi() % BOARD_HEIGHT)
	# Draw apple
	set_cell(apple_pos.x, apple_pos.y, 0)
	


func _on_Snake_check_apple_eaten(snake_body):
	if snake_body[0] == apple_pos:
		draw_apple(snake_body)
		emit_signal("eaten")


func draw_apple(snake_body):
	# Remove last apple position
	set_cell(apple_pos.x, apple_pos.y, -1)
	
	# New apple position
	while (apple_pos in snake_body):
		apple_pos = Vector2(randi() % BOARD_WIDTH, randi() % BOARD_HEIGHT)
	
	# Draw apple
	set_cell(apple_pos.x, apple_pos.y, 0)
