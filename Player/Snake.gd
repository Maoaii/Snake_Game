extends TileMap

signal check_apple_eaten

const SNAKE_HEAD = 0
const SNAKE_TAIL = 1
const BOARD_WIDTH = 16
const BOARD_HEIGHT = 16

var DIRECTIONS = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

var snake_body = [Vector2(7, 8), Vector2(6, 8), Vector2(5, 8)]
var previousHead = snake_body[SNAKE_HEAD]
var direction = Vector2.RIGHT
var prevDirection = Vector2.RIGHT
var just_ate = false

func _ready():
	# Set snake on starting position
	draw_snake()

# Update snake's position and draw the snake after X seconds
func _on_Timer_timeout():
	move_snake()
	check_death()
	draw_snake()

func _unhandled_input(event):
	for dir in DIRECTIONS.keys():
		if event.is_action_pressed(dir):
			var newDirection = DIRECTIONS[dir]
			# If the new direction doesn't make the snake go back into itself
			if (newDirection != -direction and newDirection != -prevDirection):
				direction = newDirection


# Updates the snake's body
func move_snake():
	# Remove snake's last segment drawing
	set_cell(snake_body[snake_body.size()-1].x, snake_body[snake_body.size()-1].y, -1)
	
	# Remove snake's last segment if didin't eat the apple
	if (!just_ate):
		snake_body.remove(snake_body.size() - 1)
	just_ate = false
	
	# Insert new head in movement direction
	snake_body.push_front(Vector2(previousHead.x + direction.x, previousHead.y + direction.y))
	
	# Update "previousHead" position
	previousHead = snake_body[0]
	
	# Set previous direction to current movement direction
	prevDirection = direction

# Draws the snake
func draw_snake():
	for snake_segment in snake_body:
	
		# Draw snake head
		if (snake_segment == snake_body[0]):
			# Declare variables that rotate the snake's head based on movement direction
			var faceSnakeUp = [false, true, true]
			var faceSnakeDown = [false, false, true]
			var faceSnakeLeft = [true, false, false]
			
			if (direction == DIRECTIONS.up):
				set_cell(snake_segment.x, snake_segment.y, SNAKE_TAIL, 
						faceSnakeUp[0], faceSnakeUp[1], faceSnakeUp[2])
			
			elif (direction == DIRECTIONS.down):
				set_cell(snake_segment.x, snake_segment.y, SNAKE_TAIL, 
						faceSnakeDown[0], faceSnakeDown[1], faceSnakeDown[2])
			
			elif (direction == DIRECTIONS.left):
				set_cell(snake_segment.x, snake_segment.y, SNAKE_TAIL, 
						faceSnakeLeft[0], faceSnakeLeft[1], faceSnakeLeft[2])
			
			else:
				set_cell(snake_segment.x, snake_segment.y, SNAKE_TAIL)
		
		# Draw snake tail
		else:
			set_cell(snake_segment.x, snake_segment.y, SNAKE_HEAD)
	
	emit_signal("check_apple_eaten", snake_body)


func check_death():
	# Out of bounds death
	if (snake_body[SNAKE_HEAD].x >= BOARD_WIDTH or snake_body[SNAKE_HEAD].x < 0 or
		snake_body[SNAKE_HEAD].y >= BOARD_HEIGHT or snake_body[SNAKE_HEAD].y < 0):
		var currentSceneName = get_tree().get_current_scene().filename
		get_tree().change_scene(currentSceneName)
	
	# Bite own tail death
	for snake_segment in range(snake_body.size()):
		if snake_segment > SNAKE_HEAD and snake_body[snake_segment] == snake_body[SNAKE_HEAD]:
			var currentSceneName = get_tree().get_current_scene().filename
			get_tree().change_scene(currentSceneName)

func _on_Apple_eaten():
	just_ate = true

