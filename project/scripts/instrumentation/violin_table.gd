extends VBoxContainer


@onready var violin: Violin = self.get_parent()
@onready var string_label: Label = $StateLabels/CurrentString
@onready var bow_dir_label: Label = $StateLabels/NextBowDirection


func _process(_delta: float) -> void:
	_update_string_label()
	_update_bow_dir_label()


func _update_table_labels() -> void:
	_update_string_label()
	_update_bow_dir_label()


func _update_string_label() -> void:
	if not string_label: 
		return
	
	var string_string: String = "D String"
	match (violin.open_notes_map.find_key(violin.current_open_note)):
		"violin_open_g": string_string = "G String"
		"violin_open_d": string_string = "D String"
		"violin_open_a": string_string = "A String"
		"violin_open_e": string_string = "E String"
	string_label.text = "Current String: %s" % string_string


func _update_bow_dir_label() -> void:
	if not bow_dir_label: 
		return
	else:
		bow_dir_label.text = "Move down!" if violin.last_bow_dir_was_up else "Move up!"
