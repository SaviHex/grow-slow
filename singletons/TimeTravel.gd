extends Node

var DummyPlayer: PackedScene = preload("res://core/player/DummyPlayer/DummyPlayer.tscn")

var current_input_history: Array = []
var current_player: Node2D
var spawn_postion: Vector2

var time_travels_left: int = 2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("time_travel"):
		time_travel()

func connect_player(player):
	current_player = player
	spawn_postion = player.position
	current_player.connect("new_input", self, "_on_Player_new_input")

func _on_Player_new_input(input: Vector2):
	current_input_history.push_back(input)
	
func time_travel():
	# Reset grid
	self.current_player.get_parent().reset_grid()
	make_new_dummy_player()

func make_new_dummy_player():
	var new_dummy = DummyPlayer.instance()
	new_dummy.input_history = current_input_history
	new_dummy.position = spawn_postion
	self.current_player.get_parent().add_child(new_dummy)
	current_input_history = []
	time_travels_left -= 1
	self.spawn_postion = self.current_player.position
