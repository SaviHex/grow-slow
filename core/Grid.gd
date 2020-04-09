extends Node2D

signal turn_ended(current_turn)

export(int) var turns_passed: int = 0
export (int) var tile_size: int = 16
export(Vector2) var offset: Vector2 = Vector2.ZERO
export(Vector2) var grid_size: Vector2 = Vector2.ZERO

var grid_data: Array = []

onready var main: Node2D = get_parent()
onready var day_night_cycle = $DayNightCycle

func _enter_tree():
	init_grid_data(self.grid_size.x, self.grid_size.y)

func object_at(pos: Vector2) -> Node2D:
	if is_out_of_bounds(pos):
		return self # The grid is a wall.
	else: 
		return self.grid_data[pos.x][pos.y]

func is_out_of_bounds(coord: Vector2) -> bool:
	return (coord.x >= self.grid_size.x 
			or coord.y >= self.grid_size.y
			or coord.x < 0 or coord.y < 0)

func init_grid_data(width: int, height: int):
	self.grid_data = []
	
	for y in range(width):
		var row = []
		row.resize(height)
		self.grid_data.append(row)

func from_global_to_coordinate(global_pos: Vector2) -> Vector2:
	return (global_pos - (offset + Vector2(tile_size/2, tile_size/2))) / self.tile_size

func from_coordinate_to_global(coord: Vector2) -> Vector2:
	return (coord * self.tile_size) + (offset - Vector2(tile_size/2, tile_size/2)) 

func init_pawn(pawn: Node2D):
	pawn.connect("updated_coords", self, "_on_Pawn_updated_coords")
	self.grid_data[pawn.coordinates.x][pawn.coordinates.y] = pawn

func connect_player(player):
	player.connect("used_turn", self, "_on_Player_used_turn")

func _on_Player_used_turn():
	self.turns_passed += 1
	self.day_night_cycle.advance_time()
	emit_signal("turn_ended", self.turns_passed)

func _on_Pawn_updated_coords(old, new, me):
	self.grid_data[old.x][old.y] = null
	self.grid_data[new.x][new.y] = me

func reset_grid():
	self.turns_passed = 0
	emit_signal("turn_ended", self.turns_passed)
	
	# Reset Day/Night Cycle
	self.day_night_cycle.day_value = 0
	
	turn_off_lights()
	reset_soil_tiles()
	
func turn_off_lights():
	for torch in get_tree().get_nodes_in_group("torch"):
		torch.turn_off()
	
func reset_soil_tiles():
	for soil in $SoilContainer.get_children():
		soil.reset_soil()
