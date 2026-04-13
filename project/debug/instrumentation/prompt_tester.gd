extends Node2D


func _ready() -> void:
	print("instantiating prompt scene")
	var prompt: InstrumentPrompt = (load("res://components/instrumentation/instrument_prompt.tscn") as PackedScene).instantiate()
	self.add_child(prompt)
	var accuracy: float = await prompt.prompt_completed
	print("completed with accuracy of %f" % accuracy)
