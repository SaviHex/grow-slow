extends CanvasModulate

export var day_value: float = 0.0 setget set_day_value
export var day_turns: int = 100

export(Gradient) var color_gradient: Gradient

onready var time_step: float

func _ready() -> void:
	self.time_step = (1.0 / self.day_turns)

func advance_time():
	self.day_value += self.time_step

func set_day_value(value: float):
	day_value = clamp(value, 0, 1)
	self.color = color_gradient.interpolate(self.day_value)
