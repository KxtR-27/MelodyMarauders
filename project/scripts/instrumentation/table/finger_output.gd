extends Label

@export_enum(
	"violin_finger_first",
	"violin_finger_second",
	"violin_finger_third",
	"violin_finger_fourth"
) var finger_pos: String = "violin_finger_first"

@onready var violin: Violin = self.get_parent().get_parent().get_parent().get_parent()

func _process(_delta: float) -> void:
	self.text = violin.current_open_note.bend(Violin.finger_position_values[finger_pos]).to_string()
