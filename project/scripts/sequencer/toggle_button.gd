class_name ToggleButton extends Button

@export var active_stylebox : StyleBoxFlat
@export var inactive_stylebox : StyleBoxFlat
@export var button_currently_toggled : bool = false

func _ready() -> void:
	if button_currently_toggled == true:
		add_theme_stylebox_override("normal", active_stylebox)
	else:
		add_theme_stylebox_override("normal", inactive_stylebox)


func _on_button_down() -> void:
	print(button_currently_toggled)
	button_currently_toggled = !button_currently_toggled
	print(button_currently_toggled)
	
	if button_currently_toggled == true:
		add_theme_stylebox_override("normal", active_stylebox)
	else:
		add_theme_stylebox_override("normal", inactive_stylebox)
