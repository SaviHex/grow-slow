extends "res://core/pawn/Pawn.gd"

signal used_turn

onready var move_tween: Tween = $MoveTween
onready var anim: AnimationPlayer = $AnimationPlayer
onready var item_icon: Sprite = $ItemIcon

var is_moving: bool = false
var tile_size: int = 16

onready var item_anim: AnimationPlayer = $ItemIcon/ItemIconAnimation

export(bool) var waste_turn: bool

func action_at(dir: Vector2):
	var obstacle: Node2D = self.grid.object_at(self.coordinates + dir)
	
	if obstacle == null:
		move_to(dir)
	elif obstacle.is_in_group("wall"):
		bump()
	else:
		if obstacle.is_in_group("soil"):
			interact_with_soil(obstacle)
		else:
			print("what is this? --> " + str(obstacle.name))
			end_turn()
	

func interact_with_soil(soil):
	if soil.has_plant():
		soil.interact_plant(self)
	else:
		var plant_chosen = yield(self.grid.main.show_plant_dialog(), "completed")
		if plant_chosen != "":
			soil.plant_seed(LoadedScenes.CornScene)
	end_turn()

func bump():
	anim.play("bump")
	end_turn()

func move_to(dir: Vector2):
	self.coordinates += dir
	var target = self.position + (dir  * self.tile_size)
	move_tween.interpolate_property(self, "position", self.position, target, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	anim.play("walk")
	move_tween.start()
	end_turn()
	
func receive_item(item):
	self.item_icon.texture = item.icon
	item_anim.stop()
	item_anim.play("get_item")
	print("Player got a " + item.name)

func end_turn():
	if self.waste_turn:
		emit_signal("used_turn")

func _on_MoveTween_tween_started(object: Object, key: NodePath) -> void:
	self.is_moving = true

func _on_MoveTween_tween_completed(object: Object, key: NodePath) -> void:
	self.is_moving = false
