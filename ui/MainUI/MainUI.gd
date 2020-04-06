extends CanvasLayer

onready var turns_counter: Label = $TopUI/TurnsCounterContainer/TurnsCounter

func _on_Grid_turn_ended(current_turn) -> void:
	self.turns_counter.text = str(current_turn)
