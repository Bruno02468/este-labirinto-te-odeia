extends Control

@export var time_left: float = 60.0  # seconds

var stopTimer : bool = false

signal TimeUp

func _process(delta: float) -> void:
	if not(stopTimer):
		if time_left > 0.0:
			time_left -= delta
			time_left = max(time_left, 0.0)  # prevent negative values
			self.text = format_time(time_left)
		else:
			TimeUp.emit()

func format_time(seconds: float) -> String:
	@warning_ignore("integer_division")
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]
