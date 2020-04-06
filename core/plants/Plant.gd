extends Node2D

onready var sprite: Sprite = $Sprite
onready var anim: AnimationPlayer = $AnimationPlayer

var level: int = 0 setget set_level

# How many turns will the plant have water.
var watered_turns: int = 3
# How many turns can the plant survive w/out water.
var dry_turns: int = 5
# How many turns (with water) does it take to get to the next level.
var level_up_turns: int = 5

export(Resource) var fruit
var min_drops: int = 1
var max_drops: int = 3

var is_watered: bool = true setget set_is_watered
var turns_to_level_up: int = (level_up_turns + 1) setget set_turns_to_level_up
var turns_to_dry: int = (watered_turns + 1) setget set_turns_to_dry
var turns_to_die: int = (dry_turns + 1) setget set_turns_to_die

func _on_Player_turn_ended(turns_passed: int):
	self.advance_turn()

func advance_turn():
	if not self.is_max_level():
		if is_watered:
			self.turns_to_level_up -= 1
			self.turns_to_dry -= 1
		else:
			self.turns_to_die -= 1
#	print(name)
#	print("lv up: %d/%d" % [self.turns_to_level_up, self.level_up_turns])
#	print("dry: %d/%d" % [self.turns_to_dry, self.watered_turns])
#	print("die: %d/%d" % [self.turns_to_die, self.dry_turns])

func harvest(player):
	player.receive_item(self.fruit)
	queue_free()

func water():
	anim.play("water")
	self.is_watered = true

func set_level(value: int):
	if not self.is_max_level():
		level = value
	else:
		level = 4
	if level == 4:
		self.is_watered = true
	sprite.frame = level

func set_turns_to_level_up(value: int):
	turns_to_level_up = value
	if turns_to_level_up == 0:
		self.level += 1
		turns_to_level_up = level_up_turns + 1

func set_turns_to_dry(value: int):
	turns_to_dry = value
	if turns_to_dry == 0:
		self.is_watered = false

func set_turns_to_die(value: int):
	turns_to_die = value
	if turns_to_die == 0:
		die()

func set_is_watered(value: bool):
	is_watered = value
	if is_watered:
		self.turns_to_dry = self.watered_turns + 1
		self.turns_to_die = self.dry_turns + 1
		$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		$Sprite.modulate = Color(0.7, 0.7, 0.7, 1.0)

func get_drops_amount() -> int:
	randomize()
	return randi() % (max_drops + 1) + min_drops

func is_max_level() -> bool:
	return self.level >= 4

func die():
	print(name + " died... :'(")
	queue_free()
