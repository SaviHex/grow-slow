extends "res://core/pawn/Pawn.gd"

signal used_turn

onready var move_tween: Tween = $MoveTween
onready var anim: AnimationPlayer = $AnimationPlayer
onready var item_icon: Sprite = $ItemIcon

var is_moving: bool = false
var tile_size: int = 16

onready var item_anim: AnimationPlayer = $ItemIcon/ItemIconAnimation

func _ready() -> void:
	self.grid.connect_player(self)

func _input(event: InputEvent) -> void:
	# Wait until movement is done 
	# to listen to the inputs.
	if is_moving:
		return
	
	if event.is_action_pressed("up"):
		action_at(Vector2.UP)
		
	if event.is_action_pressed("down"):
		action_at(Vector2.DOWN)
		
	if event.is_action_pressed("right"):
		action_at(Vector2.RIGHT)
		
	if event.is_action_pressed("left"):
		action_at(Vector2.LEFT)

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
			emit_signal("used_turn")
	

func interact_with_soil(soil):
	if soil.has_plant():
		soil.interact_plant(self)
	else:
		var plant_chosen = yield(self.grid.main.show_plant_dialog(), "completed")
		if plant_chosen != "":
			soil.plant_seed(LoadedScenes.CornScene)
			emit_signal("used_turn")

func bump():
	anim.play("bump")
	emit_signal("used_turn")

func move_to(dir: Vector2):
	self.coordinates += dir
	var target = self.position + (dir  * self.tile_size)
	move_tween.interpolate_property(self, "position", self.position, target, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	anim.play("walk")
	move_tween.start()
	emit_signal("used_turn")
	
func receive_item(item):
	self.item_icon.texture = item.icon
	item_anim.stop()
	item_anim.play("get_item")
	print("Player got a " + item.name)

func _on_MoveTween_tween_started(object: Object, key: NodePath) -> void:
	self.is_moving = true

func _on_MoveTween_tween_completed(object: Object, key: NodePath) -> void:
	self.is_moving = false
