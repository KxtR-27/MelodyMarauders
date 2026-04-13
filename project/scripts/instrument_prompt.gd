class_name InstrumentPrompt
extends Control

signal prompt_completed(accuracy: float)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip_prompt"):
		prompt_completed.emit(1.0)
		self.queue_free()
