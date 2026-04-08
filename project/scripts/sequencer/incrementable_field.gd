class_name IncrementableField extends HBoxContainer

@export var current_value : int = 0
@export var starting_value : int = 0
@export var descriptor : String = "Placeholder"

signal value_changed

func _ready() -> void:
	current_value = starting_value
	$Descriptor.text = descriptor + ": "
	$LineEdit.text = str(current_value)


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		current_value = new_text.to_int()
		value_changed.emit(current_value)
	else:
		$LineEdit.text = str(current_value)


func _on_increment_button_button_down() -> void:
	current_value += 1
	value_changed.emit(current_value)
	$LineEdit.text = str(current_value)


func _on_decrement_button_button_down() -> void:
	current_value -= 1
	value_changed.emit(current_value)
	$LineEdit.text = str(current_value)


func get_value() -> int:
	var current_text : String = $LineEdit.text
	var string_to_int : int = current_text.to_int() if current_text.is_valid_int() else 0
	return string_to_int
