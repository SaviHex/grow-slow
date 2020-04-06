extends Node2D

onready var plant_dialog: CanvasLayer = $PlantDialog

func show_plant_dialog() -> String:
	plant_dialog.show()
	return yield(plant_dialog, "item_choosed")

