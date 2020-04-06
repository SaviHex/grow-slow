extends "res://core/pawn/Pawn.gd"

# Soil nodes stay inside a container. 
func _on_ready() -> void:
	self.grid = get_parent().get_parent()
	coordinates = self.grid.from_global_to_coordinate(self.position)
	self.grid.init_pawn(self)

func plant_seed(PlantScene: PackedScene):
	var plant = PlantScene.instance()
	$PlantContainer.add_child(plant)
	self.grid.connect("turn_ended", plant, "_on_Player_turn_ended")
	print(name + ":planted a " + plant.name)

func interact_plant(player):
	var plant = self.get_plant()
	if plant.is_max_level():
		plant.harvest(player)
	else:
		plant.water()

func has_plant() -> bool:
	return $PlantContainer.get_child_count() > 0

func get_plant() -> Node:
	return $PlantContainer.get_child(0)
