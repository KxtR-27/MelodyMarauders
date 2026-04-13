@tool
class_name ViolinStateDisplay
extends Label

@export var violin: ViolinController

func _process(_delta: float) -> void:
	if !violin:
		text = "await violin connection..."
	else:
		var next_bow_dir: String = "Play a down bow!" if violin.last_bow_dir_was_up else "play an up bow!"
		var current_open_note: String = violin.current_open_note.to_string()
		
		var current_finger_pos_string: String = ""
		match (violin.current_finger_position):
			0: current_finger_pos_string = "open"
			2: current_finger_pos_string = "1st"
			4: current_finger_pos_string = "2nd"
			5: current_finger_pos_string = "3rd"
			7: current_finger_pos_string = "4th"
		var parsed_finger_pos: String = "Finger position: %s" % current_finger_pos_string
		
		text = "\n".join([next_bow_dir, current_open_note, parsed_finger_pos])
