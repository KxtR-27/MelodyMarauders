class_name RadialButtonSet extends BoxContainer

@export var current_selection : Button
@export var initial_selection : Button
@export var active_stylebox : StyleBoxFlat
@export var inactive_stylebox : StyleBoxFlat

signal value_changed

func _ready() -> void:
	_apply_selection(initial_selection)
	for button in get_children():
		button.button_down.connect(func() -> void: 
			_apply_selection(button)
		)


func _apply_selection(selected_button : Button) -> void:
	current_selection = selected_button
	value_changed.emit(current_selection.text)
	
	for button in get_children():
		if button != current_selection:
			button.add_theme_stylebox_override("normal", inactive_stylebox)
		else:
			button.add_theme_stylebox_override("normal", active_stylebox)
