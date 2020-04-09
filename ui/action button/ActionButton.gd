extends Button

export (String) var action_name: String = ""

func _on_ActionButton_pressed() -> void:	
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = true
	get_tree().input_event(event)


func _on_ActionButton_button_up() -> void:
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = false
	get_tree().input_event(event)
