extends HBoxContainer



func _on_activate_button_button_down() -> void:
	$ActivateContainer/Label.visible = true
	$DeactivateContainer/Label.visible = false
	$SustainContainer/Label.visible = false

func _on_deactivate_button_button_down() -> void:
	$ActivateContainer/Label.visible = false
	$DeactivateContainer/Label.visible = true
	$SustainContainer/Label.visible = false


func _on_sustain_button_button_down() -> void:
	$ActivateContainer/Label.visible = false
	$DeactivateContainer/Label.visible = false
	$SustainContainer/Label.visible = true
