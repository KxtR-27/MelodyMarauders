extends Label

@export_enum(
	"open",
	"violin_finger_first",
	"violin_finger_second",
	"violin_finger_third",
	"violin_finger_fourth"
) var finger_pos: String = "violin_finger_first"
@export var use_open_instead := false

@onready var violin: Violin = self.get_parent().get_parent().get_parent().get_parent()

func _process(_delta: float) -> void:
	if not use_open_instead:
		self.text = violin.current_open_note.bend(Violin.finger_position_values[finger_pos]).to_string()
	else:
		self.text = violin.current_open_note.to_string()
