extends Node2D

onready var fire_particle: Particles2D = $FireParticle
onready var light_up_particle: Particles2D = $LightUpParticle
onready var anim: AnimationPlayer = $AnimationPlayer
onready var light_sprite: Sprite = $LightSprite

export (int) var light_up_at_turn: int = 60

var is_lit: bool = false

func _ready() -> void:
	turn_off()
	get_parent().connect("turn_ended", self, "_on_Grid_turn_ended")

func _on_Grid_turn_ended(turn):
	if turn >= self.light_up_at_turn and not is_lit:
		turn_on()

func turn_on():
	is_lit = true
	light_up_particle.emitting = true
	anim.play("light_up")
	fire_particle.emitting = true
	
func turn_off():
	is_lit = false
	light_sprite.self_modulate = Color.transparent
	fire_particle.emitting = false
