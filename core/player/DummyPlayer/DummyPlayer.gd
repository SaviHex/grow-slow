extends "res://core/player/Player.gd"

export (Array) var input_history: Array = []

var input_index: int = 0
var starting_position: Vector2

func _ready() -> void:
	get_parent().connect("turn_ended", self, "_on_Grid_turn_ended")

func _on_Grid_turn_ended(turns_passed: int):
	advance_turn()

func get_current_action() -> Vector2:
	return input_history[input_index % input_history.size()]

func advance_turn():
	self.action_at(get_current_action())
	input_index += 1
	if input_index >= self.input_history.size():
		die()
	
func interact_with_soil(soil):
	if soil.has_plant():
		soil.interact_plant(self)
	else:
		soil.plant_seed(LoadedScenes.CornScene)

func reset():
	input_index = 0

func die():
	print("passed version died!")
#	queue_free()
