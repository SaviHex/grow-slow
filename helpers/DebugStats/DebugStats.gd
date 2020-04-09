extends CanvasLayer

onready var fps_counter: Label = $Container/FPSCounter


func _process(delta: float) -> void:
	fps_counter.text = "FPS: %d" % Engine.get_frames_per_second()
