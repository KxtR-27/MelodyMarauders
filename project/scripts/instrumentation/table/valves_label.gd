extends Label

@onready var trumpet: Trumpet = self.get_parent().get_parent().get_parent()

func _process(_delta: float) -> void:
	self.text = "Valves:\n" + "".join([
		"○" if not trumpet.valve_combo[0] else "●",
		"○" if not trumpet.valve_combo[1] else "●",
		"○" if not trumpet.valve_combo[2] else "●",
	])
