extends CanvasLayer

signal item_choosed(item)

onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$ViewHolder.visible = false
	connect_buttons()

func connect_buttons():
	var btns = $ViewHolder/PanelContainer/ChoicePanel/ButtonContainer.get_children()
	for btn in btns:
		btn.connect("pressed", self, "_on_ItemButton_pressed", [btn.text])

func show():
	$ViewHolder.visible = true
	anim.play("open")
	
func hide():
	anim.play_backwards("open")
	yield(anim, "animation_finished")
	$ViewHolder.visible = false

func _on_ItemButton_pressed(item) -> void:
	hide()
	emit_signal("item_choosed", item)

func _on_CancelButton_pressed() -> void:
	hide()
	emit_signal("item_choosed", "")
