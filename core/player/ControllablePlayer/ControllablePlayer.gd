extends "res://core/player/Player.gd"

signal new_input(direction)

func _ready() -> void:
	self.grid.connect_player(self)
	TimeTravel.connect_player(self)

func _input(event: InputEvent) -> void:
	# Wait until movement is done 
	# to listen to the inputs.
	if is_moving:
		return
	
	if event.is_action_pressed("up"):
		choose_direction(Vector2.UP)
		
	if event.is_action_pressed("down"):
		choose_direction(Vector2.DOWN)
		
	if event.is_action_pressed("right"):
		choose_direction(Vector2.RIGHT)
		
	if event.is_action_pressed("left"):
		choose_direction(Vector2.LEFT)

func choose_direction(dir: Vector2):
	action_at(dir)
	emit_signal("new_input", dir)
