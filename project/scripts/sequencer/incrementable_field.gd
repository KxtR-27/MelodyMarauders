class_name IncrementableField extends HBoxContainer

@export var current_value : int = 0
@export var starting_value : int = 0
@export var descriptor : String = "Placeholder"

@onready var descriptor_label : Label = $Descriptor
@onready var line_edit : LineEdit = $LineEdit

signal value_changed

func _ready() -> void:
	current_value = starting_value
	descriptor_label.text = descriptor + ": "
	line_edit.text = str(current_value)


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		current_value = new_text.to_int()
		value_changed.emit(current_value)
	else:
		line_edit.text = str(current_value)


func _on_increment_button_button_down() -> void:
	current_value += 1
	value_changed.emit(current_value)
	line_edit.text = str(current_value)


func _on_decrement_button_button_down() -> void:
	current_value -= 1
	value_changed.emit(current_value)
	line_edit.text = str(current_value)


func get_value() -> int:
	var current_text : String = line_edit.text
	var string_to_int : int = current_text.to_int() if current_text.is_valid_int() else 0
	return string_to_int
