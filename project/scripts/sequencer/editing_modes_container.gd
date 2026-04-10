extends HBoxContainer

@onready var activate_label : Label = $ActivateContainer/Label
@onready var deactivate_label : Label = $DeactivateContainer/Label
@onready var sustain_label : Label = $SustainContainer/Label

func _on_activate_button_button_down() -> void:
	activate_label.visible = true
	deactivate_label.visible = false
	sustain_label.visible = false

func _on_deactivate_button_button_down() -> void:
	activate_label.visible = false
	deactivate_label.visible = true
	sustain_label.visible = false


func _on_sustain_button_button_down() -> void:
	activate_label.visible = false
	deactivate_label.visible = false
	sustain_label.visible = true
