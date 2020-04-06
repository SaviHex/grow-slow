extends Node2D

signal updated_coords(old, new, me)

# Object that will keep track of all the grid's pawns. 
var grid

var coordinates: Vector2 setget set_coords

func _ready() -> void:
	_on_ready()
	
# Override this function to change the _ready() function!
# https://github.com/godotengine/godot/issues/6500#issuecomment-247369990
func _on_ready():
	self.grid = get_parent()
	coordinates = self.grid.from_global_to_coordinate(self.position)
	self.grid.init_pawn(self)
	
	
func set_coords(value: Vector2):
	emit_signal("updated_coords", coordinates, value, self)
	coordinates = value
	
